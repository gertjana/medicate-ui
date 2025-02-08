module Pages.Home_ exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicateApi exposing (getDailySchedule, getMedicines, takeDose)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Models.DailySchedule exposing (DailySchedule)
import Models.Medicines exposing (Medicines)
import Page exposing (Page)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import View exposing (View)



-- import Shared.Msg exposing (Msg(..))


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
    , dailyScheduleData : Api.Data DailySchedule
    }


init : ( Model, Cmd Msg )
init =
    ( { medicineData = Api.Loading
      , dailyScheduleData = Api.Loading
      }
    , Cmd.batch
        [ getMedicines { onResponse = MedicineApiResponded }
        , getDailySchedule { onResponse = DailyScheduleApiResponded }
        ]
    )


type Msg
    = MedicineApiResponded (Result Http.Error Medicines)
    | DailyScheduleApiResponded (Result Http.Error DailySchedule)
    | TakeDose String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MedicineApiResponded (Ok medicines) ->
            ( { model | medicineData = Api.Success medicines }
            , Cmd.none
            )

        DailyScheduleApiResponded (Ok dailySchedule) ->
            ( { model | dailyScheduleData = Api.Success dailySchedule }
            , Cmd.none
            )

        MedicineApiResponded (Err httpError) ->
            ( { model | medicineData = Api.Failure httpError }
            , Cmd.none
            )

        DailyScheduleApiResponded (Err httpError) ->
            ( { model | dailyScheduleData = Api.Failure httpError }
            , Cmd.none
            )

        TakeDose time ->
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
            Models.Medicines.viewMedicineListRead medicineList

        Api.Failure _ ->
            div [ class "alert alert-danger" ] [ text "Something went wrong: " ]


dailysheduleContent : Model -> Html Msg
dailysheduleContent model =
    case model.dailyScheduleData of
        Api.Loading ->
            div [] [ text "Loading..." ]

        Api.Success dailyScheduleList ->
            Models.DailySchedule.viewDailySchedule TakeDose dailyScheduleList

        Api.Failure _ ->
            div [ class "alert alert-danger" ] [ text "Something went wrong: " ]


welcomeContent : Html Msg
welcomeContent =
    div [ class "welcome" ]
        [ h3 [] [ text "Welcome" ]
        , article []
            [ p [] [ text "Medikeit (phonetic spelling of Medicate) is an application to maintain your stock of medicines, take doses, add stock and get an idea when you're about to run out. " ]
            , p [] [ text "This application is built with Elm in the front and Scala ZIO (zio-http, zio-redis) in the back." ]
            , p [] [ text "The source code is available on Github: " ]
            , p [] [ a [ href "https://github.com/gertjena/medicate" ] [ text "https://github.com/gertjana/medicate" ] ]
            , p [] [ text "This application is a work in progress and grown out of my own need to keep track of my medicines and learn Elm, Scala 3 and ZIO" ]
            ]
        ]


contentView : Model -> Html Msg
contentView model =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ]
            [ headerView ]
        , div [ class "col-md-4" ]
            [ welcomeContent ]
        , div [ class "col-md-4 content" ]
            [ h3 [] [ text "Daily Schedule" ]
            , dailysheduleContent model
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
    { title = "Medikeit"
    , body = [ contentView model ]
    }
