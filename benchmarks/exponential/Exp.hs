next:zero:l:r:f:g:the_end:_=[1..]

{-
main := this.go [InitialArgument]
-}

{-

go [current]this :=
  zero := 0;                     -- constant
  next := current - 1;
  if (next != zero) {
    l:=new;
    r:=new;
    f := l ! go(next);
    g := r ! go(next);
    await f;
    await g;
  }
  Return next; -- dummy
-}


main_ :: Method
main_ [] this wb k =
    Assign next (Val (I n)) $
    Assign next (Sync go [next]) k

go :: Method
go [current] this wb k =
  Assign next (Val (Sub (Param current) (I 1))) $
  Assign zero (Val (I 0)) $ -- constant
  If (BNeg (next `BEq` zero))
     (\ k' -> Assign l New $
             Assign r New $
             Assign f (Async l go [next]) $
             Assign g (Async r go [next]) $
             Await f $
             Await g k')
     Skip $
  Return next wb k -- dummy
  

main :: IO ()
main = run' 10000000 main_ the_end
