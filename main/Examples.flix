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
use Pkger/PackageInfo.pinfogetname;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;

namespace Pkger{
    namespace Examples {
        pub def examplePackage1(): PackageInfo = 
            PackageInfo({
                name = "MyPackageNameOne",
                version = SemVer(1,0,0), 
                authors = Author({name = "Peter", email = None, website = None}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "MyPackageNameTwo",version = SemVer(2,0,0), maxversion = Some(SemVer(3,0,0))}) :: Nil,
                url = "Nil"})

        pub def crawler(): PackageInfo = 
            PackageInfo({
                name = "crawler",
                version = SemVer(1,3,0),
                authors = Author({name = "sylvinus",email = None, website = None}) :: Author({name = "paulvalla", email = None, website = Some("https://github.com/paulvalla")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "bottleneckp", version = SemVer(1,1,3),maxversion = None})::
                               PackageDependency({name = "cheerio", version = SemVer(1,0,0),maxversion = None}) ::
                               PackageDependency({name = "request", version = SemVer(2,88,2),maxversion = None}) :: Nil,
                url = "https://github.com/bda-research/node-crawler"
            })
        
        
        pub def bottleneckp(): PackageInfo = 
            PackageInfo({
                name = "bottleneckp",
                version = SemVer(1,1,3),
                authors = Author({name = "darrenqc", email = None, website = Some("https://github.com/darrenqc")})::
                          Author({name = "mike442144", email = None, website = None}):: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil, 
                url = "https://github.com/darrenqc/BottleneckP"
            })
        
        pub def bottleneckp2(): PackageInfo = 
            PackageInfo({
                name = "bottleneckp",
                version = SemVer(1,5,3),
                authors = Author({name = "darrenqc", email = None, website = Some("https://github.com/darrenqc")})::
                          Author({name = "mike442144", email = None, website = None}):: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil, 
                url = "https://github.com/darrenqc/BottleneckP"
            })
        
        pub def bottleneckp3(): PackageInfo = 
            PackageInfo({
                name = "bottleneckp",
                version = SemVer(1,5,2),
                authors = Author({name = "darrenqc", email = None, website = Some("https://github.com/darrenqc")})::
                          Author({name = "mike442144", email = None, website = None}):: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil, 
                url = "https://github.com/darrenqc/BottleneckP"
            })
        pub def bottleneckp4(): PackageInfo = 
            PackageInfo({
                name = "bottleneckp",
                version = SemVer(2,5,2),
                authors = Author({name = "darrenqc", email = None, website = Some("https://github.com/darrenqc")})::
                          Author({name = "mike442144", email = None, website = None}):: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil, 
                url = "https://github.com/darrenqc/BottleneckP"
            })
        
        pub def cheerio(): PackageInfo = 
            PackageInfo({
                name = "cheerio", 
                version = SemVer(1,0,0),
                authors = Author({name = "mattmueller", email = None, website = None}) ::
                          Author({name = "davidchambers", email = None, website = Some("https://github.com/davidchambers")})::Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "cheerio-select", version = SemVer(0,1,1),maxversion = None})::
                               PackageDependency({name = "entities", version = SemVer(2,2,0),maxversion = None})::Nil,
                url = "https://github.com/cheeriojs/cheerio"
            })

        pub def cheerio_select(): PackageInfo = 
            PackageInfo({
                name ="cheerio-select", 
                version = SemVer(0,1,1),
                authors = Author({name = "feedic", email = None, website = Some("https://github.com/fb55")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "css-select", version = SemVer(3,1,2),maxversion = None}) :: 
                               PackageDependency({name = "css-what", version = SemVer(5,0,0),maxversion = None}) :: Nil,
                url = "https://github.com/cheeriojs/cheerio-select"

            })

        pub def css_select(): PackageInfo = 
            PackageInfo({
                name ="css-select", 
                version = SemVer(3,1,2),
                authors = Author({name = "feedic", email = None, website = Some("https://github.com/fb55")})::
                          Author({name = "chriseppstein", email = None, website = Some("https://github.com/chriseppstein")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "boolbase", version = SemVer(1,0,0),maxversion = None}) :: 
                               PackageDependency({name = "css-what", version = SemVer(5,0,0),maxversion = None}) :: Nil,
                url = "https://github.com/fb55/css-select"

            })

        pub def css_what(): PackageInfo = 
            PackageInfo({
                name ="css-what", 
                version = SemVer(5,0,0),
                authors = Author({name = "feedic", email = None, website = Some("https://github.com/fb55")})::
                          Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "entities", version = SemVer(2,2,1),maxversion = None}) :: Nil,
                url = "https://github.com/fb55/css-what"

            })

        pub def entities(): PackageInfo = 
            PackageInfo({
                name = "entities", 
                version = SemVer(2,4,1),
                authors = Author({name = "feedic", email = None, website = Some("https://github.com/fb55")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil,
                url = "https://github.com/fb55/entities"
            })
        
         pub def entities2(): PackageInfo = 
            PackageInfo({
                name = "entities", 
                version = SemVer(2,2,2),
                authors = Author({name = "feedic", email = None, website = Some("https://github.com/fb55")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil,
                url = "https://github.com/fb55/entities"
            })

        pub def boolbase(): PackageInfo = 
            PackageInfo({
                name = "boolbase", 
                version = SemVer(1,0,0),
                authors = Author({name = "feedic", email = None, website = Some("https://github.com/fb55")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil,
                url = "Nil??"
            })
        
         pub def request(): PackageInfo = 
            PackageInfo({
                name = "request",
                version = SemVer(2,88,2),
                authors = Author({name = "fredkschott",email = None, website = None}) :: 
                          Author({name = "Mikeal Rogers", email = None, website = Some("https://github.com/mikeal")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = PackageDependency({name = "caseless", version = SemVer(0,12,0),maxversion = None})::
                               PackageDependency({name = "extend", version = SemVer(3,0,2),maxversion = None}) ::
                               PackageDependency({name = "json-stringify-safe", version = SemVer(5,0,1),maxversion = None}) :: Nil,
                url = "https://github.com/request/request"
            })
        
        pub def caseless(): PackageInfo = 
            PackageInfo({
                name = "caseless",
                version = SemVer(0,12,0),
                authors = Author({name = "Mikeal Rogers", email = None, website = Some("https://github.com/mikeal")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil,
                url = "https://github.com/mikeal/caseless"
            })
        
        pub def extend(): PackageInfo = 
            PackageInfo({
                name = "extend",
                version = SemVer(3,0,2),
                authors = Author({name = "justmoon", email = None, website = Some("https://github.com/justmoon")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil,
                url = "https://github.com/justmoon/node-extend"
            })
        
        pub def json_stringify_safe(): PackageInfo = 
            PackageInfo({
                name = "json-stringify-safe",
                version = SemVer(5,0,1),
                authors = Author({name = "isaacs", email = None, website = Some("https://github.com/isaacs")}) :: Nil,
                edition = SemVer(0,14,6),
                dependencies = Nil,
                url = "https://github.com/isaacs/json-stringify-safe"
            })

        pub def fakeregister(): Result[Map[String,List[PackageInfo]],String] = 
            let crawler = crawler();
            let bottleneckp = bottleneckp();
            let cheerio = cheerio();
            let cheerio_select = cheerio_select();
            let css_select = css_select();
            let css_what = css_what();
            let entities = entities();
            let entities2 = entities2();
            let boolbase = boolbase();
            let request = request();
            let caseless = caseless();
            let extend = extend();
            let json_stringify_safe = json_stringify_safe();
            Ok(Map#{pinfogetname(crawler) -> crawler :: Nil,
                    pinfogetname(css_what) -> css_what :: Nil,
                    pinfogetname(bottleneckp) -> bottleneckp :: Nil,
                    pinfogetname(cheerio) -> cheerio :: Nil,
                    pinfogetname(cheerio_select) -> cheerio_select :: Nil,
                    pinfogetname(entities) -> entities2 :: entities :: Nil,
                    pinfogetname(css_select) -> css_select :: Nil,
                    pinfogetname(boolbase) -> boolbase :: Nil,
                    pinfogetname(request) -> request :: Nil,
                    pinfogetname(caseless) -> caseless :: Nil,
                    pinfogetname(extend) -> extend :: Nil,
                    pinfogetname(json_stringify_safe) -> json_stringify_safe :: Nil})


    }
}



