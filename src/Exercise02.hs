#!/usr/bin/env stack
-- stack script --resolver lts-19.18 --package transformers

foldTerminateM :: Monad m => (b -> a -> m (Either b b)) -> b -> [a] -> m b
foldTerminateM = _

loudSumPositive :: [Int] -> IO Int
loudSumPositive = foldTerminateM go 0
  where
    go total x
        | x < 0 = do
            putStrLn "Found a negative, stopping"
            return $ Left total
        | otherwise = do
            putStrLn "Non-negative, continuing"
            let total' = total + x
            putStrLn $ "New total: " ++ show total'
            return $ Right total'

main :: IO ()
main = do
    res <- loudSumPositive [1, 2, 3, -1, 5]
    putStrLn $ "Result: " ++ show res
