module Pages.Medicines exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicateApi exposing (getMedicinesWithDaysLeft)
import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import Http
import Models.Medicines exposing (MedicinesWithDaysLeft)
import Page exposing (Page)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import View exposing (View)
import Views.Medicines exposing (viewMedicineList, addStockForm)

import Form exposing (Form)
import Form.Validate exposing (Validation, succeed, andMap, field, int, string)
type alias AddStockForm =
    {
        medicineId : String
        , stock : Int
    }

type alias Model =
    { medicineData : Api.Data MedicinesWithDaysLeft
    , addStockForm : Form () AddStockForm
    }


page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Msg
    = MedicineApiResponded (Result Http.Error MedicinesWithDaysLeft)
    | FormMsg Form.Msg


init : ( Model, Cmd Msg )
init =
    ( { medicineData = Api.Loading
      , addStockForm = Form.initial [] validate
      }
    , getMedicinesWithDaysLeft { onResponse = MedicineApiResponded }    
    )
validate : Validation () AddStockForm
validate =
    succeed AddStockForm
        |> andMap (field "medicineId" string)
        |> andMap (field "stock" int)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MedicineApiResponded (Ok medicines) ->
            ( { model | medicineData = Api.Success medicines }
            , Cmd.none
            )

        MedicineApiResponded (Err httpError) ->
            ( { model | medicineData = Api.Failure httpError }
            , Cmd.none
            )

        FormMsg formMsg ->
            ( { model | addStockForm = Form.update formMsg model.addStockForm }
            , Cmd.none
            )

medicineContent : Model -> Html Msg
medicineContent model =
    case model.medicineData of
        Api.Loading ->
            div [] [ text "Loading..." ]
        Api.Success medicineList ->
            viewMedicineList medicineList
        Api.Failure _ ->
            div [ class "alert alert-danger" ] [ text "Something went wrong: " ]

stockForm : Model -> Html Msg
stockForm model =
    case model.medicineData of
        Api.Success medicineList ->
            Html.map FormMsg (addStockForm medicineList)
        _ ->
            div [] []

contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
        , div [ class "col-md-4" ]
            [ h3 [] [ text "Add Stock" ]
            , stockForm model
            ]
        , div [ class "col-md-8 content" ]
            [ h3 [] [ text "Medicines" ]
            , medicineContent model
            ]
        , div [ class "col-md-12 footer" ]
            [ footerView ]
        ]


view : Model -> View Msg
view model =
    { title = "Medicines"
    , body = [ contentView model ]
    }
