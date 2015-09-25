module Main where

import ABS

next:zero:r:g:the_end:_=[1..]

{-
main := this.go [InitialArgument]
-}

{-

go [current]this :=
  zero := 0;                     -- constant
  next := current - 1;
  if (next != zero) {
    l:=new;
    r:=new;
    f := l ! go(next);
    g := r ! go(next);
    await f;
    await g;
  }
  Return next; -- dummy
-}


main_ :: Method
main_ [] this wb k = 
    Assign next (Param 100) $ 
    Assign next (Sync go [next]) k

go :: Method
go [current] this wb k = 
  Assign next (Param (current-1)) $ 
  Assign zero (Param 0) $ -- constant
  If (BNeg (next `BEq` zero))
     (\ k' -> 
             Assign r New $ 
             Assign g (Async r go [next]) $ 
             Await g k')
     Skip $ 
  Return next wb k -- dummy
  

main :: IO ()
main = run' 10000000 main_ the_end
