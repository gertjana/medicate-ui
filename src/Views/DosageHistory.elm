module Views.DosageHistory exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models.Dosagehistory exposing (DosageHistory, DosageHistories)

viewDosageHistory : DosageHistory -> Html msg
viewDosageHistory dosageHistory =
    tr []
        [ td [] [ text dosageHistory.date ]
        , td [] [ text dosageHistory.time ]
        , td [] [ text dosageHistory.description ]
        , td [] [ text (String.fromFloat dosageHistory.amount) ]
        ]


viewDosageHistories : DosageHistories -> Html msg
viewDosageHistories dosageHistories =
    if List.isEmpty dosageHistories then
        div [ class "alert alert-info col-md-3" ] [ text "No dosage history found" ]

    else
        table [ class "table table-striped table-condensed table-hover table-bordered" ]
            [ thead [ class "thead-dark" ] [ tr [] [ td [] [ text "Date" ], td [] [ text "Time" ], td [] [ text "Medicine" ], td [] [ text "Amount" ] ] ]
            , tbody [] (List.map viewDosageHistory dosageHistories)
            ]
