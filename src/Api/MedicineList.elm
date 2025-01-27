module Api.MedicineList exposing (getMedicines)

import Http
import Models.Medicines exposing (Medicines, medicineListDecoder)

getMedicines :
    { onResponse : Result Http.Error (Medicines) -> msg} -> Cmd msg
getMedicines options =
    Http.get
        { url = "http://localhost:8080/medicines"
        , expect = Http.expectJson options.onResponse medicineListDecoder
        }