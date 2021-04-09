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
use Pkger/Lex.{stringifySemver,stringifyAuthors,stringifyDependency,stringifyPackageInfo,lex,parseWrapper};
namespace Pkger/Lex{
    /////////////////////////////////////////////////////////////////////////////
    // prettyprint                                                             //
    /////////////////////////////////////////////////////////////////////////////
    @test
    def testLex01(): Bool = 
        //let a = examplePackage1();
        //stringifyPackageInfo(a) |> println;
        //let b = examplePackage2();
        //stringifyPackageInfo(b) |> println;
        true
    
    /////////////////////////////////////////////////////////////////////////////
    // test {                                                                     //
    /////////////////////////////////////////////////////////////////////////////
    @test 
    def testLex02(): Bool & Impure = 
    use Result.flatMap;
        let testCurly = "{";
        let tokens = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: Nil;
        tokens == expectedtokens


    /////////////////////////////////////////////////////////////////////////////
    // test {"name":"MyPackageNameTwo"} returns right tokes                     //
    /////////////////////////////////////////////////////////////////////////////
    @test 
    def testLex03(): Bool & Impure = 
    use Result.flatMap;
        let quote = Char.toString('"');
        let testCurly = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote}}";
        let tokens  = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: "name" :: ":" :: "MyPackageNameTwo"::"}":: Nil; 
        tokens == expectedtokens

    /////////////////////////////////////////////////////////////////////////////
    // test lex List[Author]                T                                    //
    ///////////////////////////////////////////////////////////////////////////// 
    @test 
    def testLex04(): Bool & Impure = 
    use Result.flatMap;
        let quote = Char.toString('"');
        let testCurly = "{${quote}authors${quote}:[{${quote}name${quote}:${quote}Peter${quote},
        ${quote}email${quote}:${quote}None${quote},
        ${quote}website${quote}:${quote}None${quote}}]}";
        let tokens = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: "authors" :: ":" :: "[" :: "{" :: "name" :: ":" :: "Peter" :: "," ::"email" :: ":" :: "None" :: "," :: "website" :: ":" :: "None" :: "}" :: "]" :: "}" :: Nil;
        tokens == expectedtokens

    /////////////////////////////////////////////////////////////////////////////
    // test lex "{}"                                                           //
    /////////////////////////////////////////////////////////////////////////////
    @test 
    def testLex05(): Bool & Impure = 
    use Result.flatMap;
        let testCurly = "{}";
        let tokens = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: "}":: Nil;
        tokens == expectedtokens 

}

   
    