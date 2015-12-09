module TestWhile where

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
    Assign n (Val (ICons 10)) $ 
    Assign res (Sync factorial [n]) $
    k

factorial :: Method
factorial [nn] this wb k =
	Assign fac (Val (ICons 1)) $
	Assign i (Val (ICons nn)) $
	While (IGT (Attr i) (ICons 0)) 
		(\k' -> (Assign fac (Val (IProd (Attr fac) (Attr i)))) $ 
		        (Assign i (Val (ISub (Attr i) (ICons 1))) ) $ k'
		) $
	Return fac wb $
	k

main :: IO ()
main = printHeap =<< run 10000000 main_ the_end
