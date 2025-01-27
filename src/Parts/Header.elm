module Parts.Header exposing (..)

import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)


headerView : Html msg
headerView =
    div [ class "row header" ]
        [ div [ class "col-md-12" ]
            [ h1 [] [ text "Medicate!" ]
            , p []
                [ text "is an application to maintain your stock of medicine, take doses, add stock and get reminded when you're about to run out. "
                ]
            ]
        ]
