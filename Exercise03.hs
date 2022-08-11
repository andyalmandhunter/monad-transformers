#!/usr/bin/env stack
-- stack script --resolver lts-19.18 --package transformers
import           Control.Monad.Trans.Class      ( MonadTrans(lift) )
import           Control.Monad.Trans.Maybe      ( MaybeT(..) )
import           System.IO                      ( hFlush
                                                , stdout
                                                )
import           Text.Read                      ( readMaybe )

prompt :: Read a => String -> IO (Maybe a)
prompt question = do
    putStr question
    putStr ": "
    hFlush stdout
    answer <- getLine
    return $ readMaybe answer

prompt' :: Read a => String -> MaybeT IO a
prompt' = MaybeT . prompt

ageInYear :: MaybeT IO Int
ageInYear = do
    birthYear  <- prompt' "Birth year"
    futureYear <- prompt' "Future year"
    return $ futureYear - birthYear

main :: IO ()
main = do
    mage <- runMaybeT ageInYear
    case mage of
        Nothing  -> putStrLn "Some problem with input, sorry"
        Just age -> putStrLn $ "In that year, age will be: " ++ show age
