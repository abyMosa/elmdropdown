module Components.Categories exposing (..)

import Components.MultiSelect as MultiSelect
import Html exposing (Html, button, div, h3, p, span, text)
import Html.Attributes exposing (class, id)


type alias Model =
    { overalMultiSelect : MultiSelect.Model
    , overallSelectedOptions : List String
    , cat1MultiSelect : MultiSelect.Model
    , cat1SelectedOptions : List String
    , cat2MultiSelect : MultiSelect.Model
    , cat2SelectedOptions : List String
    , cat3MultiSelect : MultiSelect.Model
    , cat3SelectedOptions : List String
    }


type Msg
    = OveralMultiSelectMsg MultiSelect.Msg
    | OverallOnChange (List String)
    | Cat1MultiSelectMsg MultiSelect.Msg
    | Cat1OnChange (List String)
    | Cat2MultiSelectMsg MultiSelect.Msg
    | Cat2OnChange (List String)
    | Cat3MultiSelectMsg MultiSelect.Msg
    | Cat3OnChange (List String)


overallHandlers : MultiSelect.Handlers Msg
overallHandlers =
    { tagger = OveralMultiSelectMsg
    , onChange = OverallOnChange
    }


cat1Handlers : MultiSelect.Handlers Msg
cat1Handlers =
    { tagger = Cat1MultiSelectMsg
    , onChange = Cat1OnChange
    }


cat2Handlers : MultiSelect.Handlers Msg
cat2Handlers =
    { tagger = Cat2MultiSelectMsg
    , onChange = Cat2OnChange
    }


cat3Handlers : MultiSelect.Handlers Msg
cat3Handlers =
    { tagger = Cat3MultiSelectMsg
    , onChange = Cat3OnChange
    }


init : Model
init =
    { overalMultiSelect =
        List.range 1 10
            |> List.map (\i -> "Option " ++ String.fromInt i)
            |> MultiSelect.init "overall"
    , cat1MultiSelect =
        List.range 1 10
            |> List.map (\i -> "Option " ++ String.fromInt i)
            |> MultiSelect.init "cat1"
    , cat2MultiSelect =
        List.range 1 10
            |> List.map (\i -> "Option " ++ String.fromInt i)
            |> MultiSelect.init "cat2"
    , cat3MultiSelect =
        List.range 1 10
            |> List.map (\i -> "Option " ++ String.fromInt i)
            |> MultiSelect.init "cat3"
    , overallSelectedOptions = []
    , cat1SelectedOptions = []
    , cat2SelectedOptions = []
    , cat3SelectedOptions = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OveralMultiSelectMsg multiSelectMsg ->
            MultiSelect.update overallHandlers multiSelectMsg model.overalMultiSelect
                |> Tuple.mapFirst (\m -> { model | overalMultiSelect = m })

        Cat1MultiSelectMsg submsg ->
            MultiSelect.update cat1Handlers submsg model.cat1MultiSelect
                |> Tuple.mapFirst (\m -> { model | cat1MultiSelect = m })

        Cat2MultiSelectMsg cat2Msg ->
            MultiSelect.update cat2Handlers cat2Msg model.cat2MultiSelect
                |> Tuple.mapFirst (\m -> { model | cat2MultiSelect = m })

        Cat3MultiSelectMsg cat3Msg ->
            MultiSelect.update cat3Handlers cat3Msg model.cat3MultiSelect
                |> Tuple.mapFirst (\m -> { model | cat3MultiSelect = m })

        OverallOnChange list ->
            ( { model | overallSelectedOptions = list }
            , Cmd.none
            )

        Cat1OnChange list ->
            ( { model | cat1SelectedOptions = list }
            , Cmd.none
            )

        Cat2OnChange list ->
            ( { model | cat2SelectedOptions = list }
            , Cmd.none
            )

        Cat3OnChange list ->
            ( { model | cat3SelectedOptions = list }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ MultiSelect.subscriptions model.overalMultiSelect
            |> Sub.map OveralMultiSelectMsg
        , MultiSelect.subscriptions model.cat1MultiSelect
            |> Sub.map Cat1MultiSelectMsg
        , MultiSelect.subscriptions model.cat2MultiSelect
            |> Sub.map Cat2MultiSelectMsg
        , MultiSelect.subscriptions model.cat3MultiSelect
            |> Sub.map Cat3MultiSelectMsg
        ]



-- view


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
                , category1 model
                , category2N3 model
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
                    (List.length model.overallSelectedOptions > 0)
                    (div []
                        [ model.overallSelectedOptions
                            |> String.join ", "
                            |> String.append "Selected: "
                            |> (\s -> p [] [ text s ])
                        ]
                    )
                ]
            , div []
                [ model.overalMultiSelect
                    |> MultiSelect.view overallHandlers
                ]
            ]
        ]


category1 : Model -> Html Msg
category1 model =
    div [ class "categories__cat1" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Category 1" ]
                , renderIf
                    (List.length model.cat1SelectedOptions > 0)
                    (div []
                        [ model.cat1SelectedOptions
                            |> String.join ", "
                            |> String.append "Selected: "
                            |> (\s -> p [] [ text s ])
                        ]
                    )
                ]
            , div []
                [ model.cat1MultiSelect
                    |> MultiSelect.view cat1Handlers
                ]
            ]
        ]


category2N3 : Model -> Html Msg
category2N3 model =
    div [ class "categories__cat2N3-wrapper" ]
        [ category2 model
        , category3 model
        ]


category2 : Model -> Html Msg
category2 model =
    div [ class "categories__cat2" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Category 2" ]
                , renderIf
                    (List.length model.cat2SelectedOptions > 0)
                    (div []
                        [ model.cat2SelectedOptions
                            |> String.join ", "
                            |> String.append "Selected: "
                            |> (\s -> p [] [ text s ])
                        ]
                    )
                ]
            , div []
                [ model.cat2MultiSelect
                    |> MultiSelect.view cat2Handlers
                ]
            ]
        ]


category3 : Model -> Html Msg
category3 model =
    div [ class "categories__cat3" ]
        [ div [ class "categories__section-head" ]
            [ div []
                [ h3 [] [ text "Category 3" ]
                , renderIf
                    (List.length model.cat3SelectedOptions > 0)
                    (div []
                        [ model.cat3SelectedOptions
                            |> String.join ", "
                            |> String.append "Selected: "
                            |> (\s -> p [] [ text s ])
                        ]
                    )
                ]
            , div []
                [ model.cat3MultiSelect
                    |> MultiSelect.view cat3Handlers
                ]
            ]
        ]



-- helper


renderIf : Bool -> Html msg -> Html msg
renderIf bool html =
    if bool then
        html

    else
        text ""
