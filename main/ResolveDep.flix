 /*
 * Copyright 2021 Magnus Madsen
 * Copyright 2021 Zhiwei Zeng
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use Pkger/PackageInfo.{PackageInfo,comparePackageInfo};
use Pkger/PackageInfo.PackageInfo.PackageInfo;
use Pkger/PackageInfo.{pinfogetname, pinfogetversion,pinfogetdependencies};
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.{PackageDependency,getPackageName};

namespace Pkger{
    namespace ResolveDep{

        //
        // check if the package exist in the registry, if it exist get it's dependencies and subdependencies. 
        //
        pub def getFullDependencies(registry: Map[String,List[PackageInfo]],pset: Set[PackageDependency],packagename: String): Result[Set[PackageDependency],String] & Impure= 
            use Result.flatMap;
            let keys = Map.keysOf(registry);
            if (Set.memberOf(packagename,keys)) {
                let value = Map.get(packagename,registry);
                let* packageinfolist = Option.toOk(value,"The package does not exist");
                let* sortedlist = sortPackageInfo(packageinfolist);

                let packageinfo = match List.head(packageinfolist) {
                    case None => ???
                    case Some(x) => x
                };
            
                let deplist = pinfogetdependencies(packageinfo);
                if (deplist == Nil) {
                    Ok(pset)   
                }
                else {
                    // newplist is the dependencies of the current package, for each of the dependented package call getFullDependencies to get their dependencies recursively 
                    let depset = List.toSet(deplist);
                    let newpset = Set.union(depset,pset);
                    let depnames = Set.map(getPackageName,depset);
                    let recurlist = Set.map(getFullDependencies(registry,newpset),depnames);
                    let recurlist2 = Set.toList(recurlist);
                    let recurlist3 = Result.sequence(recurlist2);
                    match recurlist3 {
                        case Ok(myset) => let result = List.toSet(myset);
                                            Ok(Set.flatten(result))
                        case Err(x) => Err(x)
                    }}
            }
            else {
                Err("package ${packagename} is not exist")
            }      


        pub def sortPackageInfo(list: List[PackageInfo]): Result[List[PackageInfo],String] = 
            //TODO  List.sortWith(comparePackageInfo,list)  comparePackageInfo is f -> Result[int32] how to make it f -> int32
            Ok(List.sortWith(comparePackageInfo,list)) 
            
    }
}