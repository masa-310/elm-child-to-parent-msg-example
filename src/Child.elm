module Child exposing (Model, Msg(..), init, update, view)

import Grandchild
import Html exposing (..)
import Task


type alias Model =
    { count : Int
    , grandchildModel : Grandchild.Model
    }


type Msg
    = ParentCountUp
    | CountUp
    | GotGrandchildMsg Grandchild.Msg


init : ( Model, Cmd Msg )
init =
    let
        ( grandchildModel, grandchildCmd ) =
            Grandchild.init
    in
    ( { count = 0
      , grandchildModel = grandchildModel
      }
    , Cmd.map GotGrandchildMsg grandchildCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ParentCountUp ->
            ( model, Cmd.none )

        CountUp ->
            ( { model | count = model.count + 1 }, Task.perform (always ParentCountUp) (Task.succeed ()) )

        -- update ParentCountUp model
        GotGrandchildMsg grandchildMsg ->
            case grandchildMsg of
                Grandchild.ParentCountUp ->
                    update CountUp model

                _ ->
                    let
                        ( model_, cmd_ ) =
                            Grandchild.update grandchildMsg model.grandchildModel
                    in
                    ( { model | grandchildModel = model_ }, Cmd.map GotGrandchildMsg cmd_ )


view : Model -> Html Msg
view model =
    div []
        [ span [] [ text "parent: " ]
        , span [] [ text <| String.fromInt model.count ]
        , Html.map GotGrandchildMsg <| Grandchild.view model.grandchildModel
        ]
