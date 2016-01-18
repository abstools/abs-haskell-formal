next:zero:r:g:the_end:_=[1..]

main_ [] this wb k = go [n] this wb k

go :: Method
go [n] this wb k =
    Assign zero (Val (I 0)) $
    Assign next (Val (I n)) $
    Assign r New $
    Assign g (Async r m []) $
    Await g $
    If (BNeg (next `BEq` zero))
       (\ k' -> Skip (go [n-1] this wb k'))
       Skip k

m :: Method
m [] this wb k = Return next wb k -- dummy

main :: IO ()
main = run' 10000000 main_ the_end
