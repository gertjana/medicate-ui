module Models.Schedules exposing (Schedules, CreateSchedule,scheduleListDecoder, viewSchedules)

import Html exposing (Html, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Schedule =
    { id : String
    , time : String
    , medicineId : String
    , description : String
    , amount : Float
    }

type alias CreateSchedule =
    { time : String
    , medicineId : String
    , description : String
    , amount : Float
    }

scheduleDecoder : Decoder Schedule
scheduleDecoder =
    Decode.succeed Schedule
        |> required "id" Decode.string
        |> required "time" Decode.string
        |> required "medicineId" Decode.string
        |> required "description" Decode.string
        |> required "amount" Decode.float


type alias Schedules =
    List Schedule


scheduleListDecoder : Decoder Schedules
scheduleListDecoder =
    Decode.list scheduleDecoder


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
