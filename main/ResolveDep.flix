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

use Pkger/PackageInfo.PackageInfo;
use Pkger/PackageInfo.PackageInfo.PackageInfo;
use Pkger/PackageInfo.{pinfogetname, pinfogetversion};
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;

namespace Pkger{
    namespace ResolveDep{
        pub def getFullDependencies(packagename: String, registry: Map[String,PackageInfo]): Result[{name: String, version: SemVer, url: String},String] & Impure= 
            let keys = Map.keysOf(registry);
            if (Set.memberOf(packagename,keys)) {
                let packageinfo = match Map.get(packagename,registry){
                    case None => ???
                    case Some(x) => x
                };
                let pname = pinfogetname(packageinfo);
                let pversion = pinfogetversion(packageinfo);
                pname |> println;
                pversion |> println;
                Ok({name = pname, version = pversion, url = "test url"})
            }
            else {
                ???
            }
            
    }
}