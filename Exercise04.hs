-- Does not compile
#!/usr/bin/env stack
-- stack script --resolver lts-19.18 --package transformers
import           Control.Monad.Reader
import           Lens.Micro
import           Lens.Micro.Mtl                 ( view ) -- hint :)

data LogLevel = Debug | Info
data Verbosity = Quiet | Verbose

logFunction :: Verbosity -> LogLevel -> String -> IO ()
logFunction Quiet Debug _   = return ()
logFunction _     _     str = putStrLn str

class HasVerbosity env where
  verbosityL :: Lens' env Verbosity

logDebug :: HasVerbosity env => String -> ReaderT env IO ()
logDebug msg = do
    verbosity <- _
    logFunction verbosity Debug msg

logInfo :: HasVerbosity env => String -> ReaderT env IO ()
logInfo = _

main :: IO ()
main = do
    putStrLn "===\nQuiet\n===\n"
    _ inner Quiet
    putStrLn "\n\n===\nVerbose\n===\n"
    _ inner Verbose

inner :: _
inner = do
    logDebug "This is debug level output"
    logInfo "This is info level output"
