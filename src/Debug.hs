-- | for debugging: Show-instances of heaps and processes 
module Debug where

import Base
import qualified Data.Vector.Mutable as M
import Control.Monad (foldM)
import qualified Data.Vector as V (freeze, filter, indexed)
import Control.Exception

-- | util to pretty-print a heap
printHeap :: Heap -> IO ()
printHeap (Heap os fs c) = do
  oList <- foldM (\ acc i -> (do                   
                             (attrs, pqueue) <- os `M.read` i
                             fattrs <- V.freeze attrs
                             return $ show (i, (V.filter (\ (_, v) -> v /= (-1)) $ V.indexed fattrs, pqueue)) : acc)
                            `catch` (\ (ErrorCall _str) -> return acc)
                ) [] [0..c-1]
  fList <- foldM (\ acc i -> (do
                             res <- evaluate =<< fs `M.read` i
                             return $ show (i,res) : acc)
                            `catch` (\ (ErrorCall _str) -> return acc)
                   ) [] [0..c-1]

  putStrLn $ "Object Heap with array-size:" ++ show (M.length os)  ++ "{"
  putStrLn (concat oList)
  putStrLn "}"
  putStrLn $ "Future Heap with array-size:" ++ show (M.length os)  ++ "{"
  putStrLn (concat fList)
  putStrLn "}"
  putStrLn ("    Counter: " ++ show c)

instance Show Proc where
    show (Proc (destiny,_cont)) = show (destiny,"<fun>")
