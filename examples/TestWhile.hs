module TestWhile where

import ABS

counter:hundred:the_end:_=[1..]



main_ :: Method
main_ [] this wb k =
  Assign counter (Param this) $
  Assign hundred (Param 100) $
  While (BNeg (counter `BEq` hundred)) 
        (Assign counter New) k

main :: IO ()
main = printHeap =<< run 10000000 main_ the_end
