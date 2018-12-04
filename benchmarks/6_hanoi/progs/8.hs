
module Main where
import ABS

(a:b:tmp:n:n1:res:the_end:_)=[1..]

main_ :: Method
main_ [] this wb k =
  Assign n (Val (I 8)) $
  Assign a (Val (I 1)) $
  Assign b (Val (I 3)) $
  Assign tmp (Val (I 2)) $
  Assign res (Sync hanoi [a,b,tmp,n]) k

hanoi :: Method
hanoi [a,b,tmp,n] this wb k =
  Assign res (Val (I 0)) $
  If (IGT (I n) (I 0))
    (\ k' -> Assign n1 (Val (Param (n-1))) $
             Assign res (Sync hanoi [a,tmp,b,n1]) $
             Assign n1 (Val (Param (n-1))) $
             Assign res (Sync hanoi [tmp,b,a,n1]) k')
     Skip $
  Return res wb k -- dummy
  

main :: IO ()
main = run' 9999999999999999 main_ the_end
