module Pages.About exposing (page)

import Html exposing (Html, div, h1, text)
import View exposing (View)


page : View msg
page =
    { title = "Pages.About"
    , body = [ contentView ]
    }


contentView : Html msg
contentView =
    div [] [ h1 [] [ text "About" ] ]
