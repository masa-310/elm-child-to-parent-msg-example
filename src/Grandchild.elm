module Grandchild exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Events as Events


type alias Model =
    {}


type Msg
    = ParentCountUp
    | SomeOtherMsg


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ParentCountUp ->
            ( model, Cmd.none )

        SomeOtherMsg ->
            ( model, Cmd.none )


view : model -> Html Msg
view model =
    div [] [ span [] [ text "Count up parent:" ], button [ Events.onClick ParentCountUp ] [ text "+" ] ]
