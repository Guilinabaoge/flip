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

use Pkger/SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Dependency.PackageDependency;
use Pkger/JSON.{stringifyAuthors,stringifyDependency,stringifySemver};

namespace Pkger{
    namespace PackageInfo{
        instance Eq[PackageInfo] {
            pub def eq(x: PackageInfo, y: PackageInfo): Bool = 
                let PackageInfo(p1) = x;
                let PackageInfo(p2) = y;
                p1.name == p2.name and 
                p1.url == p2.url and 
                p1.version == p2.version and 
                p1.authors == p2.authors and 
                p1.edition == p2.edition and 
                p1.dependencies == p2.dependencies 

            pub def neq(x:PackageInfo, y:PackageInfo) : Bool = false 
        }   

        instance ToString[PackageInfo] {
            def toString(x: PackageInfo): String = 
                let PackageInfo(package1) = x;
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
                packageInfoString
        } 

 // Any field that's only require by the registry is ignore for now
        pub enum PackageInfo{
            case PackageInfo({
                name : String,
                version : SemVer,
                authors : List[Author],
                edition : SemVer,
                dependencies : List[PackageDependency],
                url : String
            })
        }
    }
}
