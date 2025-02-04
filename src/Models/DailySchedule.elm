module Models.DailySchedule exposing (..)

import Html exposing (Html, button, div, li, table, tbody, td, text, th, thead, tr, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
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
    , taken : Bool
    }


dailyScheduleEntryDecoder : Decoder DailyScheduleEntry
dailyScheduleEntryDecoder =
    Decode.succeed DailyScheduleEntry
        |> required "time" Decode.string
        |> required "medicines" medicineDosagesDecoder
        |> optional "taken" Decode.bool False


type alias DailySchedule =
    List DailyScheduleEntry


dailyScheduleDecoder : Decoder DailySchedule
dailyScheduleDecoder =
    Decode.list dailyScheduleEntryDecoder


viewActionButtons : (String -> msg) -> String -> Bool -> Html msg
viewActionButtons onTakeDose time taken =
    if not taken then
        div []
            [ button [ class "btn btn-xs btn-primary", onClick (onTakeDose time) ] [ text "take dose" ]
            ]

    else
        div []
            [ button [ class "btn btn-xs btn-light" ] [ text "dose taken" ]
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
        , text ") "
        , text (String.fromFloat medicine.stock)
        , text " in stock"
        ]


viewMedicineDosages : MedicineDosages -> Html msg
viewMedicineDosages medicineDosages =
    ul [] (List.map (\cm -> viewMedicineDosage cm) medicineDosages)


viewDailyScheduleEntry : (String -> msg) -> DailyScheduleEntry -> Html msg
viewDailyScheduleEntry onTakeDose dialyScheduleEntry =
    tr []
        [ td [] [ text dialyScheduleEntry.time, viewActionButtons onTakeDose dialyScheduleEntry.time dialyScheduleEntry.taken ]
        , td [] [ viewMedicineDosages dialyScheduleEntry.medicines ]
        ]


viewDailySchedule : (String -> msg) -> DailySchedule -> Html msg
viewDailySchedule onTakeDose dailySchedule =
    if List.isEmpty dailySchedule then
        div [ class "alert alert-info col-md-4" ] [ text "No daily schedule found" ]

    else
        table [ class "dailyschedule table table-striped table-condensed table-hover table-bordered" ]
            [ thead [ class "thead-dark" ]
                [ tr []
                    [ th [ class "col-md-1" ] [ text "Time" ]
                    , th [ class "col-md-3 " ] [ text "Medicines" ]
                    ]
                ]
            , tbody [] (List.map (\l -> viewDailyScheduleEntry onTakeDose l) dailySchedule)
            ]
