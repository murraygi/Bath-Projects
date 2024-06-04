data Duck = Duck String Int Float | Duckling String Int Float
  deriving Show

donald :: Duck
donald = Duck "Donald" 6 0.5

daisy :: Duck
daisy = Duck "Daisy" 5 0.8

huey :: Duck
huey = Duckling "Huey" 2 0.7

dewey :: Duck
dewey = Duckling "Dewey" 2 0.6

duckFamily :: [Duck]
duckFamily = [donald,daisy,huey,dewey]

birthday :: Duck -> Duck
birthday (Duck name age height) = Duck name (age + 1) height
birthday (Duckling name age height) 
  | age == 2  = Duck name 3 height
  | otherwise = Duckling name (age + 1) height

tall :: Duck -> Bool
tall (Duck _ _ height) = height > 0.6
tall (Duckling _ _ height) = height >= 0.25