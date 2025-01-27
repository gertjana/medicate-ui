module Api.MedicateApi exposing (getCombinedSchedules, getMedicines, getSchedules)

import Http
import Models.CombinedSchedules exposing (CombinedSchedules, combinedSchedulesDecoder)
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


getCombinedSchedules : { onResponse : Result Http.Error CombinedSchedules -> msg } -> Cmd msg
getCombinedSchedules options =
    Http.get
        { url = "http://localhost:8080/schedules/combined"
        , expect = Http.expectJson options.onResponse combinedSchedulesDecoder
        }
