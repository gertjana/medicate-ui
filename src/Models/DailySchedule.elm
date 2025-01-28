module Models.DailySchedule exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Decoder)
import Models.Medicines exposing (Medicine, medicineDecoder)


type alias MedicineDosage =
    ( Medicine, Float )


medicineDosageDecoder : Decoder MedicineDosage
medicineDosageDecoder =
    Decode.map2 Tuple.pair
        (Decode.index 0 medicineDecoder)
        (Decode.index 1 Decode.float)


type alias MedicineDosages =
    List MedicineDosage


medicineDosagesDecoder : Decoder MedicineDosages
medicineDosagesDecoder =
    Decode.list medicineDosageDecoder


type alias DailyScheduleEntry =
    { time : String
    , medicines : MedicineDosages
    }


dailyScheduleEntryDecoder : Decoder DailyScheduleEntry
dailyScheduleEntryDecoder =
    Decode.map2 DailyScheduleEntry
        (Decode.field "time" Decode.string)
        (Decode.field "medicines" medicineDosagesDecoder)


type alias DailySchedule =
    List DailyScheduleEntry


dailyScheduleDecoder : Decoder DailySchedule
dailyScheduleDecoder =
    Decode.list dailyScheduleEntryDecoder


viewActionButtons : Html msg
viewActionButtons =
    div []
        [ a [ class "btn btn-xs btn-primary" ] [ text "take" ]
        ]


viewMedicineDosage : ( Medicine, Float ) -> Html msg
viewMedicineDosage ( medicine, amount ) =
    li []
        [ text (String.fromFloat amount)
        , text " "
        , text medicine.name
        , text " ("
        , text (String.fromFloat medicine.dose)
        , text " "
        , text medicine.unit
        , text ")"
        ]


viewMedicineDosages : MedicineDosages -> Html msg
viewMedicineDosages cms =
    ul [] (List.map (\cm -> viewMedicineDosage cm) cms)


viewDailyScheduleEntry : DailyScheduleEntry -> Html msg
viewDailyScheduleEntry cs =
    tr []
        [ td [] [ text cs.time, viewActionButtons ]
        , td [] [ viewMedicineDosages cs.medicines ]
        ]


viewDailySchedule : DailySchedule -> Html msg
viewDailySchedule css =
    table [ class "dailyschedule table table-striped table-condensed table-hover table-bordered" ]
        [ thead [ class "thead-dark" ]
            [ tr []
                [ th [ class "col-md-1" ] [ text "Time" ]
                , th [ class "col-md-3 " ] [ text "Medicines" ]
                ]
            ]
        , tbody [] (List.map (\l -> viewDailyScheduleEntry l) css)
        ]
