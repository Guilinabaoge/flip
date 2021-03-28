 /*
 * Copyright 2021 Magnus Madsen
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
      namespace SemVer{
        instance Eq[SemVer]{
            pub def eq(x: SemVer, y: SemVer): Bool = {
                let SemVer(a1,b1,c1) = x;
                let SemVer(a2,b2,c2) = y;
                a1 == a2 and 
                b1 == b2 and 
                c1 == c2
            }
            pub def neq(x:SemVer,y: SemVer): Bool = false
        }

        instance ToString[SemVer]{
            pub def toString(s: SemVer): String = 
                let SemVer(major,minor,patch) = s;
                "SemVer(${major},${minor},${patch})"
        }

        

        pub enum SemVer{
            case SemVer(Int32, Int32, Int32)
        }
        
        ///
        /// Return true if SemVer a have higher precedence than b or same.
        ///
        pub def lessEqual(a: SemVer, b: SemVer): Bool = 
            match (a,b){ 
                case (SemVer(majorA,minorA,patchA),SemVer(majorB,minorB,patchB)) => 
                let major = majorA <=> majorB;
                let minor = minorA <=> minorB;
                let patch = patchA <=> patchB;
                match major{
                    case GreaterThan => true
                    case EqualTo => match minor {
                        case GreaterThan => true
                        case EqualTo => match patch{
                            case GreaterThan => true
                            case EqualTo => true
                            case LessThan => false
                        }
                        case LessThan => false
                    }
                    case LessThan => false
                } 
            
            }
        }

 }
