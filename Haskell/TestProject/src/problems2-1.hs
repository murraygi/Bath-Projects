import Data.Char

---Exercise 1

toUpperSt :: String -> String
toUpperSt [] = []
toUpperSt (c:cs) = toUpper c : toUpperSt cs

deleteDigits :: String -> String
deleteDigits [] = []
deleteDigits (c:cs)
    | isDigit c = deleteDigits cs
    | otherwise = c : deleteDigits cs

leetSpeak :: String -> String
leetSpeak = (++ "!") . map convertChar

convertChar :: Char -> Char
convertChar 'e' = '7'
convertChar 'o' = '0'
convertChar 's' = 'z'
convertChar c = c

--Exercise 2

factors2 :: Int -> [Int]
factors2 0 = []
factors2 n | (n `mod` 2 == 0) =  2 : factors2 (n `div` 2)
           | otherwise        = [n]

factorsm :: Int -> Int -> [Int]
factorsm m n | (n `mod` m == 0) =  m : factorsm m (n `div` m)
             | otherwise        = factorsm' m n
  where
    factorsm' :: Int -> Int -> [Int]
    factorsm' _ 1 = []
    factorsm' m' n' | (n' `mod` m' == 0) =  m' : factorsm' m' (n' `div` m')
                    | otherwise           = [n']


factorsFrom :: Int -> Int -> [Int]
factorsFrom _ 0 = []
factorsFrom m n | n == m           = [m]   
                | (n `mod` m == 0) = m : factorsFrom m (n `div` m)  
                | otherwise        = factorsFrom (m+1) n


primeFactors :: Int -> [Int]
primeFactors n = factorsFrom 2 n
