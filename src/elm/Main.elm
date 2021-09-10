module Main exposing (..)

import Browser
import Components.Categories as Categories
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { categories : Categories.Model }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Categories.init
    , Cmd.none
    )


type Msg
    = NoOp
    | CategoriesMsg Categories.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CategoriesMsg subMsg ->
            Categories.update subMsg model.categories
                |> Tuple.mapFirst (\m -> { model | categories = m })
                |> Tuple.mapSecond (Cmd.map CategoriesMsg)


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Dropdown"
    , body =
        [ Categories.view model.categories
            |> Html.map CategoriesMsg
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
