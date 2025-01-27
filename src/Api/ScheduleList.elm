module Api.ScheduleList exposing (..)

import Http
import Models.Schedules exposing (Schedules, scheduleListDecoder)




getSchedules :
    { onResponse : Result Http.Error (Schedules) -> msg} -> Cmd msg
getSchedules options =
    Http.get
        { url = "http://localhost:8080/schedules"
        , expect = Http.expectJson options.onResponse scheduleListDecoder
        }
