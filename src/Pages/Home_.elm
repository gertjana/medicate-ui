module Pages.Home_ exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicateApi exposing (getDailySchedule, getDosageHistory, getMedicines, getSchedules, takeDose)
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Models.DailySchedule exposing (DailySchedule)
import Models.Dosagehistory exposing (DosageHistories)
import Models.Medicines exposing (Medicine, Medicines)
import Models.Schedules exposing (Schedules)
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
    { medicineData : Api.Data Medicines
    , scheduleData : Api.Data Schedules
    , dailyScheduleData : Api.Data DailySchedule
    , dosageHistoryData : Api.Data DosageHistories
    }


init : ( Model, Cmd Msg )
init =
    ( { medicineData = Api.Loading
      , scheduleData = Api.Loading
      , dailyScheduleData = Api.Loading
      , dosageHistoryData = Api.Loading
      }
    , Cmd.batch
        [ getMedicines { onResponse = MedicineApiResponded }
        , getSchedules { onResponse = ScheduleApiResponded }
        , getDailySchedule { onResponse = DailyScheduleApiResponded }
        , getDosageHistory { onResponse = DosageHistoryApiResponded }
        ]
    )


type Msg
    = MedicineApiResponded (Result Http.Error Medicines)
    | ScheduleApiResponded (Result Http.Error Schedules)
    | DailyScheduleApiResponded (Result Http.Error DailySchedule)
    | AddMedicine Medicine
    | TakeDose String
    | DosageHistoryApiResponded (Result Http.Error DosageHistories)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MedicineApiResponded (Ok medicines) ->
            ( { model | medicineData = Api.Success medicines }
            , Cmd.none
            )

        ScheduleApiResponded (Ok schedules) ->
            ( { model | scheduleData = Api.Success schedules }
            , Cmd.none
            )

        DailyScheduleApiResponded (Ok dailySchedule) ->
            ( { model | dailyScheduleData = Api.Success dailySchedule }
            , Cmd.none
            )

        DosageHistoryApiResponded (Ok dosageHistory) ->
            ( { model | dosageHistoryData = Api.Success dosageHistory }
            , Cmd.none
            )

        MedicineApiResponded (Err httpError) ->
            ( { model | medicineData = Api.Failure httpError }
            , Cmd.none
            )

        ScheduleApiResponded (Err httpError) ->
            ( { model | scheduleData = Api.Failure httpError }
            , Cmd.none
            )

        DailyScheduleApiResponded (Err httpError) ->
            ( { model | dailyScheduleData = Api.Failure httpError }
            , Cmd.none
            )

        DosageHistoryApiResponded (Err httpError) ->
            ( { model | dosageHistoryData = Api.Failure httpError }
            , Cmd.none
            )

        AddMedicine medicine ->
            Debug.log ("AddMedicine" ++ Debug.toString medicine)
                ( model, Cmd.none )

        TakeDose time ->
            Debug.log ("TakeDose" ++ time)
                ( model, Cmd.batch [ takeDose { onResponse = DailyScheduleApiResponded, time = time } ] )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Views


medicineContent : Model -> Html Msg
medicineContent model =
    case model.medicineData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success medicineList ->
            Models.Medicines.viewMedicineList medicineList False

        Api.Failure _ ->
            div [] [ text "Something went wrong: " ]


scheduleContent : Model -> Html Msg
scheduleContent model =
    case model.scheduleData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success scheduleList ->
            Models.Schedules.viewSchedules scheduleList

        Api.Failure httpError ->
            div [] [ text ("Something went wrong: " ++ Debug.toString httpError) ]


dailysheduleContent : Model -> Html Msg
dailysheduleContent model =
    case model.dailyScheduleData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success dailyScheduleList ->
            Models.DailySchedule.viewDailySchedule TakeDose dailyScheduleList

        Api.Failure httpError ->
            div [] [ text ("Something went wrong: " ++ Debug.toString httpError) ]


dosageHistoryContent : Model -> Html Msg
dosageHistoryContent model =
    case model.dosageHistoryData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success dosageHistoryList ->
            Models.Dosagehistory.viewDosageHistories dosageHistoryList

        Api.Failure httpError ->
            div [] [ text ("Something went wrong: " ++ Debug.toString httpError) ]


contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
        , div [ class "col-md-8 content" ]
            [ h3 [] [ text "Medicines" ]
            , medicineContent model
            ]
        , div [ class "col-md-4 content" ]
            [ h3 [] [ text "Daily Schedule" ]
            , dailysheduleContent model
            ]
        , div [ class "col-md-4 content" ]
            [ h3 [] [ text "Dosage History" ]
            , dosageHistoryContent model
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
    { title = "Medicate"
    , body = [ contentView model ]
    }
