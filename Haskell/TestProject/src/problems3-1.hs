import Data.Char

---Maps

toLowerSt :: String -> String
toLowerSt = map toLower

isConsonant :: Char -> Bool
isConsonant c = toLower c `elem` "bcdfghjklmnpqrstvwxyz"

toLowerCons :: Char -> Char
toLowerCons c
      | isConsonant c = toLower c
      | otherwise = c

toLowerConsSt :: String -> String
toLowerConsSt = map toLowerCons

---Filters

onlyLetters :: String -> String
onlyLetters = filter isLetter

onlyNumsOrLetters :: String -> String
onlyNumsOrLetters = filter (\c -> isDigit c || isLetter c)

onlyLettersToLower1 :: String -> String
onlyLettersToLower1 = map toLower . filter isLetter

onlyLettersToLower2 :: String -> String
onlyLettersToLower2 = filter isLetter . map toLower

---Zips

firstNames :: [String]
firstNames = ["Adam","Brigitte","Charlie","Dora"]

secondNames :: [String]
secondNames = ["Ashe","Brown","Cook","De Santis"]

wholeNames :: [(String, String)]
wholeNames = zip firstNames secondNames

countNames :: [String] -> [(String, Int)]
countNames names = zip names [1..]

wholeNames2 :: [String]
wholeNames2 = zipWith (\f s -> f ++ " " ++ s) firstNames secondNames
              
rollCall :: [String]
rollCall = zipWith call [1..] wholeNames2
      where 
            call :: Int -> String -> String
            call index name = "Student " ++ show index ++ ": " ++ name

main :: IO ()
main = putStr $ unlines rollCall