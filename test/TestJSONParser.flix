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
/// use Pkger/Examples.examplePackage2;
/// use Pkger/Examples.examplePackage3;
/// use Pkger/Examples.examplePackage4;
/// use Pkger/Examples.examplePackage5;
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
    
    @test 
    def testCombi01(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameOne${quote}}";
        let tokens = lex(json,Nil);
        match parse(tokens){
            case Ok((jsonvalue,tokensleft)) => 
                let map = Map.empty();
                let map2 = Map.insert("name",JString("MyPackageNameOne"),map);
                JObject(map2) == jsonvalue and tokensleft == Nil
            case Err(_) => false 
        }

    @test 
    def testCombi02(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote}}";
        let tokens = lex(json,Nil);
        match parse(tokens){
            case Ok((jsonvalue,tokensleft)) => 
                let map = Map.empty();
                let map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
                JObject(map2) == jsonvalue and tokensleft == Nil
            case Err(_) => false 
        }
       
    @test 
    def testCombi03(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote},${quote}testkey${quote}:${quote}testvalue${quote}}";
        let tokens = lex(json,Nil);
         match parse(tokens){
            case Ok((jsonvalue,tokensleft)) => 
                let map = Map.empty();
                let map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
                let map3 = Map.insert("testkey",JString("testvalue"),map2);
                JObject(map3) == jsonvalue and tokensleft == Nil
            case Err(_) => false 
        }

    @test 
    def testCombi04(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}authors${quote}:[{${quote}name${quote}:${quote}Peter${quote},${quote}email${quote}:${quote}None${quote},${quote}website${quote}:${quote}None${quote}}]}";
        let tokens = lex(json,Nil);
        match parse(tokens){
            case Ok((jsonvalue,_tokensleft)) => 
                let authormap = Map#{"name"->JString("Peter"),"email"->JString("None"),"website"->JString("None")};
                let map2 = Map#{"authors" -> JArray(JObject(authormap)::Nil)}; 
                jsonvalue == JObject(map2)
            case Err(_) => false 
        }

    
    @test 
    def testCombi05(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{
            ${quote}name${quote}:${quote}MyPackageNameOne${quote},
            ${quote}version${quote}:${quote}(1,0,0)${quote},
            ${quote}authors${quote}:[{   
                ${quote}name${quote}:${quote}Peter${quote},
                ${quote}email${quote}:${quote}None${quote},
                ${quote}website${quote}:${quote}None${quote}
            }],
            ${quote}edition${quote}:${quote}(0,14,6)${quote},
            ${quote}dependencies${quote}:[{   
                ${quote}packagename${quote}:${quote}MyPackageNameTwo${quote},
                ${quote}packageversion${quote}:${quote}(2,0,0)${quote}
            }],
            ${quote}url${quote}:${quote}Nil${quote}
            }";
        let tokens = lex(json,Nil);
        match parse(tokens){
            case Ok((jsonvalue,_tokensleft)) => 
                let authorsmap = JArray(JObject(Map#{"name"->JString("Peter"),"email"->JString("None"),"website"->JString("None")})::Nil);
                let dependenciesmap = JArray(JObject(Map#{"packagename"->JString("MyPackageNameTwo"), "packageversion" -> JString("(2,0,0)")})::Nil);
                let expectvalue = JObject(Map#{"name"->JString("MyPackageNameOne"), "version" -> JString("(1,0,0)"), "authors"->authorsmap, "edition" -> JString("(0,14,6)"),
                "dependencies" -> dependenciesmap, "url" -> JString("Nil")});
                /// jsonvalue |> println;
                /// expectvalue |> println;
                jsonvalue == expectvalue
            case Err(_) => false
        }
    
    @test 
    def testJson2Author(): Bool = 
        let jobject = JObject(Map#{"name"->JString("Peter"),"email"->JString("None"),"website"->JString("None")});
        let author = json2author(jobject);
        let expect = Ok(Author({name = "Peter", email = None, website = None}));
        author == expect

    @test 
    def testJString2String(): Bool = 
        let jstring = JString("Hello");
        let hello = jstring2string(jstring);
        let expect = Ok("Hello");
        hello == expect

    //
    // test single digit version 
    //
    @test 
    def testJson2Semver01(): Bool & Impure= 
        let jstring = JString("(1,2,3)");
        let semver = jstring2Semver(jstring);
        let expect = Ok(SemVer(1,2,3));
        semver == expect
    
    //
    // test 2 digit version 
    //
    @test 
    def testJson2Semver02(): Bool & Impure= 
        let jstring = JString("(14,2,3)");
        let semver = jstring2Semver(jstring);
        let expect = Ok(SemVer(14,2,3));
        semver == expect

    @test 
    def testJson2Dependencies(): Bool & Impure = 
        let jobject = JObject(Map#{"name"->JString("MyPackageNameTwo"), "version" -> JString("(2,0,0)")});
        let dep = json2Dependency(jobject);
        let expect = Ok(PackageDependency({name = "MyPackageNameTwo", version = SemVer(2,0,0)}));
        dep == expect

    @test 
    def testJson2PackageInfo(): Bool & Impure= 
    use Result.flatMap;
        let authorsmap = JArray(JObject(Map#{"name"->JString("Peter"),"email"->JString("None"),"website"->JString("None")})::Nil);
        let dependenciesmap = JArray(JObject(Map#{"packagename"->JString("MyPackageNameTwo"), "packageversion" -> JString("(2,0,0)")})::Nil);
        let testinput = JObject(Map#{"name"->JString("MyPackageNameOne"), "version" -> JString("(1,0,0)"), "authors"->authorsmap, "edition" -> JString("(0,4,6)"),
        "dependencies" -> dependenciesmap, "url" -> JString("Nil")});
        let expect = PackageInfo({
                name = "MyPackageNameOne",
                version = SemVer(1,0,0), 
                authors = Author({name = "Peter", email = None, website = None}) :: Nil,
                edition = SemVer(0,4,6),
                dependencies = PackageDependency({name = "MyPackageNameTwo",version = SemVer(2,0,0)}) :: Nil,
                url = "Nil"});
        match json2PackageInfo(testinput){
            case Ok(x) => let PackageInfo(_x1) = x;
                /// x1.authors|> println; 
                /// expect |> println; 
                //TODO this test should be fail 
                x == expect
            case Err(_) => false
        }
    
    @test 
    def testStringify(): Bool = 
        let ex3 = examplePackage1();
        let _stringex3 = stringifyPackageInfo(ex3);
        true 

    
        

    