module Views.DailySchedules exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models.DailySchedule exposing (DailySchedule, DailyScheduleEntry, DailyScheduleWithDate, DailyScheduleWithDateEntry, MedicineDosages)
import Models.Dosagehistory exposing (..)
import Models.Medicines exposing (Medicine)


viewActionButtons : (String -> msg) -> String -> Bool -> Html msg
viewActionButtons onTakeDose time taken =
    if not taken then
        div []
            [ button [ class "btn btn-xs btn-primary", onClick (onTakeDose time) ] [ text "take dose" ]
            ]

    else
        div []
            [ button [ class "btn btn-xs btn-light" ] [ text "dose taken" ]
            ]


viewActionButtonsForDate : (( String, String ) -> msg) -> String -> String -> Bool -> Html msg
viewActionButtonsForDate onTakeDoseForDate date time taken =
    if not taken then
        div []
            [ button [ class "btn btn-xs btn-primary", onClick (onTakeDoseForDate ( date, time )) ] [ text "take dose" ]
            ]

    else
        div []
            [ button [ class "btn btn-xs btn-light" ] [ text "dose taken" ]
            ]


viewMedicineDosage : ( Medicine, Float ) -> Html msg
viewMedicineDosage ( medicine, amount ) =
    li []
        [ text (String.fromFloat amount)
        , text " "
        , text medicine.name
        , text " ("
        , text (String.fromFloat medicine.dose)
        , text " "
        , text medicine.unit
        , text ") "
        , text (String.fromFloat medicine.stock)
        , text " in stock"
        ]


viewMedicineDosages : MedicineDosages -> Html msg
viewMedicineDosages medicineDosages =
    ul [] (List.map (\cm -> viewMedicineDosage cm) medicineDosages)


viewDailyScheduleEntry : (String -> msg) -> DailyScheduleEntry -> Html msg
viewDailyScheduleEntry onTakeDose dialyScheduleEntry =
    tr []
        [ td [] [ text dialyScheduleEntry.time, viewActionButtons onTakeDose dialyScheduleEntry.time dialyScheduleEntry.taken ]
        , td [] [ viewMedicineDosages dialyScheduleEntry.medicines ]
        ]


viewDailySchedule : (String -> msg) -> DailySchedule -> Html msg
viewDailySchedule onTakeDoseForDate dailySchedule =
    if List.isEmpty dailySchedule then
        div [ class "alert alert-info col-md-4" ] [ text "No daily schedule found" ]

    else
        table [ class "dailyschedule table table-striped table-condensed table-hover table-bordered" ]
            [ thead [ class "thead-dark" ]
                [ tr []
                    [ th [ class "col-md-1" ] [ text "Time" ]
                    , th [ class "col-md-3 " ] [ text "Medicines" ]
                    ]
                ]
            , tbody [] (List.map (\l -> viewDailyScheduleEntry onTakeDoseForDate l) dailySchedule)
            ]


viewDailyScheduleWithDateEntry : String -> (( String, String ) -> msg) -> DailyScheduleEntry -> Html msg
viewDailyScheduleWithDateEntry date onTakeDoseForDate dailyScheduleWithDateEntry =
    tr []
        [ td [] [ text dailyScheduleWithDateEntry.time, viewActionButtonsForDate onTakeDoseForDate date dailyScheduleWithDateEntry.time dailyScheduleWithDateEntry.taken ]
        , td [] [ viewMedicineDosages dailyScheduleWithDateEntry.medicines ]
        ]


viewDailySchedulesWithDate : (( String, String ) -> msg) -> DailyScheduleWithDateEntry -> Html msg
viewDailySchedulesWithDate onTakeDoseForDate dailyScheduleWithDateEntry =
    div [ class "weekly-schedule col-md-4" ]
        [ if List.isEmpty dailyScheduleWithDateEntry.schedule then
            div [ class "alert alert-info col-md-4" ] [ text "No daily schedule found" ]

          else
            div [ class "col-md-4" ]
                [ div [ class "card-tab" ] [ text dailyScheduleWithDateEntry.date ]
                , table [ class "dailyschedule table table-striped table-condensed table-hover table-bordered" ]
                    [ thead [ class "thead-dark" ]
                        [ tr []
                            [ th [ class "col-xs-1" ] [ text "Time" ]
                            , th [ class "col-xs-3 " ] [ text "Medicines" ]
                            ]
                        ]
                    , tbody [] (List.map (\l -> viewDailyScheduleWithDateEntry dailyScheduleWithDateEntry.date onTakeDoseForDate l) dailyScheduleWithDateEntry.schedule)
                    ]
                ]
        ]


viewDailyScheduleWithDateWrapper : (( String, String ) -> msg) -> DailyScheduleWithDate -> Html msg
viewDailyScheduleWithDateWrapper onTakeDoseForDate dailyScheduleWithDateWrapper =
    if List.isEmpty dailyScheduleWithDateWrapper then
        div [ class "alert alert-info col-md-4" ] [ text "No schedules found" ]

    else
        div [ class "horizontal-scrollable" ]
            [ div [ class "row flex-row" ] (List.map (\d -> viewDailySchedulesWithDate onTakeDoseForDate d) dailyScheduleWithDateWrapper)
            ]
