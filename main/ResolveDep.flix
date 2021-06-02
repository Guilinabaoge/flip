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
use Pkger/SemVer.{SemVer,isAdaptable,lessEqual};
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.{PackageDependency,getPackageName,getMaxVer,getMinVer};
use Pkger/Examples.{entities2};
use Pkger/Repository.Repository.Repository;
use Pkger/Repository.Repository;

namespace Pkger{
    namespace ResolveDep{

        //
        // check if the package exist in the registry, if it exist get it's dependencies and subdependencies. 
        // Map[String,List[PackageInfo]]
        pub def solver(repo: Repository,pset: Set[PackageInfo],packagename: String): Result[Set[PackageInfo],String] & Impure= 
            use Result.flatMap;
            let Repository(registry) = repo;
            let keys = Map.keysOf(registry);
            if (Set.memberOf(packagename,keys)) {
                let value = Map.get(packagename,registry);
                let* packageinfolist = Option.toOk(value,"The package does not exist");
                let* sortedlist = sortPackageInfo(packageinfolist);

                let* packageinfo = Option.toOk(List.last(sortedlist),"The package does not exist");
            
                let deplist = pinfogetdependencies(packageinfo);
                if (deplist == Nil) {
                    Ok(pset)   
                }
                else {
                    // newplist is the dependencies of the current package, for each of the dependented package call getFullDependencies to get their dependencies recursively 
                    let depset = List.toSet(deplist);
                    let recurlist = Set.map(detversion(registry),depset);
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
        
        //
        // If the given dependency don't have subdependency, return the newest version of it. If it have subdependency, return newest subdependency as well
        //
        pub def detversion(registry: Map[String,List[PackageInfo]],dependency: PackageDependency): Result[Set[PackageInfo],String] & Impure= 
        use Result.flatMap;
            let* result = findNewest(registry,dependency);
            let resultdep = pinfogetdependencies(result);
            let resultdepset = List.toSet(resultdep);
            if (resultdep == Nil) {
                Ok(Set#{result})
            }
            else {
                let recresult1 = Set.map(detversion(registry),resultdepset);
                let recresult2 = Set.toList(recresult1);
                let recresult3 = Result.sequence(recresult2);
                match recresult3 {
                    case Ok(myset) => let a = List.toSet(myset);
                                      let b = Set.flatten(a);
                                      let c = Set.union(Set#{result},b);
                                      Ok(c)
                    case Err(x) => Err(x)
                }
            }
        
        //
        // Find the newest version of the dependency available in the registry under the restricitions 
        //
        pub def findNewest(registry:Map[String,List[PackageInfo]],dependency: PackageDependency): Result[PackageInfo,String] & Impure= 
        use Result.flatMap;
            let packagename = getPackageName(dependency);
            let* packagelist = Option.toOk(Map.get(packagename,registry),"${packagename} is not exist");
            let minversion = getMinVer(dependency);
            let maxversion = getMaxVer(dependency);
            let* sortedlist = sortPackageInfo(packagelist);
            findNewestHelper(sortedlist,minversion,maxversion,SemVer(0,0,0),sortedlist)
        
        //
        //If maxver is not set, find the newest Major adapt version. Else find the newest version according to maxver.
        //
        def findNewestHelper(sortedlist: List[PackageInfo],minver: SemVer, maxver: Option[SemVer],bestsofar: SemVer, originlist: List[PackageInfo]): Result[PackageInfo,String] & Impure= 
        use Result.flatMap;
        if (maxver == None){
            match sortedlist {
                case x :: rest => 
                    if (isAdaptable(pinfogetversion(x),minver)) {
                        findNewestHelper(rest,minver,maxver,pinfogetversion(x),originlist)
                    }
                    else {
                        findNewestHelper(rest,minver,maxver,bestsofar,originlist)
                    }
                case Nil => findPinfoByVersion(originlist,bestsofar)
            }
        }
        else {
            let* realmaxver = Option.toOk(maxver,"Must set maxver");
            match sortedlist {
                case x :: rest => 
                    if (lessEqual(realmaxver,pinfogetversion(x))) {
                        findNewestHelper(rest,minver,maxver,pinfogetversion(x),originlist)
                    }
                    else {
                        findNewestHelper(rest,minver,maxver,bestsofar,originlist)
                    }
                case Nil => findPinfoByVersion(originlist,bestsofar)
            }
        }
            

        //
        // Give the Semver return packageinfo if the required version is in the registry
        //
        def findPinfoByVersion(sortedlist: List[PackageInfo], target: SemVer): Result[PackageInfo,String] & Impure = 
            match sortedlist {
                case x :: rest =>
                    if (pinfogetversion(x) == target) {
                        Ok(x)
                    } 
                    else {
                        findPinfoByVersion(rest,target)
                    }
                case Nil => Err("package dont have such version}")
            }


        pub def sortPackageInfo(list: List[PackageInfo]): Result[List[PackageInfo],String] = 
            Ok(List.sortWith(comparePackageInfo,list)) 
            
    }
}