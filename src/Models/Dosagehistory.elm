module Models.Dosagehistory exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Html exposing (Html, text, tr, td, table, tbody, thead)
import Html.Attributes exposing (class)

type alias DosageHistory =
    { time : String
    , date : String
    , medicine : String
    , amount : Float
    }

dosageHistoryDecoder : Decoder DosageHistory
dosageHistoryDecoder =
    Decode.succeed DosageHistory
        |> required "date" Decode.string
        |> required "time" Decode.string
        |> required "medicineId" Decode.string
        |> required "amount" Decode.float
type alias DosageHistories =
    List DosageHistory

dosageHistoriesDecoder : Decoder DosageHistories
dosageHistoriesDecoder =
    Decode.list dosageHistoryDecoder

viewDosageHistory : DosageHistory -> Html msg
viewDosageHistory dosageHistory =
    tr []
        [ td [] [ text dosageHistory.time ]
        , td [] [ text dosageHistory.date ]
        , td [] [ text dosageHistory.medicine ]
        , td [] [ text (String.fromFloat dosageHistory.amount) ]
        ]

viewDosageHistories : DosageHistories -> Html msg
viewDosageHistories dosageHistories =
    table [class "table table-striped table-condensed table-hover table-bordered"]
        [ thead [class "thead-dark"] [ tr [] [ td [] [ text "Time" ], td [] [ text "Date" ], td [] [ text "Medicine" ], td [] [ text "Amount" ] ] ]
        , tbody [] (List.map viewDosageHistory dosageHistories)
        ]
