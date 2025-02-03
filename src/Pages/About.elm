module Pages.About exposing (page)

import Html exposing (Html, h1, text, div)
import View exposing (View)


page : View msg
page =
    { title = "Pages.About"
    , body = [ contentView ]
    }

contentView : Html msg
contentView =
    div [] [ h1 [] [ text "About" ] ]
