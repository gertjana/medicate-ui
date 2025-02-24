module Pages.Schedules exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicateApi exposing (getSchedules, getPastSchedule, takeDoseForDate)
import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import Http
import Models.Schedules exposing (Schedules)
import Models.DailySchedule exposing (DailyScheduleWithDate)
import Page exposing (Page)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import View exposing (View)
import Views.DailySchedules exposing (viewDailyScheduleWithDateWrapper)
import Views.Schedules exposing (viewSchedules)

page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


type alias Model =
    { scheduleData : Api.Data Schedules
    , pastScheduleData : Api.Data DailyScheduleWithDate
    }


init : ( Model, Cmd Msg )
init =
    ( { scheduleData = Api.Loading
      , pastScheduleData = Api.Loading
      }
    , Cmd.batch
        [ getSchedules { onResponse = ScheduleApiResponded }
        , getPastSchedule { onResponse = WeeklyScheduleApiResponded }
        ]
    )


type Msg
    = ScheduleApiResponded (Result Http.Error Schedules)
    | WeeklyScheduleApiResponded (Result Http.Error DailyScheduleWithDate)
    | TakeDoseForDate (String, String)

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

        WeeklyScheduleApiResponded (Ok weeklySchedule) ->
            ( { model | pastScheduleData = Api.Success weeklySchedule }
            , Cmd.none
            )

        WeeklyScheduleApiResponded (Err httpError) ->
            ( { model | pastScheduleData = Api.Failure httpError }
            , Cmd.none
            )

        TakeDoseForDate ( date, time ) ->
            ( model, Cmd.batch [ takeDoseForDate { onResponse = WeeklyScheduleApiResponded, date = date, time = time } ] )


scheduleContent : Model -> Html Msg
scheduleContent model =
    case model.scheduleData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success scheduleList ->
            viewSchedules scheduleList

        Api.Failure _ ->
            div [ class "alert alert-danger" ] [ text "Something went wrong: " ]

pastScheduleContent : Model -> Html Msg
pastScheduleContent model =
    case model.pastScheduleData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success weeklySchedule ->
            viewDailyScheduleWithDateWrapper TakeDoseForDate weeklySchedule

        Api.Failure httpError_ ->
            div [ class "alert alert-danger" ] [ text ("Something went wrong: " ++ Debug.toString httpError_) ]




contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
        , div [class "col-md-12"]
            [ h3 [] [ text "Past Schedules" ]
            , pastScheduleContent model
            ]
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
