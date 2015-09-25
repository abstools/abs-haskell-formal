module Main where

import ABS

{-

main = {
  // Creating 22 objects
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;
  "o" := new;

  // Creating 22 futures
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();
  "f" := "o" ! m1();

}

m1() = {
  t := this
  return t;
}

-}

attrs@(o:f:t:[]) = [1..3]


main_ :: Method
main_ [] this wb k =  
                     -- Creating 22 objects
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     Assign o New $ 
                     -- Creating 22 Futures
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) $ 
                     Assign f (Async o m1 []) k


m1 :: Method
m1 [] this wb k =  
                  Assign t (Param this) $ 
                  Return t wb k

main :: IO ()
main = printHeap =<< run 89 main_ (length attrs+1)


{- passes output,

reached max steps

Last SchedTable: fromList []
Object Heap with array-size:80{
(23,(fromList [(3,23)],fromList []))(22,(fromList [],fromList []))(21,(fromList [],fromList []))(20,(fromList [],fromList []))(19,(fromList [],fromList []))(18,(fromList [],fromList []))(17,(fromList [],fromList []))(16,(fromList [],fromList []))(15,(fromList [],fromList []))(14,(fromList [],fromList []))(13,(fromList [],fromList []))(12,(fromList [],fromList []))(11,(fromList [],fromList []))(10,(fromList [],fromList []))(9,(fromList [],fromList []))(8,(fromList [],fromList []))(7,(fromList [],fromList []))(6,(fromList [],fromList []))(5,(fromList [],fromList []))(4,(fromList [],fromList []))(3,(fromList [],fromList []))(2,(fromList [],fromList []))(0,(fromList [(0,-123),(1,23),(2,45)],fromList []))
}

Future Heap with array-size:80{
(45,Right 23)(44,Right 23)(43,Right 23)(42,Right 23)(41,Right 23)(40,Right 23)(39,Right 23)(38,Right 23)(37,Right 23)(36,Right 23)(35,Right 23)(34,Right 23)(33,Right 23)(32,Right 23)(31,Right 23)(30,Right 23)(29,Right 23)(28,Right 23)(27,Right 23)(26,Right 23)(25,Right 23)(24,Right 23)(1,Right (-123))
}

Counter: 46

-}


{- COMMENTS:

it correctly needs 88 execution steps, because:

from main = 22 object new statements ++ 22 async calls + 1 implicit return
from m1 = 22 calls to m1 * 2 m1 statemenets = 44
= 89 steps in total

-}


