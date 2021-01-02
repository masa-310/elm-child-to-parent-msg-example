module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Child
import Html exposing (..)


type alias Model =
    { count : Int
    , childModel : Child.Model
    }


type Msg
    = CountUp
    | GotChildMsg Child.Msg


init : ( Model, Cmd Msg )
init =
    let
        ( childModel, childCmd ) =
            Child.init
    in
    ( { count = 0
      , childModel = childModel
      }
    , Cmd.map GotChildMsg childCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CountUp ->
            ( { model | count = model.count + 1 }, Cmd.none )

        GotChildMsg childMsg ->
            case childMsg of
                Child.ParentCountUp ->
                    update CountUp model

                _ ->
                    let
                        ( model_, cmd_ ) =
                            Child.update childMsg model.childModel
                    in
                    ( { model | childModel = model_ }, Cmd.map GotChildMsg cmd_ )


view : Model -> Html Msg
view model =
    div []
        [ span [] [ text "grandparent: " ]
        , span [] [ text <| String.fromInt model.count ]
        , Html.map GotChildMsg <| Child.view model.childModel
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
