module Main where

import ABS

{--
main := 
	n = 10;
	res = this.factorial(n);
-}

{-

factorial [nn] this :=
  fac = 1;
  i = nn;
	while ( i > 0 ){
		fac = fac * i;
		i = i - 1;
	}
  return fac;
--}

res:n:fac:i:the_end:_=[1..]

main_ :: Method
main_ [] this wb k = 
    Assign n (Val (I 10)) $ 
    Assign res (Sync factorial [n]) $
    k

factorial :: Method
factorial [nn] this wb k =
	Assign fac (Val (I 1)) $
	Assign i (Val (I nn)) $
	While (IGT (Attr i) (I 0)) 
		(\k' -> (Assign fac (Val (Prod (Attr fac) (Attr i)))) $ 
		        (Assign i (Val (Sub (Attr i) (I 1))) ) $ k'
		) $
	Return fac wb $
	k

main :: IO ()
main = printHeap =<< run 10000000 main_ the_end
