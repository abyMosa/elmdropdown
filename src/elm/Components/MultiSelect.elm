module Components.MultiSelect exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onCheck, onClick)
import Json.Decode as Decode
import Task


type alias Model =
    { isOpen : Bool
    , options : Dict Int ( String, Bool )
    }


type Msg
    = OnCheck Int Bool
    | BtnClicked
    | ClickOutside


type alias Handlers msg =
    { tagger : Msg -> msg
    , onChange : List String -> msg
    }


init : List String -> Model
init options =
    options
        |> List.indexedMap (\idx v -> ( idx, ( v, False ) ))
        |> Dict.fromList
        |> Model False


update : Handlers msg -> Msg -> Model -> ( Model, Cmd msg )
update h msg model =
    case msg of
        BtnClicked ->
            ( { model | isOpen = True }, Cmd.none )

        ClickOutside ->
            ( { model | isOpen = False }, Cmd.none )

        OnCheck idx bool ->
            model.options
                |> Dict.map
                    (\index ( v, isSelected ) ->
                        if index == idx then
                            ( v, bool )

                        else
                            ( v, isSelected )
                    )
                |> (\options ->
                        ( { model | options = options }
                        , options
                            |> Dict.values
                            |> List.filter (Tuple.second >> (==) True)
                            |> List.map Tuple.first
                            |> h.onChange
                            |> emit
                        )
                   )


view : Handlers msg -> Model -> Html msg
view h model =
    div
        [ class "multiselect"
        , classList
            -- [ ( "multiselect--has-value", List.length model.selected > 0 )
            [ ( "multiselect--has-value", False )
            , ( "multiselect--is-open", model.isOpen )
            ]
        ]
        [ button [ onClick (h.tagger BtnClicked) ]
            [ text "compare" ]
        , node "on-click-outside"
            [ class "multiselect__options"
            , id "dropdown"
            , on "clickoutside" (Decode.succeed (ClickOutside |> h.tagger))
            ]
            [ div [ class "multiselect__options--inner" ]
                (model.options
                    |> Dict.map (renderOption h)
                    |> Dict.values
                )
            ]
        ]


renderOption : Handlers msg -> Int -> ( String, Bool ) -> Html msg
renderOption h idx option =
    div [ class "multiselect__option" ]
        [ label [ class "checkbox" ]
            [ input
                [ type_ "checkbox"
                , onCheck (OnCheck idx >> h.tagger)
                ]
                []
            , text (Tuple.first option)
            ]
        ]


emit : msg -> Cmd msg
emit msg =
    Task.attempt (always msg) (Task.succeed ())
