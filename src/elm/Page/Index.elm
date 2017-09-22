module Page.Index exposing (Model, Msg, init, update, view, subscriptions)

import Html exposing (Html, text, div, button, span, h1)
import Html.Events exposing (onClick)
import Task
import Firebase.Authentication as Auth
import Firebase.Authentication.User as User
import Firebase.Authentication.Types exposing (User, Auth)


type alias Model =
    { auth : Auth
    , user : Maybe User
    }


type Msg
    = Noop ()
    | Login
    | Logout


init : Auth -> Maybe User -> ( Model, Cmd Msg )
init auth maybeUser =
    ( Model auth maybeUser, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noop =
            ( model, Cmd.none )
    in
        case msg of
            Noop _ ->
                noop

            Login ->
                noop

            Logout ->
                ( model
                , Auth.signOut model.auth |> Task.perform Noop
                )


view : Model -> Html Msg
view model =
    let
        userInfo =
            case model.user of
                Nothing ->
                    span [] [ text "Hi there. Why not ", button [ onClick Login ] [ text "login" ], text "?" ]

                Just user ->
                    span [] [ text ("Hi, " ++ User.displayName user ++ "."), button [ onClick Logout ] [ text "Logout" ] ]
    in
        div []
            [ h1 [] [ text "Index" ]
            , userInfo
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
