module Api.MedicateApi exposing (getDailySchedule, getDosageHistory, getMedicines, getSchedules, takeDose)

import Http
import Models.DailySchedule exposing (DailySchedule, dailyScheduleDecoder)
import Models.Dosagehistory exposing (DosageHistories, dosageHistoriesDecoder)
import Models.Medicines exposing (Medicines, medicineListDecoder)
import Models.Schedules exposing (Schedules, scheduleListDecoder)

backendUrl : String
-- backendUrl = "https://medicate-backend-1-0.onrender.com"
backendUrl = "http://localhost:8080"

getMedicines : { onResponse : Result Http.Error Medicines -> msg } -> Cmd msg
getMedicines options =
    Http.get
        { url = backendUrl ++ "/medicines"
        , expect = Http.expectJson options.onResponse medicineListDecoder
        }


getSchedules : { onResponse : Result Http.Error Schedules -> msg } -> Cmd msg
getSchedules options =
    Http.get
        { url = backendUrl ++ "/schedules"
        , expect = Http.expectJson options.onResponse scheduleListDecoder
        }


getDailySchedule : { onResponse : Result Http.Error DailySchedule -> msg } -> Cmd msg
getDailySchedule options =
    Http.get
        { url = backendUrl ++ "/schedules/daily"
        , expect = Http.expectJson options.onResponse dailyScheduleDecoder
        }


getDosageHistory : { onResponse : Result Http.Error DosageHistories -> msg } -> Cmd msg
getDosageHistory options =
    Http.get
        { url = backendUrl ++ "/dosagehistory"
        , expect = Http.expectJson options.onResponse dosageHistoriesDecoder
        }


takeDose : { onResponse : Result Http.Error DailySchedule -> msg, time : String } -> Cmd msg
takeDose options =
    Http.post
        { url = backendUrl ++ "/schedules/takedose?time=" ++ options.time
        , body = Http.emptyBody
        , expect = Http.expectJson options.onResponse dailyScheduleDecoder
        }
