module Api.MedicateApi exposing (getDailySchedule, getDosageHistory, getMedicines, getMedicinesWithDaysLeft, getSchedules, takeDose, takeDoseForDate, getPastSchedule)

import Http
import Models.DailySchedule exposing (DailySchedule, dailyScheduleDecoder, DailyScheduleWithDate, dailyScheduleWithDateDecoder)
import Models.Dosagehistory exposing (DosageHistories, dosageHistoriesDecoder)
import Models.Medicines exposing (Medicine, Medicines, medicineListDecoder, medicinesWithDaysLeftDecoder)
import Models.Schedules exposing (Schedules, scheduleListDecoder)
import Models.Medicines exposing (MedicinesWithDaysLeft)

backendUrl : String
backendUrl = "http://localhost:8080"

getMedicines : { onResponse : Result Http.Error Medicines -> msg } -> Cmd msg
getMedicines options =
    Http.get
        { url = backendUrl ++ "/medicines"
        , expect = Http.expectJson options.onResponse medicineListDecoder
        }


getMedicinesWithDaysLeft : { onResponse : Result Http.Error MedicinesWithDaysLeft -> msg } -> Cmd msg
getMedicinesWithDaysLeft options =
    Http.get
        { url = "http://localhost:8080/schedules/daysleft"
        , expect = Http.expectJson options.onResponse medicinesWithDaysLeftDecoder
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

takeDoseForDate : { onResponse : Result Http.Error DailyScheduleWithDate -> msg, time: String, date: String } -> Cmd msg
takeDoseForDate options =
    Http.post
        { url = backendUrl ++ "/schedules/takedose?date=" ++ options.date ++ "&time=" ++ options.time
        , body = Http.emptyBody
        , expect = Http.expectJson options.onResponse dailyScheduleWithDateDecoder
        }

getPastSchedule : { onResponse : Result Http.Error DailyScheduleWithDate -> msg } -> Cmd msg
getPastSchedule options =
    Http.get
        { url = backendUrl ++ "/schedules/past"
        , expect = Http.expectJson options.onResponse dailyScheduleWithDateDecoder
        }
