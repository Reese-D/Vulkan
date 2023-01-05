module Main (main) where

--import Graphics.Vulkan
--import Graphics.Vulkan.Core_1_0
--import Foreign.Storable
--import Foreign.Marshal.Alloc
--import Foreign.C.String

--import Control.Monad.Loops

import           Graphics.UI.GLFW         (ClientAPI (..), WindowHint (..))
import qualified Graphics.UI.GLFW         as GLFW

main :: IO ()
main = do
  _ <- GLFW.init
  GLFW.windowHint $ WindowHint'ClientAPI ClientAPI'NoAPI
  GLFW.windowHint $ WindowHint'Resizable False
  mw <- GLFW.createWindow 800 600 "Vulkan" Nothing Nothing
  case mw of
    Nothing -> putStrLn "Failed to initialize GLFW window"
    Just window -> do
      putStrLn "Intializing GLFW window"
      mainLoop window


mainLoop :: GLFW.Window -> IO()
mainLoop window = do
  shouldClose <- GLFW.windowShouldClose window
  GLFW.pollEvents
  case shouldClose of
    True -> putStrLn "ending loop"
    False -> mainLoop window

    

