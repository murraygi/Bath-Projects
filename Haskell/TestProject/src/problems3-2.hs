data IntTree = Empty | Node Int IntTree IntTree
--   deriving Show

t :: IntTree
t = Node 4 (Node 2 (Node 1 Empty Empty) (Node 3 Empty Empty)) (Node 5 Empty (Node 6 Empty Empty))


------------------------- Exercise 1

isEmpty :: IntTree -> Bool
isEmpty Empty = True
isEmpty _     = False

rootValue :: IntTree -> Int
rootValue Empty        = 0
rootValue (Node i _ _) = i

height :: IntTree -> Int
height Empty        = 0
height (Node _ l r) = 1 + max (height l) (height r)

find :: Int -> IntTree -> Bool
find _ Empty        = False
find x (Node i l r) = x == i || find x l || find x r

instance Show IntTree where
    show = unlines . aux ' ' ' '
      where
        aux _ _ Empty = []
        aux c d (Node x s t) = 
          [ c:' ':m | m <- aux ' ' '|' s ] ++ 
          ['+':'-':show x] ++ 
          [ d:' ':n | n <- aux '|' ' ' t ]


------------------------- Exercise 2

member :: Int -> IntTree -> Bool
member _ Empty = False
member x (Node i l r) = x == i || member x l || member x r   

largest :: IntTree -> Int
largest (Node x _ Empty) = x
largest (Node _ _ r)     = largest r

deleteLargest :: IntTree -> IntTree
deleteLargest (Node _ l Empty) = l
deleteLargest (Node x l r) = Node x l (deleteLargest r)

delete :: Int -> IntTree -> IntTree
delete _ Empty = Empty
delete y (Node x l r)
    | y < x     = Node x (delete y l) r
    | y > x     = Node x l (delete y r)
    | isEmpty l = r
    | otherwise = Node w (delete w l) r
        where 
            w = largest l