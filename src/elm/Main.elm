module Main exposing (main)

import Navigation
import Html exposing (Html)
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
    , currentRoute : Route
    }


type PageMsg
    = IndexMsg Index.Msg


type Msg
    = SetRoute Route
    | PageMsg PageMsg


mapCmd : (a -> PageMsg) -> Cmd a -> Cmd Msg
mapCmd pageMsg pageCmd =
    Cmd.map PageMsg (Cmd.map pageMsg pageCmd)


setRoute : Route -> Model -> ( Model, Cmd Msg )
setRoute route model =
    let
        pageModels =
            model.pageModels
    in
        case route of
            Index ->
                let
                    ( indexModel, indexCmd ) =
                        Index.init model.firebase.auth Nothing
                in
                    ( { model
                        | pageModels =
                            { pageModels
                                | index =
                                    Just indexModel
                            }
                        , currentRoute = Index
                      }
                    , mapCmd IndexMsg indexCmd
                    )

            Route.NotFound ->
                ( { model | currentRoute = NotFound }
                , Cmd.none
                )


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
        , currentRoute = Index
        }
            |> setRoute (Route.fromLocation location)


pageUpdate : (pageMsg -> PageMsg) -> (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg )) -> pageMsg -> Maybe pageModel -> ( Maybe pageModel, Cmd Msg )
pageUpdate pageTrigger pageUpdateFunc pageMsg maybePageModel =
    Maybe.map
        (\pageModel ->
            let
                ( newPageModel, newPageCmd ) =
                    pageUpdateFunc pageMsg pageModel
            in
                ( Just newPageModel, mapCmd pageTrigger newPageCmd )
        )
        maybePageModel
        |> Maybe.withDefault ( Nothing, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        pageModels =
            model.pageModels
    in
        case msg of
            SetRoute route ->
                setRoute route model

            PageMsg pageMsg ->
                case pageMsg of
                    IndexMsg indexMsg ->
                        let
                            ( newPageModel, cmd ) =
                                pageUpdate IndexMsg Index.update indexMsg model.pageModels.index
                        in
                            ( { model
                                | pageModels =
                                    { pageModels
                                        | index = newPageModel
                                    }
                              }
                            , cmd
                            )


mapHtml : (a -> PageMsg) -> Html a -> Html Msg
mapHtml pageMsg pageHtml =
    Html.map PageMsg (Html.map pageMsg pageHtml)


viewPage : (pageMsg -> PageMsg) -> (pageModel -> Html pageMsg) -> Maybe pageModel -> Html Msg
viewPage pageMsg pageView maybePageModel =
    Maybe.map
        (\pageModel ->
            mapHtml pageMsg (pageView pageModel)
        )
        maybePageModel
        |> Maybe.withDefault (Html.h1 [] [ Html.text "Page has not been initialized" ])


view : Model -> Html Msg
view model =
    case model.currentRoute of
        Index ->
            viewPage IndexMsg Index.view model.pageModels.index

        Route.NotFound ->
            Html.h1 [] [ Html.text "Not found" ]


mapSub : (a -> PageMsg) -> Sub a -> Sub Msg
mapSub pageMsg pageSub =
    Sub.map PageMsg (Sub.map pageMsg pageSub)


pageSubscriptions : (pageMsg -> PageMsg) -> (pageModel -> Sub pageMsg) -> Maybe pageModel -> Sub Msg
pageSubscriptions pageMsg pageSub maybePageModel =
    Maybe.map
        (\pageModel ->
            mapSub pageMsg (pageSub pageModel)
        )
        maybePageModel
        |> Maybe.withDefault Sub.none


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions IndexMsg Index.subscriptions model.pageModels.index
        ]
