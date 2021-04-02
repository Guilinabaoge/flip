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
        pub def getFullDependencies(registry: Map[String,PackageInfo],plist: List[PackageDependency],packagename: String): List[PackageDependency] & Impure= 
            use Result.flatMap;
            let keys = Map.keysOf(registry);
            if (Set.memberOf(packagename,keys)) {
                let packageinfo = match Map.get(packagename,registry){
                    case None => ???
                    case Some(x) => x
                };
                
                let deplist = pinfogetdependencies(packageinfo);
                if (deplist == Nil) {
                    plist   
                }
                else {
                    let newplist = deplist ::: plist;
                    let depnames = List.map(getPackageName,deplist);
                    let recurlist = List.map(getFullDependencies(registry,newplist),depnames);
                    //TODO when you have a list of List[Result[A]] how can u turn it to List[A]?
                    let result = List.flatten(recurlist);
                    let set = List.toSet(result);
                    Set.toList(set)  
                }
            }
            else {
                ???
                //Err("package ${packagename} is not exist")
            }
        
        /// def getFullpathelper(registry: Map[String,PackageInfo], _deplist: List[PackageDependency],packagename: String): Result[List[PackageDependency],String] = 
        ///     let keys = Map.keysOf(registry);
        ///     if (Set.memberOf(packagename,keys)) {
        ///         Ok(PackageDependency({name = "entities", version = SemVer(2,2,0)})::Nil)
        ///     }
        ///     else {
        ///         Err("Package ${packagename} is not exist")
        ///     }
            
            
    }
}