module Parts.Footer exposing (footerView)

import Html exposing (Html, a, div, img, p, text)
import Html.Attributes exposing (class, href, src)


footerView : Html msg
footerView =
    div [ class "footer" ]
        [ div [ class "col-md-1 logo" ]
            [ img [ src "images/logo_ga_code_white.svg", class "logo" ] [] ]
        , p [ class "center-block" ]
            [ text "copyright 2025 - "
            , a [ href "https://gertjanassies.dev" ] [ text "gertjanassies.dev" ]
            , text " | "
            , a [ href "https://github.com/gertjana/medicate-ui" ] [ text "github" ]
            ]
        ]
