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

use Pkger/SemVer.SemVer;
namespace Pkger{
    namespace Dependency {
        instance Eq[PackageDependency]{
            pub def eq(x:PackageDependency,y: PackageDependency): Bool = {
                let PackageDependency(p1) = x;
                let PackageDependency(p2) = y;
                p1.name == p2.name and 
                p1.version == p2.version
            }
            pub def neq(x:PackageDependency,y: PackageDependency): Bool = false
        }
        pub enum PackageDependency {
            case PackageDependency({name: String, version : SemVer})  
            //case FileDependency(String, String)  
        }
    }
}