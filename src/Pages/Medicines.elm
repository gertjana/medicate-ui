module Pages.Medicines exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicateApi exposing (getMedicines)
import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import Http
import Models.Medicines exposing (Medicines, Medicine)
import Page exposing (Page)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import View exposing (View)


type alias Model =
    { medicineData : Api.Data Medicines
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
    = MedicineApiResponded (Result Http.Error Medicines)
    | EditMedicine Medicine 
    | DeleteMedicine Medicine
    | AddMedicine
    | AddStock Medicine


init : ( Model, Cmd Msg )
init =
    ( { medicineData = Api.Loading }
    , getMedicines { onResponse = MedicineApiResponded }
    )


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

        EditMedicine medicine ->
            Debug.log ("EditMedicine: " ++ Debug.toString medicine)
            ( model, Cmd.none )

        DeleteMedicine medicine ->
            Debug.log ("DeleteMedicine: " ++ Debug.toString medicine)
            ( model, Cmd.none ) 

        AddMedicine ->
            Debug.log ("AddMedicine: ")
            ( model, Cmd.none )

        AddStock medicine ->
            Debug.log ("AddStock: " ++ Debug.toString medicine)
            ( model, Cmd.none )


medicineContent : Model -> Html Msg
medicineContent model =
    case model.medicineData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success medicineList ->
            Models.Medicines.viewMedicineList medicineList EditMedicine DeleteMedicine AddMedicine AddStock

        Api.Failure _ ->
            div [] [ text "Something went wrong: " ]


contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
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
