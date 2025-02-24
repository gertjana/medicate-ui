module Models.Medicines exposing
    ( Medicine
    , MedicineWithDaysLeft
    , Medicines
    , MedicinesWithDaysLeft
    , medicineDecoder
    , medicineListDecoder
    , medicinesWithDaysLeftDecoder
    , toString
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Medicine =
    { id : String
    , name : String
    , dose : Float
    , unit : String
    , stock : Float
    }


medicineDecoder : Decoder Medicine
medicineDecoder =
    Decode.succeed Medicine
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "dose" Decode.float
        |> required "unit" Decode.string
        |> required "stock" Decode.float


type alias Medicines =
    List Medicine


type alias MedicineWithDaysLeft =
    ( Medicine, Int )


type alias MedicinesWithDaysLeft =
    List MedicineWithDaysLeft


medicineListDecoder : Decoder Medicines
medicineListDecoder =
    Decode.list medicineDecoder


medicinesWithDaysLeftDecoder : Decoder MedicinesWithDaysLeft
medicinesWithDaysLeftDecoder =
    Decode.list medicineWithDaysLeftDecoder


medicineWithDaysLeftDecoder : Decoder MedicineWithDaysLeft
medicineWithDaysLeftDecoder =
    Decode.map2 Tuple.pair
        (Decode.index 0 medicineDecoder)
        (Decode.index 1 Decode.int)


toString : Medicine -> String
toString medicine =
    medicine.name ++ " ()" ++ String.fromFloat medicine.dose ++ " " ++ medicine.unit ++ ")"
