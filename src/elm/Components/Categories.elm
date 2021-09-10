module Components.Categories exposing (..)

import Components.MultiSelect as MultiSelect
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (range)


type alias Model =
    { overalMultiSelect : MultiSelect.Model
    , overallOptions : List String
    }


type Msg
    = MultiSelectMsg MultiSelect.Msg
    | OverallOnChange (List String)


multiSelectHandlers : MultiSelect.Handlers Msg
multiSelectHandlers =
    { tagger = MultiSelectMsg
    , onChange = OverallOnChange
    }


init : Model
init =
    { overallOptions = []
    , overalMultiSelect =
        range 1 10
            |> List.map (\i -> "Option " ++ String.fromInt i)
            |> MultiSelect.init
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MultiSelectMsg multiSelectMsg ->
            MultiSelect.update multiSelectHandlers multiSelectMsg model.overalMultiSelect
                |> Tuple.mapFirst (\m -> { model | overalMultiSelect = m })

        OverallOnChange list ->
            ( { model | overallOptions = list }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div [ class "categories" ]
        [ div [ class "categories__inner" ]
            [ overall model
            , div [ class "categories__breakdown" ]
                [ div []
                    [ h3 [] [ text "Breakdown" ]
                    , p [] [ text "Select the options from dropdown menu." ]
                    ]
                , category1
                , category2N3
                ]
            ]
        ]


overall : Model -> Html Msg
overall model =
    div [ class "categories__overall" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Overall" ]
                , renderIf
                    (List.length model.overallOptions > 0)
                    (div []
                        [ model.overallOptions
                            |> String.join ", "
                            |> String.append "Selected: "
                            |> (\s -> p [] [ text s ])
                        ]
                    )
                ]
            , div []
                [ model.overalMultiSelect
                    |> MultiSelect.view multiSelectHandlers
                ]
            ]
        ]


category1 : Html Msg
category1 =
    div [ class "categories__cat1" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Category 1" ]
                ]
            , div []
                [ text "dropdown"
                ]
            ]
        ]


category2N3 : Html Msg
category2N3 =
    div [ class "categories__cat2N3-wrapper" ]
        [ category2
        , category3
        ]


category2 : Html Msg
category2 =
    div [ class "categories__cat2" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Category 2" ]
                ]
            , div []
                [ text "dropdown"
                ]
            ]
        ]


category3 : Html Msg
category3 =
    div [ class "categories__cat3" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Category 3" ]
                ]
            , div []
                [ text "dropdown"
                ]
            ]
        ]


renderIf : Bool -> Html msg -> Html msg
renderIf bool html =
    if bool then
        html

    else
        text ""
