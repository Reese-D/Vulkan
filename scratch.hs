import qualified Data.Foldable as F  
import System.IO

data Tree a = Empty | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

instance F.Foldable Tree where  
    foldMap f Empty = mempty  
    foldMap f (Node x l r) = F.foldMap f l `mappend`  
                             f x           `mappend`  
                             F.foldMap f r

testTree = Node 5  
           (Node 3  
             (Node 1 Empty Empty)  
             (Node 6 Empty Empty)  
           )  
           (Node 9  
             (Node 8 Empty Empty)  
             (Node 10 Empty Empty)  
           )  

-- example
-- F.foldl (+) 0 testTree




-- Monads example

type Birds = Int  
type Pole = (Birds,Birds)  

-- landLeft :: Birds -> Pole -> Pole  
-- landLeft n (left,right) = (left + n,right)  
--   
-- landRight :: Birds -> Pole -> Pole  
-- landRight n (left,right) = (left,right + n)


-- --now we can do something like this
--print $ landLeft 2 (landRight 1 (landLeft 1 (0,0))) --returns (3,1)

-- --lets make it a little cleaner with a new operator
(-:) :: t1 -> (t1 -> t2) -> t2
x -: f = f x

--example
--print $ 100 -: (*3) --returns 300

--same as first example
--(0,0) -: landLeft 1 -: landRight 1 -: landLeft

landLeft :: Birds -> Pole -> Maybe Pole  
landLeft n (left,right)
    | abs ((left + n) - right) < 4 = Just (left + n, right)  
    | otherwise                    = Nothing  
  
landRight :: Birds -> Pole -> Maybe Pole  
landRight n (left,right) 
    | abs (left - (right + n)) < 4 = Just (left, right + n)  
    | otherwise                    = Nothing

--now if too many birds land on one side of the pole compared to the other, our sad pole dancer falls
--we can't use the old operator anymore though, since this returns a type of Maybe Pole not just Pole

--this is where the monad operator (>>=) comes in
--(>>=) :: Monad m => m a -> (a -> m b) -> m b
--return (0,0) >>= landRight 2 >>= landLeft 2 >>= landRight 2 --Nothing


--now we can add a new function that always makes pierre fall
banana :: Pole -> Maybe Pole  
banana _ = Nothing

--return (0,0) >>= landLeft 1 >>= banana >>= landRight 1  --Nothing

--this is where >> operator comes in
--(>>) :: Monad m => m a -> m b -> m b
--return (0,0) >>= landLeft 1 >> Nothing >>= landRight 1  --Nothing
--the >> discards whatever came in on the left side
--it's defined as so
--m >> n = m >>= \_ -> n  



--monads also apply to lists, here's the implementation

    -- instance Monad [] where  
    --     return x = [x]  
    --     xs >>= f = concat (map f xs)  
    --     fail _ = []  

--[3,4,5] >>= \x -> [x,-x]  
--[3,-3,4,-4,5,-5]  

--[] >>= \x -> ["bad","mad","rad"] 
--[]

-- [1,2,3] >>= \x -> []  
-- []  
