module Models.Medicines exposing (Medicine, Medicines, medicineDecoder, medicineListDecoder, toString, viewMedicineList)

import Html exposing (Html, text, tr, th, td, table, thead, tbody, div, input, button, a)
import Html.Attributes exposing (class, type_, placeholder)
import Json.Decode as Decode exposing (Decoder)


type alias Medicine =
    { id : String
    , name : String
    , dose : Float
    , unit : String
    , stock : Float
    }


medicineDecoder : Decoder Medicine
medicineDecoder =
    Decode.map5 Medicine
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "dose" Decode.float)
        (Decode.field "unit" Decode.string)
        (Decode.field "stock" Decode.float)


type alias Medicines =
    List Medicine


medicineListDecoder : Decoder Medicines
medicineListDecoder =
    Decode.list medicineDecoder


toString : Medicine -> String
toString medicine =
    medicine.name ++ " ()" ++ String.fromFloat medicine.dose ++ " " ++ medicine.unit ++ ")"


viewActionButtons : Html msg
viewActionButtons =
    div []
        [ a [ class "btn btn-xs btn-primary" ] [ text "edit" ]
        , a [ class "btn btn-xs btn-primary" ] [ text "delete" ]
        ]


viewMedicine : Medicine -> Bool -> Html msg
viewMedicine medicine editMode =
    tr []
        [ td [] [ text medicine.id ]
        , td [] [ text medicine.name ]
        , td [] [ text (String.fromFloat medicine.dose) ]
        , td [] [ text medicine.unit ]
        , td [] [ text (String.fromFloat medicine.stock) ]
        , if editMode then 
            td [] [ viewActionButtons ]
        else
            text ""
        ]

viewMedicineFormRow : Html msg
viewMedicineFormRow =
    tr []
        [ td [] [ text "" ]
        , td [] [ input [ class "form-control", type_ "text", placeholder "Name" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Dose" ] [] ]
        , td [] [ input [ class "form-control", type_ "text", placeholder "Unit" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Stock" ] [] ]
        , td [] [ button [ class "btn btn-sm btn-default btn-primary" ] [ text "add" ] ]
        ]


viewMedicineList : Medicines -> Bool -> Html msg
viewMedicineList medicines editMode =
    table [ class "medicines table table-striped table-condensed table-hover table-bordered" ]
        [ thead [ class "thead-dark" ]
            [ tr []
                [ th [ class "col-md-1" ] [ text "Id" ]
                , th [] [ text "Name" ]
                , th [ class "col-md-1" ] [ text "Dose" ]
                , th [ class "col-md-1" ] [ text "Unit" ]
                , th [ class "col-md-1" ] [ text "Stock" ]
                , if editMode then 
                    th [ class "col-md-2" ] [ text "Actions" ]
                else
                   text ""
                ]
            ]
        , tbody [] (if editMode then 
            (List.append (List.map (\l -> viewMedicine l editMode) medicines) [ viewMedicineFormRow ]) 
            else 
            (List.map (\l -> viewMedicine l editMode) medicines) )
        ]
