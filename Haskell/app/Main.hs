{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE Strict           #-}
module Main (main) where


import           Foreign.C.String
import           Foreign.Marshal.Alloc
import           Foreign.Storable
import           Graphics.Vulkan
import           Graphics.Vulkan.Core_1_0
import           Graphics.Vulkan.Marshal.Create

import           Graphics.UI.GLFW         (ClientAPI (..), WindowHint (..))
import qualified Graphics.UI.GLFW         as GLFW

initVulkan :: String --application name
           -> String --engine name
           -> [CString] --required extensions
           -> [String] -- layer names
           -> IO VkInstance
initVulkan progName engineName extensions layers =
  withPtr iCreateInfo $ \iCrtPtr ->
  alloca $ \vkInstPtr -> do
    _ <- vkCreateInstance iCrtPtr VK_NULL vkInstPtr
    peek vkInstPtr
  where
    appInfo = createVk @VkApplicationInfo
      $  set       @"sType" VK_STRUCTURE_TYPE_APPLICATION_INFO
      &* set       @"pNext" VK_NULL
      &* setStrRef @"pApplicationName" progName
      &* set       @"applicationVersion" (_VK_MAKE_VERSION 1 0 0)
      &* setStrRef @"pEngineName" engineName
      &* set       @"engineVersion" (_VK_MAKE_VERSION 1 0 0)
      &* set       @"apiVersion" (_VK_MAKE_VERSION 1 0 68)
    iCreateInfo = createVk @VkInstanceCreateInfo
      $  set           @"sType" VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
      &* set           @"pNext" VK_NULL
      &* setVkRef      @"pApplicationInfo" appInfo
      &* set           @"enabledLayerCount" (fromIntegral $ length layers)
      &* setStrListRef @"ppEnabledLayerNames" layers
      &* set           @"enabledExtensionCount" (fromIntegral $ length extensions)
      &* setListRef    @"ppEnabledExtensionNames" extensions

initWindow :: Int -> Int -> String -> IO (Maybe GLFW.Window)
initWindow width height name = do
  _ <- GLFW.init
  GLFW.windowHint $ WindowHint'ClientAPI ClientAPI'NoAPI
  GLFW.windowHint $ WindowHint'Resizable False
  mw <- GLFW.createWindow width height name Nothing Nothing
  return mw
 
main :: IO ()
main = do
  mw <- initWindow 800 600 "Vulkan"
  glfwReqExts <- GLFW.getRequiredInstanceExtensions
  myInstance <- initVulkan "My program" "No Engine" glfwReqExts ["VK_LAYER_LUNARG_standard_validation"]
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
    True -> GLFW.destroyWindow window >> GLFW.terminate >> putStrLn "ending loop"
    False -> mainLoop window

    

