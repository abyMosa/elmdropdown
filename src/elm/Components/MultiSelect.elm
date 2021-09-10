module Components.MultiSelect exposing (..)

import Browser.Events exposing (onMouseDown)
import Dict exposing (Dict)
import Html exposing (Html, button, div, h3, input, label, p, span, text)
import Html.Attributes exposing (class, classList, id, type_)
import Html.Events exposing (on, onCheck, onClick)
import Json.Decode as Decode
import Task


type alias Model =
    { id : String
    , isOpen : Bool
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


init : String -> List String -> Model
init id options =
    options
        |> List.indexedMap (\idx v -> ( idx, ( v, False ) ))
        |> Dict.fromList
        |> Model id False


update : Handlers msg -> Msg -> Model -> ( Model, Cmd msg )
update h msg model =
    case msg of
        BtnClicked ->
            ( { model | isOpen = not model.isOpen }, Cmd.none )

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
        [ id model.id
        , classList
            [ ( "multiselect", True )
            , ( "multiselect--is-open", model.isOpen )
            ]
        ]
        [ button
            [ class "button is-rounded is-small"
            , classList
                [ ( "is-link", model.isOpen )
                , ( "is-light", not model.isOpen )
                ]
            , onClick (h.tagger BtnClicked)
            ]
            [ span [] [ text "compare" ]
            , span [] [ text "▼" ]
            ]
        , div
            [ class "multiselect__options" ]
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


isOutsideDropdown : String -> Decode.Decoder Bool
isOutsideDropdown dropdownId =
    Decode.oneOf
        [ Decode.field "id" Decode.string
            |> Decode.andThen
                (\id ->
                    if dropdownId == id then
                        Decode.succeed False

                    else
                        Decode.fail "continue"
                )
        , Decode.lazy
            (\_ -> isOutsideDropdown dropdownId |> Decode.field "parentNode")
        , Decode.succeed True
        ]


outsideTarget : String -> Decode.Decoder Msg
outsideTarget dropdownId =
    Decode.field "target" (isOutsideDropdown dropdownId)
        |> Decode.andThen
            (\isOutside ->
                if isOutside then
                    Decode.succeed ClickOutside

                else
                    Decode.fail "inside dropdown"
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isOpen then
        onMouseDown (outsideTarget model.id)

    else
        Sub.none
