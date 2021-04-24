/*
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
use Pkger/PackageInfo.{PackageInfo,comparePackageInfo,pinfogetversion};
use Pkger/PackageInfo.PackageInfo.PackageInfo;
use Pkger/Examples.examplePackage1;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.PackageDependency;
use Pkger/Lex.{stringifySemver,stringifyAuthors,stringifyDependency,stringifyPackageInfo,lex};
use Pkger/JSONParser.{parse,json2author,jstring2string,jstring2Semver,json2Dependency,json2PackageInfo};
use Pkger/JSON.JSON.{JObject,JString,JArray};
use Pkger/Examples.{fakeregister,bottleneckp,bottleneckp2,crawler,bottleneckp3,bottleneckp4,boolbase,css_what,entities,cheerio,cheerio_select,
    css_select,request,caseless,extend,json_stringify_safe,entities2,testconflicts,conflictA,conflictB,maxver,maxver2};
use Pkger/ResolveDep.{getFullDependencies,sortPackageInfo};

namespace Pkger/ResolveDep{
    @test 
    def testResolveDep01(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => match getFullDependencies(x,Set#{},"entities") {
                case Ok(i) => i == Set#{}
                case Err(_) => false
            } 
            case Err(_) => false
        }
    
    @test 
    def testResolveDep02(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => 
            let set = match getFullDependencies(x,Set#{},"css-select") {
                case Ok(i) => i
                case Err(_) => Set#{}
            };
            let expectset = Set#{boolbase(),css_what(),entities()};
            //set |> println;
            //expectset |> println;
            set == expectset
            case Err(_) => false
        }
    
    @test 
    def testResolveDep03(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => 
            let set = match getFullDependencies(x,Set#{},"crawler") {
                case Ok(i) => i
                case Err(_) => Set#{}
            };
            let expectset = Set#{
                bottleneckp(),cheerio(),cheerio_select(),css_select(),boolbase(),css_what(),entities(),request(),caseless(),extend(),json_stringify_safe()
            };
            set == expectset
            case Err(_) => false
        }
    
    @test 
    def testResolveDep04(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => 
            let set = match getFullDependencies(x,Set#{},"css-what") {
                case Ok(i) => i
                case Err(_) => Set#{}
            };
            let expectset = Set#{entities()};
            set == expectset
            case Err(_) => false
        }
    
    //
    //testconflicts have dependencies conflict A and conflict B. Both A and B dependent on entities but with different version. A is with SemVer(2,4,1) B is with SemVer(2,2,2)
    //the dependency solver should return the result contain only entities with SemVer(2,4,1)
    //
    @test 
    def testResolveDep05(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => 
            let set = match getFullDependencies(x,Set#{},"testconflicts") {
                case Ok(i) => i
                case Err(_) => Set#{}
            };
            let expectset = Set#{entities(),conflictA(),conflictB()};
            //expectset |> println;
            //Set.difference(expectset,set)|> println;
            set == expectset
            case Err(_) => false
        }
    
    //
    // testMaxver depend on package maxver with minver SemVer(2,2,2) and maxver SemVer(5,0,0). In the test registry there is (2,2,2) and (4,0,0) two versions of maxver,
    // the solver should return version (4,0,0) as result
    //
    @test 
    def testResolveDep06(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => 
            let set = match getFullDependencies(x,Set#{},"testMaxver") {
                case Ok(i) => i
                case Err(_) => Set#{}
            };
            let expectset = Set#{maxver2()};
            //expectset |> println;
            set |> println; 
            //expectset |> println;
            set == expectset
            case Err(_) => false
        }
    
    //
    // p1 have older version than p2 it should return false 
    //
    @test 
    def testComparePackageInfo01(): Bool= 
        let p1 = bottleneckp();
        let p2 = bottleneckp2();
        comparePackageInfo(p1,p2) == 0
    
    //
    // p1 and p2 are different package, should return false
    //
    @test 
    def testComparePackageInfo02(): Bool = 
        let p1 = bottleneckp();
        let p2 = crawler();
        comparePackageInfo(p1,p2) == 9

     @test 
    def testSortPackageInfo01(): Bool =
        let list = bottleneckp2() :: bottleneckp()::Nil;
        match sortPackageInfo(list) {
            case Ok(x) =>  
            match x {
                case x1::_x2::Nil => pinfogetversion(x1) == SemVer(1,1,3)
                case _ => false
            }
            case Err(_) => false
        }

    @test 
    def testSortPackageInfo02(): Bool =
        let list = bottleneckp() :: bottleneckp2() ::bottleneckp3()::bottleneckp4():: Nil;
        match sortPackageInfo(list) {
            case Ok(x) =>  
            match x {
                case _x1::x2::x3::_x4::Nil => pinfogetversion(x2) == SemVer(1,5,2) and pinfogetversion(x3) == SemVer(1,5,3)
                case _ => false
            }
            case Err(_x) => false
        }
    
}
  