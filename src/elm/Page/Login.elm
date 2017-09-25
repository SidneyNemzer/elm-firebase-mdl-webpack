module Page.Login exposing (Model, Msg(..), init, update, view, subscriptions)

import Html exposing (Html, div, input, label, text, button, h1, header, a)
import Html.Attributes as Attr
import Html.Events exposing (onInput, onClick)
import Task
import Firebase.Errors
import Firebase.Authentication as Auth
import Firebase.Authentication.User as User
import Firebase.Authentication.Types exposing (User, Auth)
import Route
import Util


type alias Model =
    { auth : Auth
    , loading : Bool
    , email : String
    , password : String
    , error : String
    }


type Msg
    = SetEmail String
    | SetPassword String
    | Submit
    | LoginFinish (Result Firebase.Errors.Error User)


init : Auth -> ( Model, Cmd Msg )
init auth =
    ( { auth = auth
      , loading = False
      , email = ""
      , password = ""
      , error = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    let
        noop =
            ( model, Cmd.none )
    in
        case msg of
            SetEmail email ->
                ( { model | email = email }, Cmd.none, Nothing )

            SetPassword password ->
                ( { model | password = password }, Cmd.none, Nothing )

            Submit ->
                ( { model | loading = True }
                , Auth.signInWithEmailAndPassword
                    model.email
                    model.password
                    model.auth
                    |> Task.attempt LoginFinish
                , Nothing
                )

            LoginFinish (Err error) ->
                ( { model
                    | error = toString error
                    , loading = False
                  }
                , Cmd.none
                , Nothing
                )

            LoginFinish (Ok user) ->
                ( { model | loading = False }
                , Route.goTo "#/"
                , Just user
                )


viewInput : String -> (String -> Msg) -> String -> Bool -> Html Msg
viewInput type_ msg value disabled =
    input [ Attr.type_ type_, onInput msg, Attr.value value, Attr.disabled disabled ] []


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Login" ]
        , div [] [ text model.error ]
        , div []
            [ label [] [ text "Email" ]
            , viewInput "text" SetEmail model.email model.loading
            ]
        , div []
            [ label [] [ text "Password" ]
            , viewInput "password" SetPassword model.password model.loading
            ]
        , button
            [ onClick Submit
            , Attr.disabled model.loading
            ]
            [ text
                (if model.loading then
                    "Logging in..."
                 else
                    "Login"
                )
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
