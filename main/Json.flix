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
namespace Pkger{
    namespace JSON{
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
        }
    }
}