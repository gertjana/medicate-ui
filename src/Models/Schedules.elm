module Models.Schedules exposing (Schedule, Schedules, CreateSchedule, scheduleListDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Schedule =
    { id : String
    , time : String
    , medicineId : String
    , description : String
    , amount : Float
    }

type alias CreateSchedule =
    { time : String
    , medicineId : String
    , description : String
    , amount : Float
    }

scheduleDecoder : Decoder Schedule
scheduleDecoder =
    Decode.succeed Schedule
        |> required "id" Decode.string
        |> required "time" Decode.string
        |> required "medicineId" Decode.string
        |> required "description" Decode.string
        |> required "amount" Decode.float


type alias Schedules =
    List Schedule


scheduleListDecoder : Decoder Schedules
scheduleListDecoder =
    Decode.list scheduleDecoder

