use Pkger/Author.Author;
use Pkger/Author.Author.Author;

namespace Pkger{
    namespace JSONnew2{
        instance Eq[JSON]{
            pub def eq(x: JSON, y: JSON): Bool = match (x,y){
                case (JObject(a),JObject(b)) => a == b
                case (JString(a),JString(b)) => a == b 
            }
            pub def neq(x: JSON, y: JSON): Bool = ???
        }

        instance ToString[JSON]{
            pub def toString(x: JSON): String = match x {
                case JString(s) => s
                case JObject(x) => Int32.toString(Map.count((k,b)->true,x))   // map tostring?
                case JArray(a) => let arraylengh = Int32.toString(List.length(a)); "Array with length ${arraylengh}"
            }
        }

        pub enum JSON{
            case JObject(Map[String,JSON])
            case JArray(List[JSON])
            case JString(String)
            case JNumber(Int32)
        }

        pub def parse(tokens: List[String]): Result[(JSON,List[String]),String] & Impure= 
            match tokens {
                case Nil => Err("Missing close }")
                case n :: rest => match n {
                    case "{" => pJObject(rest,Map.empty())
                    case "[" => pJArray(rest,Nil)
                    case _ => Ok((JString(n),rest))
                }
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
                    //can't print result|> println;result|> println; Map.get("version",result)|> println; 
                    case "}" => result|> println;  Ok((JObject(result),rest))
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
                    //TODO why is String can't fit in Option[String] but String can? how to cast from String to Option String
                    case (Some(JString(actualAuhorName)),Some(JString(_actualAuhorEmail)),Some(JString(_actualAuhorWebsite))) => 
                    Ok(Author({name = actualAuhorName,email = None,website = None})) 
                    case (None,Some(_),Some(_)) => Err("Missing authorname")
                    case _ => Err("email or website type unexpect")
                }
            case JString(_) => Err("Unexpected string")
            case JNumber(_) => Err("Unexpected number")
            case JArray(_) => Err("Unexpected array")
        }
            
    }
}