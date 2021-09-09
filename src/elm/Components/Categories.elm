module Components.Categories exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    {}


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( Model, Cmd.none )


view : Html Msg
view =
    div [ class "categories" ]
        [ div [ class "categories__inner" ]
            [ overall
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


overall : Html Msg
overall =
    div [ class "categories__overall" ]
        [ text "overall" ]


category1 : Html Msg
category1 =
    div [ class "categories__cat1" ]
        []


category2N3 : Html Msg
category2N3 =
    div [ class "categories__cat2N3-wrapper" ]
        [ div [] [ text "col 1" ]
        , div [] [ text "col 2" ]
        ]
