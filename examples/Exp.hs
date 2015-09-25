module Main where

import ABS

next:one:l:r:f:g:the_end:_=[1..]

{-
main := this.go [InitialArgument]
-}

{-

go [current]this :=
  one := 1;                     -- constant
  next := current - 1;
  if (next != one) {
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
    Assign next (Param 4) $ 
    Assign next (Sync go [next]) k

go :: Method
go [current] this wb k = 
  Assign next (Param (current-1)) $ 
  Assign one (Param 1) $  -- constant
  If (BNeg (next `BEq` one))
     (\ k' -> Assign l New $ 
             Assign r New $ 
             Assign f (Async l go [next]) $ 
             Assign g (Async r go [next]) $ 
             Await f $ 
             Await g k')
     Skip $
  Return next wb k -- dummy
  

main :: IO ()
main = printHeap =<< run 10000000 main_ the_end
