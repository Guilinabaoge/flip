/// use Pkger/JSONnew.{pchar,run};
/// use Pkger/JSONnew.ParseResult.Success;
/// @test
///     def testJSONnew01(): Bool & Impure= 
///     let parserA = pchar("a");
///     let result = run(parserA,"abc");
///     result == Success("a","bc")