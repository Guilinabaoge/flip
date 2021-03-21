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
        let jobject = parse(tokens,Map.empty());
        let map = Map.empty();
        let map2 = Map.insert("name",JString("MyPackageNameOne"),map);
        let expectjo = Ok(JObject(map2));
        //map2 |> println;
        jobject == expectjo
        
       

    @test 
    def testCombi02(): Bool & Impure = 
        use Result.flatMap;
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote}}";
        let tokens = lex(json,Nil);
        let jobject = parse(tokens,Map.empty());
        let map = Map.empty();
        let map2 = Map.insert("name",JString("MyPackageNameTwo"),map);
        let expectjo = Ok(JObject(map2));
        //map2 |> println;
        jobject == expectjo
