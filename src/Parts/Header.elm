module Parts.Header exposing (..)

import Html exposing (Html, div, h1, p, text, nav, a, ul, li)
import Html.Attributes exposing (class, href)


headerView : Html msg
headerView =
    div [ class "row header" ]
        [ div [ class "col-md-12" ]
            [ nav [ class "navbar navbar-expand-lg navbar-light bg-light" ] 
                [ a [ class "navbar-brand", href "#" ] [ text "Medicate!" ] 
                , a [ class "nav-link", href "/" ] [ text "Home" ] 
                , a [ class "nav-link", href "medicines" ] [ text "Medicines" ] 
                , a [ class "nav-link", href "schedules" ] [ text "Schedules" ] 
                , a [ class "nav-link", href "dosage-history" ] [ text "Dosage History" ] 
                , a [ class "nav-link", href "about" ] [ text "About" ] 
                , a [ class "nav-link", href "todo" ] [ text "Todo" ] 
                ]
            , p []
                [ text "is an application to maintain your stock of medicine, take doses, add stock and get reminded when you're about to run out. "
                ]
            ]
        ]
        
