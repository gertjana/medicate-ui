module Views.Medicines exposing (viewMedicineList, viewMedicineListRead)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import FeatherIcons

import Models.Medicines exposing (Medicine, Medicines, MedicinesWithDaysLeft, MedicineWithDaysLeft)

-- editIcon : msg -> Html msg
-- editIcon msg =
--     FeatherIcons.edit
--         |> FeatherIcons.withSize 16
--         |> FeatherIcons.toHtml [ onClick msg ]


-- deleteIcon : msg -> Html msg
-- deleteIcon msg =
--     FeatherIcons.trash
--         |> FeatherIcons.withSize 16
--         |> FeatherIcons.toHtml [ onClick msg ]


addStockIcon : msg -> Html msg
addStockIcon msg =
    FeatherIcons.plus
        |> FeatherIcons.withSize 16
        |> FeatherIcons.toHtml [ onClick msg ]


viewActionButtons : Medicine -> (Medicine -> msg) -> (Medicine -> msg) -> (Medicine -> msg) -> Html msg
viewActionButtons medicine _ _ onAddStock =
    div []
        [ input [ class "form-control col-md-1", type_ "number", placeholder "Stock" ] []
        -- [ a [ class "", title "Edit" ] [ editIcon (onEdit medicine) ]
        -- , a [ class "", title "Delete" ] [ deleteIcon (onDelete medicine) ]
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
viewMedicineList medicines onEdit onDelete _ onAddStock =
    if List.isEmpty medicines then
        div [ class "alert alert-info col-md-3" ] [ text "No medicines found" ]

    else
        table [ class "medicines-edit table table-striped table-condensed table-hover" ]
            [ thead [ class "thead-dark" ]
                [ tr []
                    [ th [ class "col-md-2" ] [ text "Name" ]
                    , th [ class "col-md-1" ] [ text "Dose" ]
                    , th [ class "col-md-1" ] [ text "Unit" ]
                    , th [ class "col-md-1" ] [ text "Stock" ]
                    , th [ class "col-md-4" ] [ text "Add Stock" ]
                    ]
                ]
            , tbody []
                (List.map (\medicine -> viewMedicine medicine onEdit onDelete onAddStock) medicines)
                -- (List.append (List.map (\medicine -> viewMedicine medicine onEdit onDelete onAddStock) medicines) [ viewMedicineFormRow onAdd ])
            ]
