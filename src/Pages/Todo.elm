module Pages.Todo exposing (page)

import Html exposing (Html, div, h3, li, text, ul)
import Html.Attributes exposing (class)
import Parts.Footer exposing (footerView)
import Parts.Header exposing (headerView)
import View exposing (View)


page : View msg
page =
    { title = "Pages.Todo"
    , body = [ contentView ]
    }


todo : List ( String, String )
todo =
    [ ( "done", "add a todo page" )
    , ( "done", "BE: refactor CombinedSchedules -> DailySchedule" )
    , ( "done", "FE: Take dose button" )
    , ( "done", "BE: Api to take dose from daily schedule" )
    , ( "done", "BE/FE: Implement History of taken doses" )
    , ( "done", "BE/FE: Remove amount and daysLeft from medicine" )
    , ( "wontdo", "FE: See what layouts are and how to implement them" )
    , ( "done", "BE: BUG Dosagehistory is added correctly" )
    , ( "done", "FE: Create pages for editing medicine, editing schedules and dosage histories" )
    , ( "doing", "BE: have to dose taken reduce the medicine stock" )
    , ( "", "BE: make the dosage history page a timeline" )
    , ( "", "BE: Calculate days left from daily schedule" )
    , ( "", "BE: Inject medicine where it says medicineId" )
    , ( "", "BE/FE: CRUD for medicines" )
    , ( "", "BE/FE: CRUD for schedules" )
    , ( "", "BE/FE: Add Stock button" )
    , ( "", "FE: Add a page for the about page" )
    ]


contentView : Html msg
contentView =
    div [ class "container-fluid" ]
        [ div [ class "col-md-12" ] [ headerView ]
        , div [ class "col-md-6" ]
            [ h3 [] [ text "ToDo" ]
            , ul [ class "todo" ]
                (List.map
                    (\( status, task ) ->
                        li [ class status ] [ text task ]
                    )
                    todo
                )
            ]
        , div [ class "col-md-12" ]
            [ footerView
            ]
        ]
