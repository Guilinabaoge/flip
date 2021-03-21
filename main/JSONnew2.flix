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
            }
        }

        pub enum JSON{
            case JObject(Map[String,JSON])
            case JArray(List[JSON])
            case JString(String)
            case JNumber(Int32)
        }

        pub def parse(tokens: List[String], _result: Map[String,JSON]): Result[(JSON,List[String]),String] & Impure= 
            match tokens {
                case Nil => "Hi19" |> println; Err("Missing close }")
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
                    let* (parsedvalue,resttokens) = parse(tokens,Map.empty());
                    let newlist = parsedvalue :: list;
                    pJArray(resttokens,newlist)
                } 
            }
    
        pub def pJObject(tokens: List[String],result: Map[String,JSON]): Result[(JSON,List[String]),String] & Impure = 
        use Result.flatMap;
            match tokens {
                case Nil => Err("missing }")
                case n :: rest => match n {
                    case "}" => Map.get("authors",result)|> println; Ok((JObject(result),rest))
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
                        let* (parsedv,rest2) = parse(restofrest,Map.empty());
                        let result2 = Map.insert("${n}",parsedv,result);
                        //TODO what's wrong with the print statement under? 
                        //result2|> println;
                        //"rest2" |> println;
                        //rest2 |> println;
                        pJObject(rest2,result2)
                    }
                }
            }
            
    }
}