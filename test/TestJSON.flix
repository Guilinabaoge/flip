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
use Pkger/JSON.{stringifySemver,stringifyAuthors,stringifyDependency,stringifyPackageInfo,lex,parse};


//TODO figure out how to impl record instance 
/// instance ToString[{name: String}]{
///     def toString(x: {name: String}): String = x.name
/// }

/// instance Eq[{name: String}] {
///     def eq(x: {name: String}, y: {name: String}): Bool = x.name == y.name
/// }



    def _checkRecordEqual1(packageInfo: {name: String},expectedpinfo: {name: String}): Bool = 
        packageInfo.name == expectedpinfo.name

    /// def printRecord1(packageInfo: {name: String}): Unit & Impure = 
    ///     packageInfo.name |> println

    /// def checkRecordEqual2(packageInfo: Author,expectedpinfo: Author: Bool = 
    ///     packageInfo.authors == expectedpinfo.authors

    /// def printRecord2(packageInfo: {authors: List[Author]}): Unit & Impure = 
    ///     packageInfo.authors |> println
        


    /////////////////////////////////////////////////////////////////////////////
    // prettyprint                                                             //
    /////////////////////////////////////////////////////////////////////////////
    /// @test
    /// def testJSON01(): Bool & Impure = 
    ///     let a = examplePackage1();
    ///     stringifyPackageInfo(a) |> println;
    ///     let b = examplePackage2();
    ///     stringifyPackageInfo(b) |> println;
    ///     true
    
    /////////////////////////////////////////////////////////////////////////////
    // test                                                                     //
    /////////////////////////////////////////////////////////////////////////////
    @test 
    def testLex02(): Bool & Impure = 
    use Result.flatMap;
        let testCurly = "{";
        let tokens = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: Nil;
        tokens == expectedtokens

    @test 
    def testLex03(): Bool & Impure = 
    use Result.flatMap;
        let quote = Char.toString('"');
        let testCurly = "{${quote}name${quote}:${quote}MyPackageNameTwo${quote}}";
        let tokens  = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: "name" :: ":" :: "MyPackageNameTwo"::"}":: Nil; 
        tokens == expectedtokens
        
    @test 
    def testLex04(): Bool & Impure = 
    use Result.flatMap;
        let quote = Char.toString('"');
        // TODO figure out how to do \n
        let testCurly = "{${quote}authors${quote}:[{${quote}name${quote}:${quote}Peter${quote},${quote}email${quote}:${quote}None${quote},${quote}website${quote}:${quote}None${quote}}]}";
        let tokens = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: "authors" :: ":" :: "[" :: "{" :: "name" :: ":" :: "Peter" :: "," ::"email" :: ":" :: "None" :: "," :: "website" :: ":" :: "None" :: "}" :: "]" :: "}" :: Nil;
        tokens == expectedtokens

    @test 
    def testLex05(): Bool & Impure = 
    use Result.flatMap;
        let testCurly = "{}";
        let tokens = lex(testCurly, Nil);
        let expectedtokens : List[String] = "{" :: "}":: Nil;
        tokens == expectedtokens 

    @test 
    def testParse(): Bool & Impure = 
        let quote = Char.toString('"');
        let json = "{${quote}name${quote}:${quote}MyPackageNameOne${quote}}";
        let tokens = lex(json,Nil);
        let packageInfo = parse(tokens);
        let expectedpinfo = PackageInfo({
                name = "MyPackageNameOne",
                version = SemVer(0,0,0), 
                authors = Author({name = "Hi", email = None, website = None}) :: Nil,
                edition = SemVer(0,0,0),
                dependencies = PackageDependency({name = "Hi",version = SemVer(0,0,0)}) :: Nil,
                url = "Nil"});
        packageInfo == expectedpinfo
        //checkRecordEqual1(packageInfo,expectedpinfo)
    
    /// @test 
    /// def testParse2(): Bool & Impure = 
    ///     let quote = Char.toString('"');
    ///     let json = "{${quote}authors${quote}:[{${quote}name${quote}:${quote}Peter${quote},${quote}email${quote}:${quote}None${quote},${quote}website${quote}:${quote}None${quote}}]}";
    ///     let tokens = lex(json,Nil);
    ///     let packageInfo = parse(tokens);
    ///     let expectedpinfo = {authors = [{name = "Peter", email = None, website = None}:: Nil]};
    ///     /// printRecord2(packageInfo);
    ///     /// printRecord2(expectedpinfo);
    ///     /// checkRecordEqual2(packageInfo,expectedpinfo)
    ///     ///packageInfo == expectedpinfo

    


/// let testCurly = "{
///             ${quote}name${quote}:${quote}MyPackageNameOne${quote},
///             ${quote}version${quote}:${quote}(1,0,0)${quote},
///             ${quote}authors${quote}:[{   
///                 ${quote}name${quote}:${quote}Peter${quote},
///                 ${quote}email${quote}:${quote}None${quote},
///                 ${quote}website${quote}:${quote}None${quote}
///             }],
///             ${quote}edition${quote}:${quote}(0,14,6)${quote},
///             ${quote}dependencies${quote}:[{   
///                 ${quote}packagename${quote}:${quote}MyPackageNameTwo${quote},
///                 ${quote}packagversion${quote}:${quote}(2,0,0)${quote}
///             }],
///             ${quote}url${quote}:${quote}Nil${quote}
///             }";

   
    