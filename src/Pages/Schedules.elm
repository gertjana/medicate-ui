module Pages.Schedules exposing (page)

import Html exposing (Html)
import View exposing (View)


page : View msg
page =
    { title = "Pages.Schedules"
    , body = [ Html.text "/schedules" ]
    }
