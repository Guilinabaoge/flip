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

use Pkger/PackageInfo.PackageInfo;
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
        // check if the package exist in the registry, if it exist get it's dependencies and subdependencies 
        //
        pub def getFullDependencies(registry: Map[String,List[PackageInfo]],plist: List[PackageDependency],packagename: String): Result[List[PackageDependency],String] & Impure= 
            use Result.flatMap;
            let keys = Map.keysOf(registry);
            if (Set.memberOf(packagename,keys)) {
                let packageinfolist  = match Map.get(packagename,registry){
                    case None => ??? //TODO is there a way to return an error here? since the packageinfo is not in the map
                    case Some(x) => x
                };

                let packageinfo = match List.head(packageinfolist) {
                    case None => ???
                    case Some(x) => x
                };
            
                let deplist = pinfogetdependencies(packageinfo);
                if (deplist == Nil) {
                    Ok(plist)   
                }
                else {
                    // newplist is the dependencies of the current package, for each of the dependented package call getFullDependencies to get their dependencies recursively 
                    let newplist = deplist ::: plist;
                    let depnames = List.map(getPackageName,deplist);
                    let recurlist = List.map(getFullDependencies(registry,newplist),depnames);
                    let recurlist2 = Result.sequence(recurlist);
                    match recurlist2 {
                        case Ok(mylist) => let result = List.flatten(mylist);
                                            let set = List.toSet(result);
                                            Ok(Set.toList(set))  
                        case Err(_) => ???
                    }
                    
                }
            }
            else {
                Err("package ${packagename} is not exist")
            }            
            
    }
}