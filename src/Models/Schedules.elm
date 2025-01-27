module Models.Schedules exposing (Schedules, viewSchedules, scheduleListDecoder)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder)

type alias Schedule = 
    { id : String
    , time : String
    , medicineId : String
    , amount : Float
    }
scheduleDecoder: Decoder Schedule
scheduleDecoder = 
    Decode.map4 Schedule
        (Decode.field "id" Decode.string)
        (Decode.field "time" Decode.string)
        (Decode.field "medicineId" Decode.string)
        (Decode.field "amount" Decode.float)

type alias Schedules = List Schedule
scheduleListDecoder: Decoder Schedules
scheduleListDecoder = Decode.list scheduleDecoder


viewSchedules : Schedules -> Html msg
viewSchedules schedules = table [ class "table table-striped table-condensed table-hover" ]
                    [ tr []
                        [ th [class "col-md-1"] [ text "Id" ]
                        , th [class "col-md-1"] [ text "Time" ]
                        , th [class "col-md-1"] [ text "Medicines" ]
                        , th [class "col-md-1"] [ text "Amount" ]
                        ]
                        , tbody [] (List.map (\l -> viewSchedule l) schedules)
                    ]

viewSchedule : Schedule -> Html msg
viewSchedule schedule  = tr []
                    [ td [] [ text schedule.id ]
                    , td [] [ text schedule.time ]
                    , td [] [ text schedule.medicineId  ]
                    , td [] [ text (String.fromFloat schedule.amount)]
                    ]
