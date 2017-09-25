module Page.Index exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (Html, text, div, span, h1, a)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Task
import Firebase.Errors
import Firebase.Authentication as Auth
import Firebase.Authentication.User as User
import Firebase.Authentication.Types exposing (User, Auth)
import Util
import Route


type alias Model =
    {}


type Msg
    = Noop ()


init : Auth -> Maybe User -> ( Model, Cmd Msg )
init auth maybeUser =
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noop =
            ( model, Cmd.none )
    in
        case msg of
            Noop _ ->
                noop


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Index" ]
        , span [] [ text "Hi there. Why not ", a [ Route.href Route.Login ] [ text "login" ], text "?" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
