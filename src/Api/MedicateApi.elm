module Api.MedicateApi exposing (getDailySchedule, getDosageHistory, getMedicines, getSchedules, takeDose)

import Http
import Models.DailySchedule exposing (DailySchedule, dailyScheduleDecoder)
import Models.Dosagehistory exposing (DosageHistories, dosageHistoriesDecoder)
import Models.Medicines exposing (Medicines, medicineListDecoder)
import Models.Schedules exposing (Schedules, scheduleListDecoder)


getMedicines : { onResponse : Result Http.Error Medicines -> msg } -> Cmd msg
getMedicines options =
    Http.get
        { url = "http://localhost:8080/medicines"
        , expect = Http.expectJson options.onResponse medicineListDecoder
        }


getSchedules : { onResponse : Result Http.Error Schedules -> msg } -> Cmd msg
getSchedules options =
    Http.get
        { url = "http://localhost:8080/schedules"
        , expect = Http.expectJson options.onResponse scheduleListDecoder
        }


getDailySchedule : { onResponse : Result Http.Error DailySchedule -> msg } -> Cmd msg
getDailySchedule options =
    Http.get
        { url = "http://localhost:8080/schedules/daily"
        , expect = Http.expectJson options.onResponse dailyScheduleDecoder
        }


getDosageHistory : { onResponse : Result Http.Error DosageHistories -> msg } -> Cmd msg
getDosageHistory options =
    Http.get
        { url = "http://localhost:8080/dosagehistory"
        , expect = Http.expectJson options.onResponse dosageHistoriesDecoder
        }


takeDose : { onResponse : Result Http.Error DailySchedule -> msg, time : String } -> Cmd msg
takeDose options =
    Debug.log ("takeDose" ++ options.time)
        Http.post
        { url = "http://localhost:8080/schedules/takedose?time=" ++ options.time
        , body = Http.emptyBody
        , expect = Http.expectJson options.onResponse dailyScheduleDecoder
        }
