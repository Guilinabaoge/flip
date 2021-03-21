use Pkger/PackageInfo.PackageInfo;
use Pkger/PackageInfo.PackageInfo.PackageInfo;
use Pkger/Examples.examplePackage1;
use Pkger/Examples.examplePackage2;
use Pkger/Examples.examplePackage3;
use Pkger/Examples.examplePackage4;
use Pkger/Examples.examplePackage5;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.PackageDependency;
use Pkger/JSON.{stringifySemver,stringifyAuthors,stringifyDependency,stringifyPackageInfo,lex};
use Pkger/JSONnew2.{parse};
use Pkger/JSONnew2.JSON.JObject;
use Pkger/JSONnew2.JSON.JString;
    
    @test 
    def testCombi01(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameOne${quote}}";
        let tokens = lex(json,Nil);
        parse(tokens,Map.empty());
        /// let map = Map.empty();
        /// let _map2 = Map.insert("name",JString("MyPackageNameOne"),map);
        true
        //let expectjo = Ok(JObject(map2));
        //map2 |> println;
        //jobject == expectjo
        
       

    @test 
    def testCombi02(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote}}";
        let tokens = lex(json,Nil);
        parse(tokens,Map.empty());
        /// let map = Map.empty();
        /// let _map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
        //let expectjo = Ok(JObject(map2));
        true
        //map2 |> println;
        //jobject == expectjo

    @test 
    def testCombi03(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote},${quote}live${quote}:${quote}BadLife${quote}}";
        let tokens = lex(json,Nil);
        parse(tokens,Map.empty());
        /// let map = Map.empty();
        /// let _map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
        //let expectjo = Ok(JObject(map2));
        true
        //map2 |> println;
        //jobject == expectjo

    @test 
    def testCombi04(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}authors${quote}:[{${quote}name${quote}:${quote}Peter${quote},${quote}email${quote}:${quote}None${quote},${quote}website${quote}:${quote}None${quote}}]}";
        let tokens = lex(json,Nil);
        //tokens |> println;
        parse(tokens,Map.empty());
        /// let map = Map.empty();
        /// let _map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
        //let expectjo = Ok(JObject(map2));
        true
        //map2 |> println;
        //jobject == expectjo

    
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
                ${quote}packagversion${quote}:${quote}(2,0,0)${quote}
            }],
            ${quote}url${quote}:${quote}Nil${quote}
            }";
        let tokens = lex(json,Nil);
        //tokens |> println;
        parse(tokens,Map.empty());
        /// let map = Map.empty();
        /// let _map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
        //let expectjo = Ok(JObject(map2));
        true
        //map2 |> println;
        //jobject == expectjo