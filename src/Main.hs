{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Control.Monad (forM_)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Text.Lazy as DL
import Data.ByteString.Internal (ByteString)
import Network.Wreq
import qualified Network.HTTP.Client as NH --(createCookieJar)
import Text.Taggy.Lens
import qualified Network.Wreq.Session as S
import Data.Time.Clock (getCurrentTime,addUTCTime)
import qualified Data.Text.IO as DTI
import qualified Data.Text as DT
import Control.Monad.IO.Class(liftIO)

main :: IO ()
main = do
            getSimples
            -- getList
            -- login
            -- loginGetDefaultPage
            -- getSecretWithSession
            -- getAllListH3


getSimples :: IO()
getSimples = do 
            response <- get  "http://localhost:8080/exemplo1.php"
            print (response )
        
getList :: IO()
getList = do
           let
                filterLi = html . allNamed (only "li" ) . contents
           response <- get  "http://localhost:8080/exemplo1.php"
           lis <- return $  htmlFullDoc response ^.. filterLi
           forM_ lis $ print -- ETA Reduce da função abaixo (linha comentada abaixo) 
           -- forM_ lis $ \li -> print li


login :: IO()
login = do 
         let
            userNPass = [ "email" := ("root"::Text), "password" := ("root"::Text) ]
         S.withSession $ \sess -> do  
             r <- S.post sess "http://localhost:8080/loginForm.php" userNPass
             r' <- S.get sess "http://localhost:8080/loginForm.php"  
             print (r  ^. responseBody)
             putStrLn "---"
             print (r' ^. responseBody)


loginGetDefaultPage :: IO()
loginGetDefaultPage = do 
         let
            userNPass = [ "email" := ("root"::Text), "password" := ("root"::Text) ]
         S.withSession $ \sess -> do  
             r   <- S.get sess "http://localhost:8080/loginForm.php"  
             r'  <- S.post sess "http://localhost:8080/loginForm.php" userNPass
             r'' <- S.get sess "http://localhost:8080/loginForm.php"  
             print ( r   ^. responseBody )
             putStrLn "---"
             print ( r'  ^. responseBody )
             putStrLn "---"
             print ( r'' ^. responseBody )


getSecretWithSession :: IO() 
getSecretWithSession = do 
             let
                filterSecr = html . allNamed (only "h3") . attr "data-sec" . _Just
             r <- get "http://localhost:8080/somenteLogado.php"
             s <- getSession 
             r' <- S.get s "http://localhost:8080/somenteLogado.php"
             secret <-  return $ (htmlFullDoc r' ^. filterSecr )
             -- print r
             -- print (r  ^. responseBody) -- redirecionado
             -- putStrLn "---"
             print (r' ^. responseBody) -- página correta

-- Helpers 

htmlFullDoc response = response ^. responseBody  . to decodeUtf8 

getSession :: IO S.Session
getSession = do 
         let
            userNPass = [ "email" := ("root"::Text), "password" := ("root"::Text) ]
         S.withSession $ \sess -> do  
             S.post sess "http://localhost:8080/loginForm.php" userNPass
             return sess
