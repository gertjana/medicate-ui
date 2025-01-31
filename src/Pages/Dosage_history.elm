module Pages.Dosage_history exposing (Model, Msg, page)

import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import View exposing (View)
import Page exposing (Page)
import Api exposing (Data(..))
import Http
import Models.Dosagehistory exposing (DosageHistories, viewDosageHistories)
import Parts.Header exposing (headerView)
import Parts.Footer exposing (footerView)
import Api.MedicateApi exposing (getDosageHistory)

page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { dosageHistoryData : Api.Data DosageHistories }


init : ( Model, Cmd Msg )
init =
    ( { dosageHistoryData = Api.Loading }
    , getDosageHistory { onResponse = DosageHistoryApiResponded }
    )


type Msg
    = DosageHistoryApiResponded (Result Http.Error DosageHistories)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DosageHistoryApiResponded (Ok dosageHistory) ->
            ( { model | dosageHistoryData = Api.Success dosageHistory }
            , Cmd.none
            )

        DosageHistoryApiResponded (Err httpError) ->
            ( { model | dosageHistoryData = Api.Failure httpError }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


dosageHistoryContent : Model -> Html Msg
dosageHistoryContent model =
    case model.dosageHistoryData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success dosageHistoryList ->
            viewDosageHistories dosageHistoryList

        Api.Failure httpError ->
            div [] [ text ("Something went wrong: " ++ Debug.toString httpError) ]


contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
        , div [ class "col-md-4 content" ]
            [ h3 [] [ text "Dosage History" ]
            , dosageHistoryContent model
            ]
        , div [ class "col-md-12 footer" ]
            [ footerView ]
        ]

view : Model -> View Msg
view model =
    { title = "Pages.Dosage_history"
    , body = [ contentView model ]
    }
