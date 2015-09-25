-- | The ABS' AST and the ABS-runtime data-structures
module Base where

import Data.Sequence (Seq)
import Q (Q)
import Data.Vector.Mutable (IOVector) 

-- * The values of our language

-- | We only have one type for our values: the 'Ref'erence. Both objects and future values have type 'Ref'.
-- 
-- NB: This ABS-subset is dynamically-typed, so it will probably to errors
-- if an object is expected but a future is passed, and vice-versa.
type Ref = Int

-- | An object value is a reference (index) to the object heap
--
-- note: type synonym for clarity
type ObjRef = Ref

-- | A future value is a reference (index) to the future heap
--
-- (note: type synonym for clarity)
type FutRef = Ref

-- * The datastructures used at ABS-runtime

-- | An ever-increasing memory-counter to pick new unique references when
-- creating new objects (via new) and futures (via async)
--
-- (note: type synonym for making the translation clear)
type Counter = Ref

-- | the simulated Heap datastructure where all objects&futurues live in.
--
-- NB: assume no Garbage-Collection of the Heap for the moment. At runtime,
-- no GC will be performed from the underlying Haskell-GC, because we do not delete objects.
data Heap = Heap { objects :: Objects -- ^ all the objects
                 , futures :: Futures -- ^ all the futures
                 , newRef :: Counter  -- ^ the current counter
                 }

-- | The objects of the heap is a __growable__ 0-int-indexed array where each cell is a pair of the object's attributes and the object's process queue
type Objects = IOVector (Attrs, Seq Proc)

-- | The attributes is a __fixed__ array of attribute names (Ints) to attribute values ('Ref's)
--
-- We assume a preprocessing step to transform __all__ the attribute names occuring in a program to Ints so they can become the indices to this array.
-- NB: All objects have the same fixed size attr-array, although they may only use a subset of all the attributes.
type Attrs = IOVector Ref

-- | The futures of the heap is a __growable__ int-indexed array of the futures' potential final values.
-- 
-- A future is empty ('Left'), with n callers waiting on it. 
-- A future is resolved (filled with 'Right value'), hence its type "Either [ObjRef] Ref".
--
-- NB: The correctness and preservation assume ABS programs with only 1 waiting-caller, in other words
-- programs that do not pass-over a created future to another object.
--
-- A future reference must be _final_ after resolved, and this must be guaranteed by the runtime system.
type Futures = IOVector (Either [ObjRef] Ref)

-- | We have a single (universal) type for our continuations. 
-- Later, if we introduce local-variables we are going to need an extra type for Continuations: 'Ref -> Stmt'
type Cont = Stmt

-- | Each process is a pair of its destiny future-reference, and its (resumable) continuation
--
-- (note: is a newtype just for overriding its Show instance, check module "PP")
newtype Proc = Proc {fromProc :: (FutRef, Cont)}

-- | The global-system scheduler's runtime Process Table.
--
-- It is simply a queue of object-references
type SchedQueue = Q ObjRef

-- * Our language's AST and types

-- | An ABS statement.
--
-- Statements are "chained" (sequantially composed) by deeply nesting them through 'Cont'inuations.
data Stmt = Assign Int Rhs Cont -- ^ "attr" := Rhs; cont...
          | Await Int Cont      -- ^ await "attr"; cont...
          | If BExp (Cont -> Stmt) (Cont -> Stmt) Cont -- ^ if pred ThenClause ElseClause; cont... 
          | While BExp (Cont -> Stmt) Cont             -- ^ while pred BodyClause; cont...
          | Skip Cont                                  -- ^ skip; cont...
          | Return Int (Maybe Int) Cont                -- ^ return "attr" WriteBack; cont... (note: if it is a sync call then we pass as an argument to return, the attribute to write back to, if it is async call then we pass Nothing)
          | GetBlocked                                 -- ^ Dummy instruction to be returned by sched'

-- | the RHS of an assignment
data Rhs = New
         | Get FutRef
         | Async ObjRef Method [Ref] -- ^ obj-ref ! method([params])
         | Sync Method [Ref]    -- ^ this.method([params])
         | Attr Ref       -- ^ dereference a given attribute by looking it up in this object's attribute-array
         | Param Int      -- ^ do not dereference the given value, because it is method's parameter, thus passed-by-value. This is mainly used because all 'Stmt's operate on attributes. A stmt `Assign "attr" (Param this)` would save the method's parameter to an attribute so it can be used elsewhere.

         -- note: we do not need This, because it is passed as a local parameter on each method

-- | A boolean expression occurs only as a control-flow predicate (if & while) 
--
-- It does only reference equality of attributes ('BEq') and combinators on them (conjuction,disjunction,negation).
data BExp = BEq Ref Ref
          | BNeg BExp
          | BCon BExp BExp
          | BDis BExp BExp


-- | The type of every top-level ABS-method.
type Method = [Ref]             -- ^ a list of passed (deref) parameters
            -> ObjRef            -- ^ this obj
            -> Maybe Ref         -- ^ in case of sync call: a writeback attribute to write the return result to
            -> Cont              -- ^ the continuation after the method is finished
            -> Cont              -- ^ the resulting method's continuation that will start executing when applied to ()


