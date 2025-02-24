module Views.Schedules exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models.Schedules exposing (Schedule, Schedules)

viewSchedule : Schedule -> Html msg
viewSchedule schedule =
    tr []
        [ td [] [ text schedule.time ]
        , td [] [ text schedule.description ]
        , td [] [ text (String.fromFloat schedule.amount) ]
        ]


viewSchedules : Schedules -> Html msg
viewSchedules schedules =
    if List.isEmpty schedules then
        div [ class "alert alert-info col-md-3" ] [ text "No schedules found" ]

    else
        table [ class "table table-striped table-condensed table-hover table-bordered" ]
            [ thead [ class "thead-dark" ]
                [ tr []
                    [ th [ class "col-md-1" ] [ text "Time" ]
                    , th [ class "col-md-3" ] [ text "Medicines" ]
                    , th [ class "col-md-1" ] [ text "Amount" ]
                    ]
                ]
            , tbody [] (List.map (\l -> viewSchedule l) schedules)
            ]
