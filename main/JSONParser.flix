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
use Pkger/JSON.JSON.{JString,JNumber,JArray,JObject};

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

        pub def json2author(j: JSON): Result[Author,String] = match j{
            case JObject(o) => 
                let authorName = Map.get("name",o);
                let authorEmail = Map.get("email",o);
                let authorWebsite = Map.get("website",o);
                match (authorName,authorEmail,authorWebsite) {
                    //TODO handle the error cases author exist and not exist 
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
            case JNumber(_) => Err("Unexpected number")
            case JArray(_) => Err("Unexpected array")
        }
            
    }
}