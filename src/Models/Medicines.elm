module Models.Medicines exposing (Medicine, Medicines, MedicinesWithDaysLeft, MedicineWithDaysLeft, toString, 
    medicineDecoder, medicineListDecoder, medicinesWithDaysLeftDecoder, viewMedicineList, viewMedicineListRead)

import FeatherIcons
import Html exposing (Html, a, div, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, placeholder, title, type_)
import Html.Events exposing (onClick)
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
    (Medicine, Int)

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


editIcon : msg -> Html msg
editIcon msg =
    FeatherIcons.edit
        |> FeatherIcons.withSize 16
        |> FeatherIcons.toHtml [ onClick msg ]


deleteIcon : msg -> Html msg
deleteIcon msg =
    FeatherIcons.trash
        |> FeatherIcons.withSize 16
        |> FeatherIcons.toHtml [ onClick msg ]


addStockIcon : msg -> Html msg
addStockIcon msg =
    FeatherIcons.plus
        |> FeatherIcons.withSize 16
        |> FeatherIcons.toHtml [ onClick msg ]


viewActionButtons : Medicine -> (Medicine -> msg) -> (Medicine -> msg) -> (Medicine -> msg) -> Html msg
viewActionButtons medicine onEdit onDelete onAddStock =
    div []
        [ a [ class "", title "Edit" ] [ editIcon (onEdit medicine) ]
        , a [ class "", title "Delete" ] [ deleteIcon (onDelete medicine) ]
        , a [ class "", title "Add Stock" ] [ addStockIcon (onAddStock medicine) ]
        ]


viewMedicine : Medicine -> (Medicine -> msg) -> (Medicine -> msg) -> (Medicine -> msg) -> Html msg
viewMedicine medicine onEdit onDelete onAddStock =
    tr []
        [ td [] [ text medicine.name ]
        , td [] [ text (String.fromFloat medicine.dose) ]
        , td [] [ text medicine.unit ]
        , td [] [ text (String.fromFloat medicine.stock) ]
        , td [] [ viewActionButtons medicine onEdit onDelete onAddStock ]
        ]


viewMedicineRead : MedicineWithDaysLeft -> Html msg
viewMedicineRead (medicine, daysLeft) =
    tr []
        [ td [] [ text medicine.name ]
        , td [] [ text (String.fromFloat medicine.dose) ]
        , td [] [ text medicine.unit ]
        , td [] [ text (String.fromFloat medicine.stock) ]
        , td [] [ text (String.fromInt daysLeft) ]
        ]


viewMedicineFormRow : msg -> Html msg
viewMedicineFormRow onAdd =
    tr []
        [ td [] [ input [ class "form-control", type_ "text", placeholder "Name" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Dose" ] [] ]
        , td [] [ input [ class "form-control", type_ "text", placeholder "Unit" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Stock" ] [] ]
        , td [] [ a [ class "btn btn-primary", title "Add", onClick onAdd ] [ text "Add" ] ]
        ]


viewMedicineListRead : MedicinesWithDaysLeft -> Html msg
viewMedicineListRead getMedicinesWithDaysLeft =
    if List.isEmpty getMedicinesWithDaysLeft then
        div [ class "alert alert-info col-md-3" ] [ text "No medicines found" ]

    else
        table [ class "medicines table table-striped table-condensed table-hover table-bordered" ]
            [ thead [ class "thead-dark" ]
                [ tr []
                    [ th [ class "col-md-4" ] [ text "Name" ]
                    , th [ class "col-md-1" ] [ text "Dose" ]
                    , th [ class "col-md-1" ] [ text "Unit" ]
                    , th [ class "col-md-1" ] [ text "Stock" ]
                    , th [ class "col-md-1" ] [ text "Days Left" ]
                    ]
                ]
            , tbody [] (List.map (\l -> viewMedicineRead l) getMedicinesWithDaysLeft)
            ]


viewMedicineList : Medicines -> (Medicine -> msg) -> (Medicine -> msg) -> msg -> (Medicine -> msg) -> Html msg
viewMedicineList medicines onEdit onDelete onAdd onAddStock =
    if List.isEmpty medicines then
        div [ class "alert alert-info col-md-3" ] [ text "No medicines found" ]

    else
        table [ class "medicines-edit table table-striped table-condensed table-hover" ]
            [ thead [ class "thead-dark" ]
                [ tr []
                    [ th [ class "col-md-4" ] [ text "Name" ]
                    , th [ class "col-md-1" ] [ text "Dose" ]
                    , th [ class "col-md-1" ] [ text "Unit" ]
                    , th [ class "col-md-1" ] [ text "Stock" ]
                    , th [ class "col-xs-1" ] [ text "" ]
                    ]
                ]
            , tbody []
                (List.append (List.map (\medicine -> viewMedicine medicine onEdit onDelete onAddStock) medicines) [ viewMedicineFormRow onAdd ])
            ]
