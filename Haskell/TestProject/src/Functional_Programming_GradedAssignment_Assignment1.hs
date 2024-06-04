type Var = String

data Term =
    Variable Var
  | Lambda   Var  Term
  | Apply    Term Term
--deriving Show

instance Show Term where
  show :: Term -> String
  show = pretty

example :: Term
example = Lambda "a" (Lambda "x" (Apply (Apply (Lambda "y" (Variable "a")) (Variable "x")) (Variable "b")))

pretty :: Term -> String
pretty = f 0
    where
      f i (Variable x) = x
      f i (Lambda x m) = if i /= 0 then "(" ++ s ++ ")" else s where s = "\\" ++ x ++ ". " ++ f 0 m 
      f i (Apply  n m) = if i == 2 then "(" ++ s ++ ")" else s where s = f 1 n ++ " " ++ f 2 m


------------------------- Assignment 1

-- numeral function generates the corresponding Church numeral as a Term
numeral :: Int -> Term
numeral i = Lambda "f" (Lambda "x" (numeral' i (Variable "x")))

-- Helper function
numeral' :: Int -> Term -> Term
numeral' 0 x = x
numeral' i x = Apply (Variable "f") (numeral' (i - 1) x)


-------------------------

merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys)
    | x == y    = x : merge xs ys
    | x <= y    = x : merge xs (y:ys)
    | otherwise = y : merge (x:xs) ys


------------------------- Assignment 2

-- generate infinite list of variable names
variables :: [Var]
variables = [c : num | num <- "" : map show [1..], c <- ['a'..'z']]

-- filter out from the first list of variables those that appear in the second list
filterVariables :: [Var] -> [Var] -> [Var]
filterVariables vars usedVars = [v | v <- vars, v `notElem` usedVars]

-- generate a fresh variable
fresh :: [Var] -> Var
fresh usedVars = head (filterVariables variables usedVars)

-- return a sorted list of all variables used in a lambda term
used :: Term -> [Var]
used (Variable v) = [v]
used (Lambda v m) = merge [v] (used m)
used (Apply m n)  = merge (used m) (used n)


------------------------- Assignment 3

-- renames variable x to y in term t
rename :: Var -> Var -> Term -> Term
rename x y t@(Variable z)
  | x == z    = Variable y
  | otherwise = t
rename x y t@(Lambda z m)
  | x == z    = Lambda y (rename x y m)
  | otherwise = Lambda z (rename x y m)
rename x y (Apply n m) = Apply (rename x y n) (rename x y m)

-- substitutes variable x with term n in term t, avoiding variable capture
substitute :: Var -> Term -> Term -> Term
substitute x n t@(Variable z)
  | x == z    = n
  | otherwise = t
substitute x n t@(Lambda z m)
  = let z' = if z == x || z `elem` used n then fresh (x : used n ++ used m) else z
    in Lambda z' (substitute x n (rename z z' m))
substitute x n (Apply m1 m2) = Apply (substitute x n m1) (substitute x n m2)

------------------------- Assignment 4

beta :: Term -> [Term]
beta (Apply m1@(Lambda x m) n) = 
    [substitute x n m] ++
    [Apply m' n | m' <- beta m1] ++ 
    [Apply m1 n' | n' <- beta n]
beta (Apply m n) = 
    [Apply m' n | m' <- beta m] ++
    [Apply m n' | n' <- beta n]
beta (Lambda x m) = [Lambda x m' | m' <- beta m]
beta _ = []

--return list of all intermediate terms
normalize :: Term -> [Term]
normalize m = m : case beta m of
                     [] -> []
                     (m':_) -> normalize m'

--return final term
normal :: Term -> Term
normal = last . normalize

------------------------- 
--handle additional cases of beta reduction
aBeta :: Term -> [Term]
aBeta (Lambda x m) = [Lambda x m' | m' <- aBeta m] ++ 
    case m of
        Apply (Lambda _ _) _ -> [Lambda x m' | m' <- aBeta m]
        _ -> []
aBeta (Apply m@(Lambda x m') n) = [substitute x n m'] ++ 
    [Apply m'' n | m'' <- aBeta m] ++ 
    [Apply m n' | n' <- aBeta n]
aBeta (Apply m n) = 
    [Apply m' n | m' <- aBeta m] ++ 
    [Apply m n' | n' <- aBeta n]
aBeta _ = []

aNormalize :: Term -> [Term]
aNormalize m = m : case aBeta m of
                     [] -> []
                     (m':_) -> aNormalize m'

aNormal :: Term -> Term
aNormal = last . aNormalize


-------------------------
--test data
example1 :: Term
example1 = Apply (Lambda "x" (Apply (Variable "x") (Variable "x"))) (Lambda "x" (Apply (Variable "x") (Variable "x")))

example2 :: Term
example2 = Apply (Lambda "x" (Apply (Variable "x") (Lambda "y" (Variable "y")))) (Variable "z")