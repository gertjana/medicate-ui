module Models.Dosagehistory exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias DosageHistory =
    { id : String
    , date : String
    , time : String
    , medicine : String
    , description : String
    , amount : Float
    }


dosageHistoryDecoder : Decoder DosageHistory
dosageHistoryDecoder =
    Decode.succeed DosageHistory
        |> required "id" Decode.string
        |> required "date" Decode.string
        |> required "time" Decode.string
        |> required "medicineId" Decode.string
        |> required "description" Decode.string
        |> required "amount" Decode.float


type alias DosageHistories =
    List DosageHistory


dosageHistoriesDecoder : Decoder DosageHistories
dosageHistoriesDecoder =
    Decode.list dosageHistoryDecoder
