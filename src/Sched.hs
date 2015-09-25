{-# LANGUAGE BangPatterns #-}
-- | The global scheduler that schedules COGs (single-objects in our case)
--
-- The global scheduler employs a fixed roun-robin scheduling strategy.
module Sched (run',run) where

import Base
import Eval
import qualified Q
import Data.Sequence as S
import qualified Data.Vector.Mutable as V
import Debug.Trace (traceIO)
import Control.Monad (void)
import Data.List (foldl')

-- | The main entrypoint. Should be written in Haskell as:
--
-- > main = run' maxIterations mainABSmethod attributeArraySize
--
--  Function just initializes the configuration (the heap and scheduler-queue) and starts the global scheduler.
run' :: Int -> Method -> Int -> IO ()
run' maxIters mainMethod attrArrSize = void $ run maxIters mainMethod attrArrSize



-- | Similar to 'run'', but returns the final heap 
--
--  Function just initializes the configuration (the heap and scheduler-queue) and starts the global scheduler.
run :: Int                       -- ^ number of iterations to run
    -> Method -- ^ which is the ABS main-block (method with no this context)
    -> Int -- ^ a fixed size for the attribute-array (i.e. how many possible attribute names)
    -> IO Heap      -- ^ the statement-count and the final heap after executing of the program
run maxIters mainMethod attrArrSize = do
  let mainObjRef = 0 -- main-object (by convention: ref=0)
  let mainFutRef = mainObjRef + 1 -- main-method's destiny (by convention: ref=1)

  initObjVec <- V.new heapInitialSize -- the initial object heap array
  initFutVec <- V.new heapInitialSize -- the initial future heap array

  initAttrVec <- V.replicate attrArrSize (-1) -- main-objects' attribute array
  (initAttrVec `V.write` 0) (-123) -- the main object only has a default "__main__" attribute to return it in the end

  -- put the main-object in the object heap
  (initObjVec `V.write` mainObjRef) (initAttrVec, S.singleton $ Proc (mainFutRef
                                                                     -- async call to main method
                                                                     ,mainMethod [] mainObjRef Nothing (last_main)
                                                                     ))

  -- putting the main-destiny as unresolved
  (initFutVec `V.write` mainFutRef) (Left [])

  let initHeap = Heap { objects = initObjVec
                      , futures = initFutVec
                      , newRef = mainFutRef+1}

  let initSchedQueue = Q.empty `Q.snoc` mainObjRef -- initial scheduler-queue contains just the main-object 


  sched maxIters 0 (initHeap,initSchedQueue)
  where
      last_main :: Stmt
      last_main = Return 0 Nothing (error "call to main: main is a special block")	

      -- | The global-system scheduler simply picks (in a round-robin) a next object to execute from the queue,  
      -- and calls `eval` on that object
      sched :: Int               -- ^ current iteration 
             -> Int               -- ^ real steps (ignoring 'get' on unresolved futures)
             -> (Heap,SchedQueue) -- ^ an initial program configuration
             -> IO Heap             -- ^ the message
      sched !n !real (h,!pt)
          | n < 0 = error "iterations must be positive"
          | n == 0 = traceIO ("reached max steps\nLast SchedTable: " ++ show pt) >> return h
          | Q.isEmpty pt = traceIO ("Real steps:\t" ++ show real ++ "\nTotal steps:\t" ++ show (maxIters-n)) >> return h
          | otherwise = do
        let (firstObj,restObjs) = Q.pop pt
        (execedStmt, addedSched, h') <- eval firstObj h attrArrSize
        let pt' = foldl' Q.snoc restObjs  addedSched
        sched (n-1) (countIns execedStmt real) (h', pt')


countIns :: Stmt -> Int -> Int
countIns GetBlocked n = n
countIns _ n = n+1

-- | Initial size of each heap (object heap and future heap)
heapInitialSize :: Int
heapInitialSize = 10
