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

use Pkger/SemVer.{SemVer,lessEqual};
use Pkger/Author.Author;
use Pkger/Dependency.PackageDependency;
use Pkger/Lex.{stringifyAuthors,stringifyDependency,stringifySemver};

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
        }   

        instance ToString[PackageInfo] {
            pub def toString(x: PackageInfo): String = 
                let PackageInfo(package1) = x;
                let name = package1.name;
                let version = stringifySemver(package1.version);
                let authors = stringifyAuthors(package1.authors);
                let edition = stringifySemver(package1.edition);
                let dependencies = stringifyDependency(package1.dependencies);
                let url = package1.url;
                let quote = Char.toString('"');
                let seperator = String.lineSeparator();
                let packageInfoString = "${quote}name${quote}:${quote}${name}${quote},${seperator}${quote}version${quote}:${quote}${version}${quote},${seperator}${quote}authors${quote}:[${authors}],${seperator}${quote}edition${quote}:${quote}${edition}${quote},${seperator}${quote}dependencies${quote}:[${dependencies}],${seperator}${quote}url${quote}:${quote}${url}${quote}";
                                        
                packageInfoString
        } 

        instance Order[PackageInfo] {
            pub def compare(xs: PackageInfo, ys: PackageInfo): Comparison = match (xs,ys){
                case (PackageInfo(x),PackageInfo(y)) => (x.name,x.version,x.authors,x.edition,x.dependencies,x.url) <=> (y.name,y.version,y.authors,y.edition,y.dependencies,y.url) 
                case _ => LessThan
            }
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

        //
        // Compare same package with different version, return true if package a have newer or same version as package b
        // 9 = can't compare package with different name
        //
        pub def comparePackageInfo(a: PackageInfo,b: PackageInfo): Int32 = 
            let semverA = pinfogetversion(a);
            let semverB = pinfogetversion(b);
            if (pinfogetname(a) == pinfogetname(b)){
                if (lessEqual(semverA,semverB)) {1}
                else {0}
            }
            else {
                9 
            }

        pub def pinfogetname(p: PackageInfo): String = 
            let PackageInfo(unwrap) = p;
            unwrap.name
        
        pub def pinfogetversion(p: PackageInfo): SemVer = 
            let PackageInfo(unwrap) = p;
            unwrap.version
        
        pub def pinfogetdependencies(p: PackageInfo): List[PackageDependency] = 
            let PackageInfo(unwrap) = p;
            unwrap.dependencies

    }

}