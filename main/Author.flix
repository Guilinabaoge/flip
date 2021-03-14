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
    namespace Author{
        instance Eq[Author] {
            def eq(x: Author, y: Author): Bool = 
                let Author(a1) = x;
                let Author(a2) = y;
                a1.name == a2.name
            
            pub def neq(x:Author, y:Author) : Bool = false 
        }   

        instance ToString[Author] {
            def toString(x: Author): String = 
                let Author(a1) = x;
                let string = "name: #{a1.name}  email: #{a1.email} website: #{a1.website}";
                string
        } 


        pub enum Author{
            case Author({name: String, email: Option[String], website: Option[String]})
        }
    }
}