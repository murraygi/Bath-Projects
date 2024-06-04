toPart recipient = "Dear " ++ recipient ++ ",\n"
bodyPart title = "Thanks for buying " ++ title ++ ".\n"
fromPart author = "Thanks,\n" ++ author

createEmail recipient title author = toPart recipient ++
                                     bodyPart title ++
                                     fromPart author

main :: IO()
main = do
   print "Who is the email for?"
   recipient <- getLine
   print "What is the Title?"
   title <- getLine
   print "Who is the Author?"
   author <- getLine
   print (createEmail recipient title author)