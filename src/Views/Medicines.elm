module Views.Medicines exposing (viewMedicineList, addStockForm)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models.Medicines exposing (MedicineWithDaysLeft, MedicinesWithDaysLeft, medicineDescription)
import Form exposing (Form)
viewMedicine : MedicineWithDaysLeft -> Html msg 
viewMedicine ( medicine, daysLeft ) =
    tr []
        [ td [] [ text medicine.name ]
        , td [] [ text (String.fromFloat medicine.dose) ]
        , td [] [ text medicine.unit ]
        , td [] [ text (String.fromFloat medicine.stock) ]
        , td [] [ text (String.fromInt daysLeft) ]
        ]



viewMedicineList : MedicinesWithDaysLeft -> Html msg
viewMedicineList medicines =
    if List.isEmpty medicines then
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
            , tbody [] (List.map (\l -> viewMedicine l) medicines)
            ]

addStockForm : MedicinesWithDaysLeft -> Html Form.Msg
addStockForm medicines =
    div [ class "form-group add-stock-form" ]
        [ div [ class "row" ] [ 
            div [ class "col-md-6" ]
                [ label [ for "medicine" ] [ text "Medicine" ]
                , select [ id "medicine", class "form-control" ]
                    (List.map (\(m,_) -> option [ value m.id ] [ text (medicineDescription m) ]) medicines)
                ]
            , div [class "col-md-2"] 
                [ label [ for "stock" ] [ text "Stock" ]
                , input [ type_ "number", id "stock", class "form-control" ] []
                ]
            , div [ class "col-md-2" ]
                [ button [class "btn btn-primary" , onClick Form.Submit ] [text "Add Stock"]
                ]
            ]
        ]

