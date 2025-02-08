module Pages.Schedules exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicateApi exposing (getSchedules)
import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import Http
import Models.Schedules exposing (Schedules, viewSchedules)
import Page exposing (Page)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import View exposing (View)


page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { scheduleData : Api.Data Schedules }


init : ( Model, Cmd Msg )
init =
    ( { scheduleData = Api.Loading }
    , getSchedules { onResponse = ScheduleApiResponded }
    )


type Msg
    = ScheduleApiResponded (Result Http.Error Schedules)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScheduleApiResponded (Ok schedules) ->
            ( { model | scheduleData = Api.Success schedules }
            , Cmd.none
            )

        ScheduleApiResponded (Err httpError) ->
            ( { model | scheduleData = Api.Failure httpError }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


scheduleContent : Model -> Html Msg
scheduleContent model =
    case model.scheduleData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success scheduleList ->
            viewSchedules scheduleList

        Api.Failure _ ->
            div [ class "alert alert-danger" ] [ text "Something went wrong: " ]


contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
        , div [ class "col-md-4 content" ]
            [ h3 [] [ text "Schedules" ]
            , scheduleContent model
            ]
        , div [ class "col-md-12 footer" ]
            [ footerView ]
        ]


view : Model -> View Msg
view model =
    { title = "Pages.Schedules"
    , body = [ contentView model ]
    }
