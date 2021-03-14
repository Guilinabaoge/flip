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
        // Parse JSON format string into a PackageInfo
        //
        pub def parse(tokens: List[String]): {name: String} & Impure= 
            match tokens {
                case Nil => ???//"empty token should return error" |> println; {name = "MyPackageNameOne"} 
                case n :: rest => 
                    match n {
                        case "{" => parse_object(rest) 
                        case _  => parse_object(tokens)
                     }
            }

        
        def parse_object(tokens: List[String]): {name: String} & Impure= 
            let json_object = {name= "Nil"};
            match tokens {
                case Nil => ???
                case n :: rest =>
                    match n {
                        case "}" => json_object
                        case "name" =>  match rest {
                                            case Nil => ??? // illegal JSON
                                            case n :: rest => 
                                                if (n == ":"){
                                                    parse(rest)
                                                }
                                                else {
                                                    ??? // illegal JSON
                                                }
                                        }        
                        case _ => { name = "${n}"}
                    }
            }
            
            
            

        

        //TODO make it support monadic style 
        pub def lex(s: String, tokens: List[String]): List[String] & Impure= 
            let stringList = String.toList(s);
            match stringList {
                case Nil => List.reverse(tokens)//Ok(List.reverse(tokens)) 
                case n :: rest =>
                    match n {
                        // TODO figure out how to refactor JSON_SYNTAX
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
                        case _ => List.reverse(tokens)//"illegal JSON" |> println; Nil
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
