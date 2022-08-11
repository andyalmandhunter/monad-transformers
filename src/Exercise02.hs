#!/usr/bin/env stack
-- stack --resolver lts-12.21 script

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
