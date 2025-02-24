module Models.DailySchedule exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Models.Medicines exposing (Medicine, medicineDecoder)


type alias MedicineDosage =
    ( Medicine, Float )


type alias MedicineDosages =
    List MedicineDosage


type alias DailyScheduleEntry =
    { time : String
    , medicines : MedicineDosages
    , taken : Bool
    }


type alias DailySchedule =
    List DailyScheduleEntry


type alias DailyScheduleWithDateEntry =
    { date : String
    , schedule : DailySchedule
    }


type alias DailyScheduleWithDate =
    List DailyScheduleWithDateEntry


medicineDosageDecoder : Decoder MedicineDosage
medicineDosageDecoder =
    Decode.map2 Tuple.pair
        (Decode.index 0 medicineDecoder)
        (Decode.index 1 Decode.float)


medicineDosagesDecoder : Decoder MedicineDosages
medicineDosagesDecoder =
    Decode.list medicineDosageDecoder


dailyScheduleEntryDecoder : Decoder DailyScheduleEntry
dailyScheduleEntryDecoder =
    Decode.succeed DailyScheduleEntry
        |> required "time" Decode.string
        |> required "medicines" medicineDosagesDecoder
        |> optional "taken" Decode.bool False


dailyScheduleDecoder : Decoder DailySchedule
dailyScheduleDecoder =
    Decode.list dailyScheduleEntryDecoder


dailyScheduleWithDateEntryDecoder : Decoder DailyScheduleWithDateEntry
dailyScheduleWithDateEntryDecoder =
    Decode.succeed DailyScheduleWithDateEntry
        |> required "date" Decode.string
        |> required "schedules" dailyScheduleDecoder


dailyScheduleWithDateDecoder : Decoder DailyScheduleWithDate
dailyScheduleWithDateDecoder =
    Decode.list dailyScheduleWithDateEntryDecoder



-- Views
