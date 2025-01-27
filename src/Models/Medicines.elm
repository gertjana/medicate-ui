module Models.Medicines exposing (Medicine, Medicines, dummy, medicineDecoder, medicineListDecoder, toString, viewMedicineList)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder)


type alias Medicine =
    { id : String
    , name : String
    , dose : Float
    , unit : String
    , stock : Float
    , amount : Float
    }


medicineDecoder : Decoder Medicine
medicineDecoder =
    Decode.map6 Medicine
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "dose" Decode.float)
        (Decode.field "unit" Decode.string)
        (Decode.field "stock" Decode.float)
        (Decode.field "amount" Decode.float)


type alias Medicines =
    List Medicine


medicineListDecoder : Decoder Medicines
medicineListDecoder =
    Decode.list medicineDecoder


toString : Medicine -> String
toString medicine =
    medicine.name ++ " ()" ++ String.fromFloat medicine.dose ++ " " ++ medicine.unit ++ ")"


dummy : Medicine
dummy =
    { id = "1"
    , name = "Paracetamol"
    , dose = 500.0
    , unit = "mg"
    , stock = 10.0
    , amount = 10.0
    }


viewActionButtons : Html msg
viewActionButtons =
    div []
        [ a [ class "btn btn-xs btn-primary" ] [ text "edit" ]
        , a [ class "btn btn-xs btn-primary" ] [ text "delete" ]
        ]


viewMedicine : Medicine -> Html msg
viewMedicine medicine =
    tr []
        [ td [] [ text medicine.id ]
        , td [] [ text medicine.name ]
        , td [] [ text (String.fromFloat medicine.dose) ]
        , td [] [ text medicine.unit ]
        , td [] [ text (String.fromFloat medicine.stock) ]
        , td [] [ text (String.fromFloat medicine.amount) ]
        , td [] [ text (String.fromFloat medicine.amount) ]
        , td [] [ viewActionButtons ]
        ]


viewMedicineFormRow : Html msg
viewMedicineFormRow =
    tr []
        [ td [] [ text "" ]
        , td [] [ input [ class "form-control", type_ "text", placeholder "Name" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Dose" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Unit" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Stock" ] [] ]
        , td [] [ input [ class "form-control", type_ "number", placeholder "Amount" ] [] ]
        , td [] [ text "" ] -- days left
        , td [] [ button [ class "btn btn-sm btn-default btn-primary" ] [ text "add" ] ]
        ]


viewMedicineList : Medicines -> Html msg
viewMedicineList medicines =
    table [ class "medicines table table-striped table-condensed table-hover table-bordered" ]
        [ thead [ class "thead-dark" ]
            [ tr []
                [ th [ class "col-md-1" ] [ text "Id" ]
                , th [] [ text "Name" ]
                , th [ class "col-md-1" ] [ text "Dose" ]
                , th [ class "col-md-1" ] [ text "Unit" ]
                , th [ class "col-md-1" ] [ text "Stock" ]
                , th [ class "col-md-1" ] [ text "Amount" ]
                , th [ class "col-md-1" ] [ text "Days Left" ]
                , th [ class "col-md-2" ] [ text "Actions" ]
                ]
            ]
        , tbody [] (List.append (List.map (\l -> viewMedicine l) medicines) [ viewMedicineFormRow ])
        ]
