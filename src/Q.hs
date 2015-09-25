-- | purely-functional queues (taken from Okasaki)
module Q (Q, empty, isEmpty, maybeRev, snoc,head,tail,pop) where

import Prelude hiding (head,tail)

newtype Q a = Q ([a],[a])
    deriving Show

empty :: Q a
empty = Q ([],[])

isEmpty :: Q a -> Bool
isEmpty (Q (f,_)) = null f

-- internal use only
maybeRev :: ([a], [a]) -> Q a
maybeRev ([],r) = Q (reverse r, [])
maybeRev q = Q q

snoc :: Q a -> a -> Q a
snoc (Q (f,r)) x = maybeRev (f, x:r)

head :: Q t -> t
head (Q ([],_)) = error "head: empty queue"
head (Q (x:_,_)) = x

tail :: Q a -> Q a
tail (Q ([], _)) = error "tail: empty queue"
tail (Q (_:f',r)) = maybeRev (f',r)

pop :: Q a -> (a, Q a)
pop (Q ([],_)) = error "pop: empty queue"
pop (Q (x:f',r)) = (x, maybeRev (f',r))
