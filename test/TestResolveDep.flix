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
use Pkger/PackageInfo.PackageInfo;
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
use Pkger/JSON.JSON.JObject;
use Pkger/JSON.JSON.JString;
use Pkger/JSON.JSON.JArray;
use Pkger/Examples.{fakeregister};
use Pkger/ResolveDep.{getFullDependencies};

namespace Pkger/ResolveDep{
    @test 
    def testResolveDep01(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => getFullDependencies(x,Nil,"entities") == Nil
            case Err(_) => false
        }
    
    @test 
    def testResolveDep02(): Bool & Impure=
    use Result.flatMap;
        match fakeregister(){
            case Ok(x) => 
            let set = List.toSet(getFullDependencies(x,Nil,"css-select"));
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
            let set = List.toSet(getFullDependencies(x,Nil,"crawler"));
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
}
  