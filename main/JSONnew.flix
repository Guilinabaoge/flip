namespace Pkger{
    namespace JSONnew{
    
    instance ToString[ParseResult[a]] with [a: ToString]{
        def toString(x: ParseResult[a]):String = match x{
            case Success(x) => "Success" 
            case Failure(a) => "Failure" 

        }
    }


    //TODO fix the eq instance for ParseResult[a]
    instance Eq[ParseResult[a]] with [a : Eq, a: Order]{
        pub def eq(xp: ParseResult[a], yp: ParseResult[a]): Bool = match (xp,yp) {
            case (Success(a),Success(b)) => true  
        }

        pub def neq(xp: ParseResult[a], yp: ParseResult[a]): Bool = ???
    }  

    
    
    //TODO ParseResult 
    pub enum ParseResult[a]{
    case Success(a)
    case Failure(String)
    }
    
    //TODO Parser type 
    pub enum Parser[t]{
        case Parser(String -> ParseResult[(t,String)])
    }

    //TODO pchar 
    pub def pchar(charToMatch: String): Parser[String] =  
        let innerFn = str -> if (String.isEmpty(str)) {Failure("No more input")} 
        else {  
            let first = String.sliceLeft(str,1);
            if (first == charToMatch) {
                let remaining = String.sliceRight(str,1);
                Success(charToMatch,remaining)
            }
            else {
                let msg = "Expecting ${charToMatch}. Got ${first}";
                Failure(msg)
            }
        };
        Parser(innerFn)

    //TODO run 
    pub def run(parser: Parser[t], input: String): ParseResult[(t,String)] & Impure= 
        let Parser(innerFn) = parser;
        let x = innerFn(input);
        match x {
            case Success(charToMatch,remain) => remain|> println; Success(charToMatch,remain)
            case Failure(a) => ???
        }
        
    //TODO sequence 
    //TODO mapP

    pub def returnP(x: String): Parser[String] = 
        let innerFn = input -> Success(x, input);
        Parser(innerFn)

    
    

}
}


