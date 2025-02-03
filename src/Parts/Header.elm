module Parts.Header exposing (headerView)

import Html exposing (Html, div, p, text, nav, a, img)
import Html.Attributes exposing (class, href, src)


headerView : Html msg
headerView =
    div [ class "row header" ]
        [ div [ class "col-md-12" ]
            [ nav [ class "navbar navbar-expand-lg navbar-light bg-light" ] 
                [ a [ class "navbar-brand", href "/" ] [ text "Medɪkeɪt" ] 
                , a [ class "nav-link", href "/" ] [ text "Home" ] 
                , a [ class "nav-link", href "medicines" ] [ text "Medicines" ] 
                , a [ class "nav-link", href "schedules" ] [ text "Schedules" ] 
                , a [ class "nav-link", href "dosage_history" ] [ text "Dosage History" ] 
                -- , a [ class "nav-link", href "about" ] [ text "About" ] 
                , a [ class "nav-link", href "todo" ] [ text "Todo" ] 
                ]
            ]
        ]
        