module Parts.Footer exposing (footerView)

import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (class, href)


footerView : Html msg
footerView =
    div [ class "footer" ]
        [ p [ class "center-block" ]
            [ text "copyright 2025 - "
            , a [ href "https://gertjanassies.dev" ] [ text "gertjanassies.dev" ]
            , text " | "
            , a [ href "https://github.com/gertjana/medicate-ui" ] [ text "github" ]
            ]
        ]