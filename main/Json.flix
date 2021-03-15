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
use Pkger/Examples.examplePackage2;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.PackageDependency;


namespace Pkger{
    namespace JSON{

        //
        // Give parse an initial PackageInfo 
        //
        pub def parseWrapper(tokens: List[String]): PackageInfo & Impure =
            let initPinfo = PackageInfo({name = "",
                                        version = SemVer(0,0,0),
                                        authors = Author({name = "", email = None, website = None}) :: Nil,
                                        edition = SemVer(0,0,0),
                                        dependencies = PackageDependency({name = "",version = SemVer(0,0,0)}) :: Nil,
                                        url = "Nil"});
            parse(tokens,initPinfo)

        //
        // Parse JSON format string into a PackageInfo
        //
        pub def parse(tokens: List[String],json_object: PackageInfo): PackageInfo & Impure= 
            match tokens {
                case Nil => ???//"empty token should return error" 
                case n :: rest => 
                    match n {
                        case "{" => parse_object(rest,json_object) 
                        case _  => parse_object(tokens,json_object)
                     }
            }

        //TODO function must specifi the List type, is making two functions to parse List[Author] List[Dependency] the right thing to do?
        def parse_array_authors(tokens: List[String],authorlist:List[Author]): (List[Author],List[String]) & Impure= 
            let alist = Author({name = "Peter", email = None, website = None})::Nil;
            use Option.flatMap;
            match tokens {
                case Nil => ??? //illegal JSON
                case n :: rest => 
                    match n {
                        //TODO solve code duplication 
                        case "," => parse_array_authors(rest,alist)
                        case "}" => parse_array_authors(rest,alist)
                        case "{" => parse_array_authors(rest,alist)
                        case "name" => match rest {
                                            case Nil => ??? // illegal JSON
                                            case n2 :: rest2 => if (n2 == ":"){
                                                                    match rest2{
                                                                        case Nil => ??? // illegal JSON
                                                                        case n3 :: rest3 => match List.head(alist){
                                                                            case None => ???// illegal JSON 
                                                                            case Some(y) => let Author(x) = y;
                                                                                            let newauthor = Author({name = "${n3}" | x});
                                                                                            let newalist = newauthor :: Nil;
                                                                                            parse_array_authors(rest3,newalist)
                                                                        }
                                                                    }
                                                                } else {
                                                                    ???
                                                                }}
                        case "email" => match rest {
                                            case Nil => ??? // illegal JSON
                                            case n2 :: rest2 => if (n2 == ":"){
                                                                    match rest2{
                                                                        case Nil => ??? // illegal JSON 
                                                                        case n3 :: rest3 => match List.head(alist){ //TODO let* for Option? 
                                                                            case None => ???// illegal JSON 
                                                                            case Some(y) => let Author(x) = y;
                                                                                            let newauthor = Author({email = None | x});
                                                                                            let newalist = newauthor :: Nil;
                                                                                            parse_array_authors(rest3,newalist)
                                                                        }
                                                                    }
                                                                } else {
                                                                    ???
                                                                }}
                        case "website" => match rest {
                                            case Nil => ??? // illegal JSON
                                            case n2 :: rest2 => if (n2 == ":"){
                                                                    match rest2{
                                                                        case Nil => ??? // illegal JSON
                                                                        case n3 :: rest3 => match List.head(alist){
                                                                            case None => ???// illegal JSON 
                                                                            case Some(y) => let Author(x) = y;
                                                                                            let newauthor = Author({website = None | x});
                                                                                            let newalist = newauthor :: Nil;
                                                                                            parse_array_authors(rest3,newalist)
                                                                        }
                                                                    }
                                                                } else {
                                                                    ???
                                                                }}
                        case "]" =>  (alist,rest)
                        case _ => (alist,tokens)
                    }
                
            }

        def parse_semver(_token: String): SemVer = SemVer(1,2,3)   
            
        def parse_object(tokens: List[String],json_object: PackageInfo): PackageInfo & Impure= 
            match tokens {
                case Nil => ???
                case n :: rest =>
                    match n {
                        case "}" => json_object
                        case "," => parse_object(rest,json_object)
                        case "version" => match rest {
                                            case Nil => ??? // illegal JSON
                                            case n :: rest => 
                                                if (n == ":"){
                                                    match rest {
                                                        case Nil => ??? //illegal JSON
                                                        case n2 :: rest2  =>
                                                            let getsemver = parse_semver(n2);
                                                            let PackageInfo(x) = json_object; 
                                                            let newpinfo = PackageInfo({version = getsemver | x});
                                                            parse_object(rest2,newpinfo)         
                                                    }
                                                }
                                                else {
                                                    ??? // illegal JSON
                                                }
                                            } 

                        case "name" =>  match rest {
                                            case Nil => ??? // illegal JSON
                                            case n :: rest => 
                                                if (n == ":"){
                                                    match rest {
                                                        case Nil => ??? //illegal JSON
                                                        case n2 :: rest2  =>
                                                            let PackageInfo(x) = json_object; 
                                                            let newpinfo = PackageInfo({name = "${n2}" | x});
                                                            parse_object(rest2,newpinfo)
                                                    }
                                                }
                                                else {
                                                    ??? // illegal JSON
                                                }
                                        }     
                        case "authors" =>   match rest {
                                            case Nil => ??? // illegal JSON
                                            case n :: rest => 
                                                if (n == ":"){
                                                    match rest {
                                                        case Nil => ??? //illegal JSON
                                                        case n2 :: rest2  =>
                                                            if (n2 == "[") {
                                                                let (getlist,remaintokens) = parse_array_authors(rest2,Nil);
                                                                let PackageInfo(x) = json_object; 
                                                                let newpinfo = PackageInfo({authors = getlist | x});
                                                                parse_object(remaintokens,newpinfo)
                                                            }
                                                            else {
                                                                ??? /// illegal JSON authors must follow with an list 
                                                            }
                                                                
                                                    }
                                                }
                                                else {
                                                    ??? // illegal JSON
                                                }
                                            }  
                        case _ => ???
                    }
            }
            
            
        //TODO make it support monadic style 
        pub def lex(s: String, tokens: List[String]): List[String] & Impure= 
            let stringList = String.toList(s);
            match stringList {
                case Nil => List.reverse(tokens)//Ok(List.reverse(tokens)) 
                case n :: rest =>
                    match n {
                        // TODO figure out how to refactor JSON_SYNTAX, too much code duplications case '\n' or ' ' => ignore?
                        case '\n' =>let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    lex(newstring,tokens)
                        case '"' => let (string, list) = lex_string(rest,"");
                                    let tokens = string :: tokens;
                                    let newstring = String.flatten(list);
                                    lex(newstring,tokens)
                        case ' ' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    lex(newstring,tokens)
                        case '{' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = "{" :: tokens;
                                    lex(newstring,tokens)
                        case ':' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = ":" :: tokens;
                                    lex(newstring,tokens)
                        case '}' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = "}" :: tokens;
                                    lex(newstring,tokens)
                        case '[' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = "[" :: tokens;
                                    lex(newstring,tokens)
                        case ']' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = "]" :: tokens;
                                    lex(newstring,tokens)
                        case ',' => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = "," :: tokens;
                                    lex(newstring,tokens)
                        case _ => ???//"illegal JSON" |> println; Nil
                    }
            }
        
        pub def lex_string(list: List[Char], key: String): (String, List[String]) & Impure= 
            match list{
                case Nil => let stringlist = List.map(Char.toString,list); 
                            (key,stringlist)
                case n :: rest => 
                        match n {
                            case '"' => let stringlist = List.map(Char.toString,rest);
                                        let reverse = String.reverse(key);  
                                            (reverse,stringlist) 
                            case _ => //let stringlist = List.map(Char.toString,rest);  
                                            let stringnew = Char.toString(n) + key;  
                                            lex_string(rest,stringnew)
                        }
            }
          
        pub def stringifyPackageInfo(p: PackageInfo): String = 
            let PackageInfo(package1) = p;
            let name = package1.name;
            let version = stringifySemver(package1.version);
            let authors = stringifyAuthors(package1.authors);
            let edition = stringifySemver(package1.edition);
            let dependencies = stringifyDependency(package1.dependencies);
            let url = package1.url;
            
            let packageInfoString = Char.toString('"')+"name"+Char.toString('"') + ":" + Char.toString('"')+name+Char.toString('"') + "," + String.lineSeparator()+
                                    Char.toString('"')+"version"+Char.toString('"') + ":" + Char.toString('"')+version+Char.toString('"') + "," +String.lineSeparator()+
                                    Char.toString('"')+"authors"+Char.toString('"') + ":" + "["+authors+"]" + "," +String.lineSeparator()+
                                    Char.toString('"')+"edition"+Char.toString('"') + ":" + Char.toString('"')+edition+Char.toString('"') + "," +String.lineSeparator()+
                                    Char.toString('"')+"dependencies"+Char.toString('"') + ":" + "["+dependencies+"]" + "," +String.lineSeparator()+
                                    Char.toString('"')+"url"+Char.toString('"') + ":" + Char.toString('"')+url+Char.toString('"');
            let indentString = String.indent(3,packageInfoString);
            let finalPretty = "{" + String.lineSeparator() + indentString + String.lineSeparator()+ "}" ;
            finalPretty
        
        //
        // Turn semver into a string 
        //    
        pub def stringifySemver(sv: SemVer): String  = 
            let SemVer(a,b,c) = sv;
            "(" + Int32.toString(a)+"," + Int32.toString(b) + ","+ Int32.toString(c)+")"

        //
        //Turn authors into a string 
        //
        pub def stringifyAuthors(authors: List[Author]): String = 
            let authorStringList = List.formatWith(makeAuthorString, "," , authors);
            authorStringList 

        def makeAuthorString(a: Author): String = 
            let Author(authorRecord) = a;
            let email = match authorRecord.email {
                case None => "None"
                case Some(y) => y
            };
            let website = match authorRecord.website {
                case None => "None"
                case Some(y) => y
            };
            let author = 
                String.lineSeparator()+Char.toString('"')+"name"+Char.toString('"') + ":" + Char.toString('"')+authorRecord.name+Char.toString('"')+"," + 
                String.lineSeparator()+Char.toString('"')+"email"+Char.toString('"') + ":" + Char.toString('"')+email+Char.toString('"')+"," +
                String.lineSeparator()+Char.toString('"')+"website"+Char.toString('"') + ":" + Char.toString('"')+website+Char.toString('"');
            let authorIndent = "{"+String.indent(3,author)+"}";
            authorIndent
        
        //
        // Turn dependencies into a string 
        //
        pub def stringifyDependency(dependencies: List[PackageDependency]): String = 
            let authorStringList = List.formatWith(makeDependencyString,",",dependencies);
            authorStringList
        
        def makeDependencyString(a: PackageDependency): String = 
            let PackageDependency(packageRecord) = a;
            let name = packageRecord.name;
            let version = stringifySemver(packageRecord.version);
            let dependency = 
                String.lineSeparator()+Char.toString('"')+"packagename"+Char.toString('"') + ":" + Char.toString('"')+name+Char.toString('"')+"," + 
                String.lineSeparator()+Char.toString('"')+"packagversion"+Char.toString('"') + ":" + Char.toString('"')+version+Char.toString('"');
            let dependencyIndent = "{"+String.indent(3,dependency)+"}";
            dependencyIndent

    }    
}
