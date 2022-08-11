#!/usr/bin/env stack
-- stack script --resolver lts-19.18 --package transformers
import           Control.Monad.Trans.Maybe
import           System.IO
import           Text.Read                      ( readMaybe )

prompt :: Read a => String -> IO (Maybe a)
prompt question = do
    putStr question
    putStr ": "
    hFlush stdout
    answer <- getLine
    return $ readMaybe answer

ageInYear :: IO (Maybe Int)
ageInYear = do
    mbirthYear <- prompt "Birth year"
    case mbirthYear of
        Nothing        -> return Nothing
        Just birthYear -> do
            mfutureYear <- prompt "Future year"
            case mfutureYear of
                Nothing         -> return Nothing
                Just futureYear -> return $ Just $ futureYear - birthYear

main :: IO ()
main = do
    mage <- ageInYear
    case mage of
        Nothing  -> putStrLn $ "Some problem with input, sorry"
        Just age -> putStrLn $ "In that year, age will be: " ++ show age
