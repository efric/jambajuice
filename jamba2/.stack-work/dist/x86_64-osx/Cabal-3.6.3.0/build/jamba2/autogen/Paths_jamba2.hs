{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_jamba2 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/ericfeng/tlc_proj/jamba2/.stack-work/install/x86_64-osx/853daac1faa9a9095bb26f76290bfdd2f58b9b922c3be5790f45b06ebdc2d5e2/9.2.7/bin"
libdir     = "/Users/ericfeng/tlc_proj/jamba2/.stack-work/install/x86_64-osx/853daac1faa9a9095bb26f76290bfdd2f58b9b922c3be5790f45b06ebdc2d5e2/9.2.7/lib/x86_64-osx-ghc-9.2.7/jamba2-0.1.0.0-Ef5RIjoHiUhAdysmsAu4pI-jamba2"
dynlibdir  = "/Users/ericfeng/tlc_proj/jamba2/.stack-work/install/x86_64-osx/853daac1faa9a9095bb26f76290bfdd2f58b9b922c3be5790f45b06ebdc2d5e2/9.2.7/lib/x86_64-osx-ghc-9.2.7"
datadir    = "/Users/ericfeng/tlc_proj/jamba2/.stack-work/install/x86_64-osx/853daac1faa9a9095bb26f76290bfdd2f58b9b922c3be5790f45b06ebdc2d5e2/9.2.7/share/x86_64-osx-ghc-9.2.7/jamba2-0.1.0.0"
libexecdir = "/Users/ericfeng/tlc_proj/jamba2/.stack-work/install/x86_64-osx/853daac1faa9a9095bb26f76290bfdd2f58b9b922c3be5790f45b06ebdc2d5e2/9.2.7/libexec/x86_64-osx-ghc-9.2.7/jamba2-0.1.0.0"
sysconfdir = "/Users/ericfeng/tlc_proj/jamba2/.stack-work/install/x86_64-osx/853daac1faa9a9095bb26f76290bfdd2f58b9b922c3be5790f45b06ebdc2d5e2/9.2.7/etc"

getBinDir     = catchIO (getEnv "jamba2_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "jamba2_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "jamba2_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "jamba2_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "jamba2_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "jamba2_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
