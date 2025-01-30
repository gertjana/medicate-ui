module Pages.Dosage_history exposing (page)

import Html exposing (Html)
import View exposing (View)


page : View msg
page =
    { title = "Pages.Dosage_history"
    , body = [ Html.text "/dosage_history" ]
    }
