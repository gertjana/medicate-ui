module Parts.Footer exposing (footerView)

import Html exposing (Html, div, p, text, a)
import Html.Attributes exposing (class, href)

footerView : Html msg
footerView = div [ class "footer" ]
    [ p [ class "center-block" ]
        [ text "copyright 2025 - "
        , a [ href "https://gertjanassies.dev" ] [ text "gertjanassies.dev" ]
        ]
    ]