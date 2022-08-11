-- Does not compile
#!/usr/bin/env stack
-- stack script --resolver lts-19.18 --package transformers
{-# LANGUAGE DeriveFunctor #-}
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Class
import           Data.Functor.Identity

type Reader r = ReaderT r Identity

runReader :: Reader r a -> r -> a
runReader r = runIdentity . runReaderT r

ask :: Monad m => ReaderT r m r
ask = _

main :: IO ()
main = runReaderT main' "Hello World"

main' :: ReaderT String IO ()
main' = do
    lift $ putStrLn "I'm going to tell you a message"
    liftIO $ putStrLn "The message is:"
    message <- ask lift $ putStrLn message
