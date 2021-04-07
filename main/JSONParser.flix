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
use Pkger/Author.Author;
use Pkger/Author.Author.Author;
use Pkger/JSON.JSON;
use Pkger/JSON.JSON.{JString,JArray,JObject};
use Pkger/SemVer.SemVer;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.PackageDependency;
use Pkger/PackageInfo.PackageInfo;
use Pkger/PackageInfo.PackageInfo.PackageInfo;

namespace Pkger{
    namespace JSONParser{
        pub def parse(tokens: List[String]): Result[(JSON,List[String]),String] & Impure= 
            match tokens {
                case Nil => Err("Missing close }")
                case n :: rest => match n {
                    case "{" => pJObject(rest,Map.empty())
                    case "[" => pJArray(rest,Nil)
                    case _ => pString(tokens)
                }
            }
        pub def pString(tokens: List[String]): Result[(JSON,List[String]),String] =
            match tokens {
                case Nil => Err("Missing close }")
                case n :: rest => Ok((JString(n),rest))
            }

        
        pub def pJArray(tokens: List[String], list: List[JSON]): Result[(JSON,List[String]),String] & Impure= 
        use Result.flatMap;
            match tokens {
                case Nil => Err("missing ]")
                case n::rest => match n{
                    case "]" => Ok(JArray(list),rest)
                    case _ => 
                    let* (parsedvalue,resttokens) = parse(tokens);
                    let newlist = parsedvalue :: list;
                    pJArray(resttokens,newlist)
                } 
            }
    
        pub def pJObject(tokens: List[String],result: Map[String,JSON]): Result[(JSON,List[String]),String] & Impure = 
        use Result.flatMap;
            match tokens {
                case Nil => Err("missing }")
                case n :: rest => match n {
                    case "}" => Ok((JObject(result),rest))
                    case "," => pJObject(rest,result)
                    case _ => 
                    let key_value_pair = List.slice(0,3,tokens);
                    let colon = List.indexOf(":",key_value_pair);
                    if (colon != 1){
                        "COLON" |> println;
                        Err("Illegal key-value pair")
                    }
                    else {
                        let restofrest = List.slice(1,List.length(rest),rest);
                        let* (parsedv,rest2) = parse(restofrest);
                        let result2 = Map.insert("${n}",parsedv,result);
                        pJObject(rest2,result2)
                    }
                }
            }
        pub def json2PackageInfo(j: JSON): Result[PackageInfo,String] & Impure = 
        use Result.flatMap;
            match j {
                case JObject(o) => 
                    let jname = Map.get("name",o);
                    let jversion = Map.get("version",o);
                    let jauthor = Map.get("authors",o);
                    let jedition = Map.get("edition",o);
                    let jdependencies = Map.get("dependencies",o);
                    let jurl = Map.get("url",o);
                    match (jname,jversion,jauthor,jedition,jdependencies,jurl){
                        case (Some(JString(pname)),Some(JString(pversion)),Some(JArray(pauthor)),Some(JString(pedition)),Some(JArray(pdependencies)),Some(JString(purl))) =>
                        let* pversion2 = jstring2Semver(JString(pversion));
                        let* pedition2 = jstring2Semver(JString(pedition));
                        Ok(PackageInfo({name = pname, version = pversion2, authors = Author({name = "hohoho", email = None, website = None})::Nil, edition = pedition2,
                        dependencies = PackageDependency({name = "ho", version = SemVer(1,2,3)})::Nil, url = purl }))
                        case (_) => Err("Hi")
                    }
            case _ => ???

            }
        
        pub def json2Dependency(j: JSON): Result[PackageDependency,String] & Impure = 
        use Result.flatMap;
        match j {
            case JObject(o) => 
                let depName = Map.get("name",o);
                let depVersion = Map.get("version",o);
                match (depName,depVersion) {
                    case (Some(JString(realdepname)),Some(JString(realdepversion))) => 
                        let* sem = jstring2Semver(JString(realdepversion));
                        Ok(PackageDependency({name = realdepname, version = sem}))
                    case (Some(_),Some(_)) => "Hi" |> println; Err("Hi")
                    case (_,_) => Err("???")
                }
            case JArray(_) => Err("unexpect Array") 
            case JString(_) => Err("unexpect String")
        }

        pub def json2author(j: JSON): Result[Author,String] = match j{
            case JObject(o) => 
                let authorName = Map.get("name",o);
                let authorEmail = Map.get("email",o);
                let authorWebsite = Map.get("website",o);
                match (authorName,authorEmail,authorWebsite) {
                    case (Some(JString(actualAuhorName)),Some(JString(actualAuhorEmail)),Some(JString(actualAuhorWebsite))) => 
                    let resolveEmail = match actualAuhorEmail{
                        case "None" => None 
                        case _ => Some(actualAuhorEmail)
                    };
                    let resolveWebsite = match actualAuhorWebsite{
                        case "None" => None 
                        case _ => Some(actualAuhorEmail)
                    };
                    Ok(Author({name = actualAuhorName,email = resolveEmail,website = resolveWebsite})) 
                    case (None,Some(_),Some(_)) => Err("Missing authorname")
                    case _ => Err("email or website type unexpect")
                }
            case JString(_) => Err("Unexpected string")
            case JArray(_) => Err("Unexpected array")
        }

        pub def jstring2string(j: JSON): Result[String,String] = match j {
            case JString(s) => Ok(s)
            case JObject(_) => Err("Unexpected JObject")
            case JArray(_) => Err("Unexpected JArray")
        }

        pub def jstring2Semver(j: JSON): Result[SemVer,String] & Impure= 
        use Result.flatMap; 
        match j {
           case JString(s) => let* (major,minor,patch) = getVersion(String.toList(s),Nil);
                             Ok(SemVer(major,minor,patch))
            case JObject(_) => Err("Unexpected JObject")
            case JArray(_) => Err("Unexpected JArray")
        }

        def getVersion(s: List[Char],tokens: List[String]): Result[(Int32,Int32,Int32),String] & Impure= 
            //s |> println;
            match s {
                case Nil => let reverse = List.reverse(tokens); parseTokens(reverse)
                case n::rest => match n {
                    case '(' => getVersion(rest,tokens)
                    //case ',' => getVersion(rest,tokens)
                    case _ => let (num,rest2) = parse2digits(s,""); 
                              let newtoken = num :: tokens;
                              getVersion(rest2,newtoken)
                }
            }
        def parse2digits(s: List[Char],num: String): (String,List[Char]) & Impure= 
            match s {
                case Nil => ???
                case n::rest => 
                match n {
                    case ',' => let newnum = String.reverse(num); (newnum,rest)
                    case ')' => let newnum = String.reverse(num); (newnum,rest)
                    case _ => 
                    let newnum = Char.toString(n) + num; 
                    //newnum |> println;
                    parse2digits(rest,newnum)
                }
            }
        
        //
        //give string "(x,y,z)" return tuple (x,y,z)
        //
        def parseTokens(tokens: List[String]): Result[(Int32,Int32,Int32),String] & Impure= 
            let intstring = List.map(Int32.fromString,tokens);
            let major1 = List.head(intstring);
            let major2 = match major1{
                //TODO is there a way to report error when None appears?
                case None => ???
                case Some(y) => y
            };
            let major3 = match major2{
                case Err(_) => ???
                case Ok(y) => y
            };
            let minor1 = List.head(List.slice(1,2,intstring));
            let minor2 = match minor1 {
                case None => ???
                case Some(y) => y
            };
            let minor3 = match minor2{
                case Err(_) => ???
                case Ok(y) => y
            };

            let patch1 = List.head(List.slice(2,3,intstring));
            let patch2 = match patch1 {
                case None => ???
                case Some(y) => y
            };
            let patch3 = match patch2{
                case Err(_) => ???
                case Ok(y) => y
            };
            Ok(major3,minor3,patch3)
            
            
    }
}