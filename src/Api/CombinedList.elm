module Api.CombinedList exposing (getCombinedSchedules)

import Http
import Models.CombinedSchedules exposing (CombinedSchedules, combinedSchedulesDecoder)

getCombinedSchedules :
    { onResponse : Result Http.Error (CombinedSchedules) -> msg} -> Cmd msg
getCombinedSchedules options =
    Http.get
        { url = "http://localhost:8080/schedules/combined"
        , expect = Http.expectJson options.onResponse combinedSchedulesDecoder
        }
