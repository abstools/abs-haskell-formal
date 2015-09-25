module Main where

import ABS
import Debug.Trace

-- Attributes ids' trick
attrs@(actors:rounds                  -- parameters of the program
 :afirst:anext -- holding actors
 :iD:iDnext         -- each actor has an id (int) because we want to use arithmetic on it
 :rcurrent:rnext     -- each actor hold the current round number (int) and the next (we do arithmetic on it)
 :f1                 -- dummy future for async calls
 :vlast              -- a dummy object that holds the value 1
 :[]) = [1..10]

{-
main := 
   first := new;
   f1 := first ! init_first(n);
   await f1;                    -- wait for the init of all the actors to finish
   f2 := first ! go(r);
-}

main_ :: Method
main_ [] this wb k = 
  -- Parameters of the threadring program
   Assign actors (Param 10) $ 
   Assign rounds (Param 100) $ 
   Assign afirst New $ 
   Assign f1 (Async afirst init_first [actors]) $ 
   Await f1 $ 
   trace "init finished" Assign f1 (Async afirst go [rounds]) k

{-
init_first(i) :=
   id := i;
   first := this;
   next := new;
   f1 = next ! init_rest(n-1,first);
   await f1;                    -- wait for the init of the rest actors to finish
-}

init_first :: Method
init_first [i] this wb k = 
    Assign iD (Param i) $ 
    Assign iDnext (Param (i-1)) $ -- using int arithmetic on params is ok
    Assign afirst (Param this) $ 
    Assign anext New $ 
    Assign f1 (Async anext init_rest [iDnext,afirst]) $ 
    Await f1 $ 
    Return iD wb k -- dummy
{-
init_rest(i,first_) :=
   this.id := n;
   first := first;
   if (not (id == 1)) {
     next := new;
     f = next ! init_rest(n-1,first);
     await f; -- wait for the init of the rest actors to finish
-}

init_rest :: Method
init_rest [i,first_] this wb k = 
    Assign iD (Param i) $ 
    Assign iDnext (Param (i-1)) $ -- using int arithmetic on params is ok
    Assign afirst (Param first_) $ 
    Assign vlast (Param 1) $      -- turning a pure value to an attribute to use in the next BEq
    If (BNeg (iD `BEq` vlast)) 
           (\ k' -> Assign anext New $ 
                   Assign f1 (Async anext init_rest [iDnext,afirst]) $ 
                   Await f1 k')
           Skip $ 
    Return iD wb k -- dummy

           
{-
go(r) :=
   if (id == 1) {
        if (r == 1) {
                 skip;   // done   , should be reached by last actor
        }
        else {
           first ! go(r-1);
        }
   }
   else {
      next ! go(r);
   }
-}

go :: Method
go [round_] this wb k = 
    Assign rcurrent (Param round_) $ 
    If (iD `BEq` vlast)
       (If (rcurrent `BEq` vlast) 
           Skip  -- done
           (\ k' -> Assign rnext (Param (round_ -1)) $ -- placeholder
                   Assign f1 (Async afirst go [rnext]) k'))
       (Assign f1 (Async anext go [rcurrent])) $ 
    Return iD wb k              -- dummy


main :: IO ()
main = printHeap =<< run 10000 main_ (length attrs + 1)
