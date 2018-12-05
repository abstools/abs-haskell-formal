module Main where
import ABS

(n_div:x:main_ret:i:f:n:obj:reminder:res:the_end) = [0..]

main_ :: Method
main_ [] this wb k = 
  Assign n (Val (I 1000)) $
  Assign x (Sync primality_test [n]) $
  k


primality_test :: Method
primality_test [pn] this wb k =
  Assign i (Val (I 1)) $
  Assign n (Val (I pn)) $
  While (ILTE (Attr i) (Attr n)) (\k' -> 
    Assign obj New $
    Assign f (Async obj divides [i,n]) $
    Assign i (Val (Add (Attr i) (I 1))) $
    k'
  ) $
  Return i wb k
  
  
divides :: Method
divides [pd, pn] this wb k =
  Assign reminder (Val (Mod (I pn) (I pd)) ) $
  If (IEq (Attr reminder) (I 0)) 
    (\k' -> Assign res (Val (I 1)) k')  
    (\k' -> Assign res (Val (I 0)) k' ) $
  Return res wb k


main' :: IO ()
main' = run' 1000000 main_ (head the_end)

main :: IO ()
main = printHeap =<< run 1000000 main_ (head the_end)
