#!/usr/bin/env stack
-- stack script --resolver lts-19.18 --package transformers
{-# LANGUAGE DeriveFunctor #-}

import           Control.Monad.IO.Class         ( MonadIO(liftIO) )
import           Control.Monad.Trans.Class      ( MonadTrans(lift) )
import           Data.Functor.Identity          ( Identity(runIdentity) )

newtype ReaderT r m a = ReaderT { runReaderT :: r -> m a }
  deriving Functor

instance Monad m => Applicative (ReaderT r m) where
    pure a = ReaderT $ \_ -> return a
    ReaderT f <*> ReaderT a = ReaderT $ \r -> f r <*> a r

instance Monad m => Monad (ReaderT r m) where
    return = pure
    ReaderT a >>= f = ReaderT $ \r -> do
        b <- a r
        (runReaderT $ f b) r

instance MonadTrans (ReaderT r) where
    lift a = ReaderT $ const a

instance MonadIO m => MonadIO (ReaderT r m) where
    liftIO = lift . liftIO

type Reader r = ReaderT r Identity

runReader :: Reader r a -> r -> a
runReader r = runIdentity . runReaderT r

ask :: Monad m => ReaderT r m r
ask = ReaderT $ \r -> do
    return r

main :: IO ()
main = runReaderT main' "Hello World"

main' :: ReaderT String IO ()
main' = do
    lift $ putStrLn "I'm going to tell you a message"
    liftIO $ putStrLn "The message is:"
    message <- ask
    lift $ putStrLn message
