--Lists

halving :: Int -> [Int]
halving n | n == 0 = []
          | odd n  = n : halving (n-1)
          | even n = n : halving (div n 2)

collatz :: Int -> [Int]
collatz 1 = [1] -- Base case: sequence ends when 1 reached
collatz n
    | even n    = n : collatz (n `div` 2) -- if n even, divide by 2
    | otherwise = n : collatz (3 * n + 1) -- if n odd, triple and add 1

colLength :: Int -> Int
colLength = length . collatz

-- Pattern Matching

maxList :: [Int] -> Int
maxList [] = 0
maxList [x] = x
maxList (x:xs) = max x (maxList xs)


allDucks :: [String] -> Bool
allDucks [] = True -- Base case
allDucks (x:xs)
    | x == "duck" = allDucks xs -- Recursively check rest of list
    | otherwise = False -- If string not 'duck' return False

duckDuckGoose :: [String] -> Bool
duckDuckGoose [] = False -- Base case
duckDuckGoose [x] = x == "goose" -- Check if the single element is goose
duckDuckGoose (x:xs)
    | x == "duck" = duckDuckGoose xs -- recursively check the rest of the list
    | otherwise = False -- if any string not duck return False

--Pairs

ducks :: [(String,Int)]
ducks = [("Donald",6),("Daisy",5),("Huey",2),("Louie",2),("Dewey",2)]

noDDucks :: [(String,Int)] -> [String]
noDDucks [] = []
noDDucks ((name,age):xs)
    | head name /= 'D' = name : noDDucks xs
    | otherwise = noDDucks xs

youngOrShort :: [(String, Int)] -> Bool
youngOrShort [] = False
youngOrShort ((name, age):xs)
    | age < 3 || length name <= 3 = True
    | otherwise = youngOrShort xs

describeDucks :: [(String, Int)] -> String
describeDucks [] = "No ducks to describe."
describeDucks ducks = "The ducks are: " ++ duckList
  where
    duckList = foldr (\(name, age) acc -> acc ++ "\n- " ++ name ++ " (" ++ show age ++ " years old)") "" ducks
