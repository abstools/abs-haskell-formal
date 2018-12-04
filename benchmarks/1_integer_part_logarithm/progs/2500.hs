module Main where
import ABS

(x:n:base:i:next:nn:obj:f:max_val:log_val:the_end) = [0..]

main_ :: Method
main_ [] this wb k = 
  Assign n (Val (I 2500)) $
  Assign base (Val (I 2)) $
  Assign max_val (Val (I 11)) $
  Assign x (Sync logarithm [n,base,max_val]) $
  k


logarithm :: Method
logarithm [pn, pb, pmax] this wb k =
  Assign i (Val (I 0)) $
  Assign next (Val (I pb)) $
  Assign log_val (Val (I 0)) $
  While (ILTE (Attr i) (I pmax)) (\k' -> 
    If (IGTE (Attr next) (I pn)) 
      (\k' -> Assign log_val (Val (Attr i)) k') 
      (\k' -> k') $
    Assign i (Val (Add (Attr i) (I 1))) $
    Assign next (Val (Prod (Attr next) (I pb))) $
    k'
  ) $
  Return i wb k


main :: IO ()
main = run' 1000000 main_ (head the_end)

main' :: IO ()
main' = printHeap =<< run 1000000 main_ (head the_end)
