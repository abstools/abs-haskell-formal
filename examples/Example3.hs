module Main where

import ABS

{-
main = {
  x := new;
  f := x ! m1();
  y = f.get;
}

m1 = {
  z := new;
  while (z==z) {
      skip;
    }
  return z;
}

-}

attrs@(x:f:y:z:[]) = [1..4]

main_ :: Method
main_ [] this wb k =
                     Assign  x New $
                         Assign f (Async x m1 []) $
                             Assign y (Get f) k


m1 :: Method
m1 [] this wb k = 
                  Assign z New $ 
                      While (z `BEq` z) 
                                (\ k' -> Skip k') $ 
                                    Return z wb k


main :: IO ()
main = printHeap =<< run 10000 main_ (length attrs+1)

{- passes, diverges, as it should
reached max steps
Last SchedTable: fromList [2]
Heap: {
    Objects:(4,(fromList [],fromList []))(2,(fromList [(4,4)],fromList [(3,"<fun>")]))(0,(fromList [(0,-123),(1,2),(2,3)],fromList [(1,"<fun>")]))
    Futures:(3,Left [0])(1,Left [])
    Counter: 5
}
 -}




