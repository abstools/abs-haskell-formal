module Main where

import ABS

(x:f:y:z:mx:the_end) = [1..]

main_ :: Method
main_ [] this wb k = \ () -> Assign x New $ \ () -> Assign f (Async x m []) $ \ () -> Assign y (Get f) $ \ () -> Assign x New $ \ () -> Assign f (Async x m []) $ \ () -> Assign y (Get f) $ \ () -> Assign x New $ \ () -> Assign f (Async x m []) $ \ () -> Assign y (Get f) $ \ () -> Assign x New $ \ () -> Assign f (Async x m []) $ \ () -> Assign y (Get f) $ \ () -> Assign x New $ \ () -> Assign f (Async x m []) $ \ () -> Assign y (Get f) k


m :: Method
m [] this wb k = \ () ->
	Assign mx (Sync ma []) $ \ () ->
  Assign mx (Sync ma []) $ \ () ->
  Assign mx (Sync ma []) $ \ () ->
  Assign mx (Sync ma []) $ \ () ->
  Assign mx (Sync ma []) $ \ () ->
  Return mx wb k
 	
ma :: Method
ma [] this wb k = \ () -> Assign z New $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Assign z (Attr z) $ \ () -> Return z wb k

main :: IO ()
main = run' 1000000 main_ (head the_end)
