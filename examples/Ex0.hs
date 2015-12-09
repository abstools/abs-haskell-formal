module Main where

import ABS

attrs@(x:y:z:w:[]) = [1..4]

main_ :: Method
main_ [] this wb k =
	Assign x (Val (ICons 8)) $ 
	Assign y (Val (IMod (ICons 5) (ICons 2))) $
	Assign z (Val (IAdd (Attr x) (Attr y) )) $
	If (IEq (Attr z) (ICons 9)) (\k' -> Assign w (Val (ICons 1)) k') (\k' -> Assign w (Val (ICons 0)) k') $
	k
	
main :: IO ()
main = printHeap =<< run 10 main_ (length attrs+1)
