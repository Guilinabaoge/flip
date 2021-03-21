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

        pub def parse(tokens: List[String], result: Map[String,JSON]): Result[JSON,String] & Impure= 
            use Result.flatMap;
            match tokens {
                case Nil => Err("Missing close }")
                case n :: rest => match n {
                    case "{" => 
                    let key_value_pair = List.slice(0,3,rest);
                    let colon = List.indexOf(":",key_value_pair);
                    if (colon != 1){
                        Err("Illegal key-value pair")
                    }
                    else {
                        let key = match List.head(rest) {
                            case None => "None"
                            case Some(y) => y
                        };
                        let* value = pJObject(List.slice(2,3,rest));
                        let result2 = Map.insert(key,value,result);
                        let rest = List.slice(3,List.length(rest),rest);
                        parse(rest,result2)}
                        
                    case "[" => ??? //parse array
                    case _ => ???
                }
            }
    
        pub def pJObject(tokens: List[String]): Result[JSON,String] = 
            match tokens {
                case Nil => Err("Missing close }")
                case n :: _rest => match n {
                    case "}" => Ok(JObject(Map.empty()))
                    case _ => 
                        let key_value_pair = List.slice(0,3,tokens);
                        let colon = List.indexOf(":",key_value_pair);
                    if (colon != 1){
                        Err("Illegal key-value pair")
                    }
                    else {
                        let value = match List.last(key_value_pair){
                            case None => "None"
                            case Some(y) => y
                        };
                        let map = Map.empty();
                        let map2 = Map.insert("${n}",JString("${value}"),map);
                        //map2 |> println;
                        Ok(JObject(map2))
                    }
                }
            }
            
    }
}