use Pkger/Examples.{crawler};
    @test 
    def testResolveDep(): Bool & Impure =
        let craw = crawler();
        craw |> println; 
        true