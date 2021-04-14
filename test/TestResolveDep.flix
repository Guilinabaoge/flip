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
use Pkger/Examples.{fakeregister,bottleneckp,bottleneckp2,crawler,bottleneckp3,bottleneckp4};
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
            let expectset = Set#{PackageDependency({name = "boolbase", version = SemVer(1,0,0),maxversion = None}),
                                PackageDependency({name = "css-what", version = SemVer(5,0,0),maxversion = None}),
                                PackageDependency({name = "entities", version = SemVer(2,2,0),maxversion = None})};
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
                PackageDependency({name = "bottleneckp", version = SemVer(1,1,3),maxversion = None}),
                PackageDependency({name = "cheerio", version = SemVer(1,0,0),maxversion = None}),
                PackageDependency({name = "cheerio-select", version = SemVer(0,1,1),maxversion = None}),
                PackageDependency({name = "css-select", version = SemVer(3,1,2),maxversion = None}),
                PackageDependency({name = "boolbase", version = SemVer(1,0,0),maxversion = None}),
                PackageDependency({name = "css-what", version = SemVer(5,0,0),maxversion = None}),
                PackageDependency({name = "entities", version = SemVer(2,2,0),maxversion = None}),
                PackageDependency({name = "request", version = SemVer(2,88,2),maxversion = None}),
                PackageDependency({name = "caseless", version = SemVer(0,12,0),maxversion = None}),
                PackageDependency({name = "extend", version = SemVer(3,0,2),maxversion = None}),
                PackageDependency({name = "json-stringify-safe", version = SemVer(5,0,1),maxversion = None})
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
            let expectset = Set#{PackageDependency({name = "entities", version = SemVer(2,4,0),maxversion = None})};
            set |> println;
            expectset |> println;
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
        /// match comparePackageInfo(p1,p2) {
        ///     case Ok(_) => false
        ///     case Err(_) => true
        /// }

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
  