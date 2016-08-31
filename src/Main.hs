{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Control.Monad (forM_)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Text.Lazy as DL
import Data.ByteString.Internal (ByteString)
import Network.Wreq
import Text.Taggy.Lens
import qualified Network.Wreq.Session as S


main :: IO ()
main = do
            getSimples
            -- getList
            -- login
            -- loginGetDefaultPage
            -- getSecretWithSession


getSimples :: IO()
getSimples = do 
            response <- get  "http://localhost:8080/exemplo1.php"
            print (response ^. responseBody)
        
getList :: IO()
getList = do
           let
                filterLi = html . allNamed (only "li" ) . contents
           response <- get  "http://localhost:8080/exemplo1.php"
           lis <- return $  htmlFullDoc response ^.. filterLi
           forM_ lis $ print -- Eq a  linha comentada abaixo 
           -- forM_ lis $ \li -> print li

login :: IO()
login = do 
         let
            userNPass = [ "email" := ("root"::Text), "password" := ("root"::Text) ]
         S.withSession $ \sess -> do  
             r <- S.post sess "http://localhost:8080/loginForm.php" userNPass
             r' <- S.get sess "http://localhost:8080/loginForm.php"  
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
             print ( r'  ^. responseBody )
             print ( r'' ^. responseBody )

getSecretWithSession :: IO() 
getSecretWithSession = do 
             r <- get "http://localhost:8080/somenteLogado.php"
             s <- getSession 
             r' <- S.get s "http://localhost:8080/somenteLogado.php"
             print (r  ^. responseBody) -- redirecionado
             print (r' ^. responseBody) -- página correta

-- Funções de ajuda
htmlFullDoc response = response ^. responseBody  . to decodeUtf8 

getSession :: IO S.Session
getSession = do 
         let
            userNPass = [ "email" := ("root"::Text), "password" := ("root"::Text) ]
         S.withSession $ \sess -> do  
             S.post sess "http://localhost:8080/loginForm.php" userNPass
             return sess



