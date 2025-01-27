module Models.CombinedSchedules exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Json.Decode as Decode exposing (Decoder)
import Models.Medicines exposing (Medicine, medicineDecoder)


type alias CombinedMedicine =
    ( Medicine, Float )


combinedMedicineDecoder : Decoder CombinedMedicine
combinedMedicineDecoder =
    Decode.map2 Tuple.pair
        (Decode.index 0 medicineDecoder)
        (Decode.index 1 Decode.float)


type alias CombinedMedicines =
    List CombinedMedicine


combinedMedicinesDecoder : Decoder CombinedMedicines
combinedMedicinesDecoder =
    Decode.list combinedMedicineDecoder


type alias CombinedSchedule =
    { time : String
    , medicines : CombinedMedicines
    }


combinedScheduleDecoder : Decoder CombinedSchedule
combinedScheduleDecoder =
    Decode.map2 CombinedSchedule
        (Decode.field "time" Decode.string)
        (Decode.field "medicines" combinedMedicinesDecoder)


type alias CombinedSchedules =
    List CombinedSchedule


combinedSchedulesDecoder : Decoder CombinedSchedules
combinedSchedulesDecoder =
    Decode.list combinedScheduleDecoder


viewCombinedMedicine : ( Medicine, Float ) -> Html msg
viewCombinedMedicine ( medicine, amount ) =
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


viewCombinedMedicines : CombinedMedicines -> Html msg
viewCombinedMedicines cms =
    ul [] (List.map (\cm -> viewCombinedMedicine cm) cms)


viewCombinedSchedule : CombinedSchedule -> Html msg
viewCombinedSchedule cs =
    tr []
        [ td [] [ text cs.time ]
        , td [ class "left" ] [ viewCombinedMedicines cs.medicines ]
        ]


viewCombinedSchedules : CombinedSchedules -> Html msg
viewCombinedSchedules css =
    table [ class "combined table table-striped table-condensed table-hover table-bordered" ]
        [ thead [ class "thead-dark" ]
            [ tr []
                [ th [ class "col-md-1" ] [ text "Time" ]
                , th [ class "col-md-3 " ] [ text "Medicines" ]
                ]
            ]
        , tbody [] (List.map (\l -> viewCombinedSchedule l) css)
        ]
