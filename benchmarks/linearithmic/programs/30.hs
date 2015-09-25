module Main where

import ABS

(a:x:f:z:the_end) = [1..]

main_ :: Method
main_ [] this wb k = \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) $ \ () -> 
  Assign a (Sync g []) k

g :: Method
g [] this wb k = \ () -> 
  Assign x New $ \ () -> 
  Assign f (Async x m []) $ \ () -> 
  Assign f (Async x m []) $ \ () -> 
  Assign f (Async x m []) $ \ () -> 
  Assign f (Async x m []) $ \ () -> 
  Return x wb k

m :: Method
m [] this wb k = \ () -> 
  Assign z (Param this) $ \ () -> 
  Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Assign z (Attr z) $ \ () ->   Return z wb k

main :: IO ()
main = run' 1000000 main_ (head the_end)
