module Main where

import ABS

attrs@(x:y:z:w:[]) = [1..4]

main_ :: Method
main_ [] this wb k =
	Assign x (Val (I 8)) $ 
	Assign y (Val (Mod (I 5) (I 2))) $
	Assign z (Val (Add (Attr x) (Attr y) )) $
	If (IEq (Attr z) (I 9)) (\k' -> Assign w (Val (I 1)) k') (\k' -> Assign w (Val (I 0)) k') $
	k
	
main :: IO ()
main = printHeap =<< run 10 main_ (length attrs+1)
