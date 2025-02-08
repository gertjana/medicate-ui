module Environment exposing (..)

 -- Values in this File will be overwritten by CI/CD pipeline for the environment it is deployed to

config : { apiUrl : String }
config =
    { apiUrl = "http://localhost:8080" }
