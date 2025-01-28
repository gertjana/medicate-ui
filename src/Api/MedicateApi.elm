module Api.MedicateApi exposing (getDailySchedule, getMedicines, getSchedules)

import Http
import Models.DailySchedule exposing (DailySchedule, dailyScheduleDecoder)
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
        { url = "http://localhost:8080/schedules/combined"
        , expect = Http.expectJson options.onResponse dailyScheduleDecoder
        }
