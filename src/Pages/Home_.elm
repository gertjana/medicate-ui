module Pages.Home_ exposing (Model, Msg, page)

import Api exposing (Data(..))
import Api.MedicineList exposing (..)
import Api.ScheduleList exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Page exposing (Page)
import View exposing (View)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import Models.Medicines exposing (Medicines)
import Models.Schedules exposing (Schedules)
import Models.CombinedSchedules exposing (CombinedSchedules)
import Api.CombinedList

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
  , combinedData : Api.Data CombinedSchedules
  }

init : ( Model, Cmd Msg )
init =
  ( { medicineData = Api.Loading
    , scheduleData = Api.Loading
    , combinedData = Api.Loading 
    }
  , Cmd.batch 
    [ 
    Api.MedicineList.getMedicines { onResponse = MedicineApiResponded}
    , Api.ScheduleList.getSchedules { onResponse = ScheduleApiResponded}
    , Api.CombinedList.getCombinedSchedules { onResponse = CombinedApiResponded}
    ]
  )



type Msg
  = MedicineApiResponded (Result Http.Error Medicines)
  | ScheduleApiResponded (Result Http.Error Schedules)
  | CombinedApiResponded (Result Http.Error CombinedSchedules)
  | AddMedicine
  | TakeDose


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    MedicineApiResponded (Ok listOfMedicines) ->
      ( { model | medicineData = Api.Success listOfMedicines }
      , Cmd.none
      )
    ScheduleApiResponded (Ok listOfSchedules) ->
      ( { model | scheduleData = Api.Success listOfSchedules }
      , Cmd.none
      )
    CombinedApiResponded (Ok listOfCombinedSchedules) ->
      ( { model | combinedData = Api.Success listOfCombinedSchedules }
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
    CombinedApiResponded (Err httpError) ->
      ( { model | combinedData = Api.Failure httpError }
      , Cmd.none
      )
    AddMedicine ->
      ( model, Cmd.none )
    TakeDose ->
      ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

medicine_content: Model -> Html Msg
medicine_content model =
  case model.medicineData of
    Api.Loading ->
      div [] [ text "Loading..." ]
    Api.Success medicineList ->
      Models.Medicines.viewMedicineList medicineList
    Api.Failure _ ->
      div [] [ text ("Something went wrong: ")] -- ++ Debug.toString httpError) ]

schedule_content: Model -> Html Msg
schedule_content model =
  case model.scheduleData of
    Api.Loading ->
      div [] [ text "Loading..." ]
    Api.Success scheduleList ->
      Models.Schedules.viewSchedules scheduleList 
    Api.Failure httpError ->
      div [] [ text ("Something went wrong: " ++ Debug.toString httpError) ]

combined_content: Model -> Html Msg
combined_content model =
  case model.combinedData of
    Api.Loading ->
      div [] [ text "Loading..." ]
    Api.Success combinedScheduleList ->
      Models.CombinedSchedules.viewCombinedSchedules combinedScheduleList 
    Api.Failure httpError ->
      div [] [ text ("Something went wrong: " ++ Debug.toString httpError) ]

contentView : Model -> Html Msg
contentView model =
  div [ class "container-fluid" ]
  [ div [class "col-md-12"]
    [ headerView ]
  , div [class "col-md-8 content" ]
    [ h3 [] [ text "Medicines"]
    , medicine_content model ]
  , div [class "col-md-4 content" ]
    [ h3 [] [ text "Daily Schedule"]
   , combined_content model ]
  -- , div [class "col-md-10 content" ]
  --   [ h3 [] [ text "Schedules"]
  --  , schedule_content model ]
  , div [ class "col-md-12 footer" ]
    [ footerView ]
  ]

view : Model -> View Msg
view model =
  { title = "Medicate"
  , body = [ contentView model ]
  }

  
 