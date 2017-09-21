module Main exposing (main)

import Navigation
import Firebase
import Firebase.Authentication as Auth
import Firebase.Authentication.Types exposing (User, Auth)
import Route exposing (Route(..))
import Page.Index as Index


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias FirebaseInstance =
    { app : Firebase.App
    , auth : Auth
    }


type alias PageModels =
    { index : Maybe Index.Model
    }


type alias Model =
    { firebase : FirebaseInstance
    , pageModels : PageModels
    }


type PageMsg
    = IndexMsg Index.Msg


type Msg
    = SetRoute (Maybe Route)
    | PageMsg PageMsg


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        app =
            case Firebase.app () of
                Just app ->
                    app

                Nothing ->
                    Debug.crash "Failed to load firebase application"
    in
        { firebase =
            { app = app
            , auth = Auth.init app
            }
        , pageModels =
            { index = Nothing }
        }

update : Model -> Msg -> (Model, Cmd Msg)
update model msg =
    case msg of
        SetRoute
