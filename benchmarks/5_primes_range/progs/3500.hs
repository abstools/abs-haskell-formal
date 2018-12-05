module Main where
import ABS

(x:i:ni:num_div:obj:i_divides:f:n:primeb:reminder:res:nprimes:fv:the_end) = [1..]

main_ :: Method
main_ [] this wb k = 
  Assign n (Val (I 3500)) $
  Assign x (Sync check_primes [n]) $
  k

check_primes :: Method
check_primes [pn] this wb k =
  Assign nprimes (Val (I 0)) $
  Assign i (Val (I 2)) $
  While (ILTE (Attr i) (I pn)) (\k' -> 
    Assign obj New $
    Assign f (Async obj is_prime [i]) $
    Await f $
    Assign fv (Get f) $
    Assign nprimes (Val (Add (Attr nprimes) (Attr fv))) $
    Assign i (Val (Add (Attr i) (I 1))) $
    k'
  ) $
  Return nprimes wb k
  

is_prime :: Method
is_prime [pn] this wb k =
  Assign i (Val (I 1)) $
  Assign ni (Val (I pn)) $
  Assign num_div (Val (I 0)) $
  While (ILTE (Attr i) (Attr ni)) (\k' -> 
    Assign obj New $
    Assign f (Async obj divides [i,ni]) $
    Await f $
    Assign i_divides (Get f) $
    Assign num_div (Val (Add (Attr num_div) (Attr i_divides))) $
    Assign i (Val (Add (Attr i) (I 1))) $
    k'
  ) $
  If (IEq (Attr num_div) (I 2)) 
    (\k' -> Assign primeb (Val (I 1)) k')
    (\k' -> Assign primeb (Val (I 0)) k') $
  Return primeb wb k
  
  
divides :: Method
divides [pd, pn] this wb k =
  Assign reminder (Val (Mod (I pn) (I pd)) ) $
  If (IEq (Attr reminder) (I 0)) 
    (\k' -> Assign res (Val (I 1)) k')  
    (\k' -> Assign res (Val (I 0)) k' ) $
  Return res wb k


main' :: IO ()
main' = run' 9999999999999999 main_ (head the_end)

main :: IO ()
main = printHeap =<< run 9999999999999999 main_ (head the_end)
