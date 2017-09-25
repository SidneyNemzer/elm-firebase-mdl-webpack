module Views.Page exposing (frame)

import Html exposing (Html)
import Firebase.Authentication.User as User
import Firebase.Authentication.Types exposing (User)
import Material
import Material.Layout as Layout
import Route


frame : (Material.Msg msg -> msg) -> Material.Model -> Maybe User -> Html msg -> Html msg
frame mdlMsg mdlModel maybeUser content =
    let
        userGreeting =
            case maybeUser of
                Just user ->
                    [ Html.text ("Hello, " ++ User.displayName user ++ ". ")
                    , Route.layoutLink Route.Logout "Logout"
                    ]

                Nothing ->
                    [ Route.layoutLink Route.Login "Login" ]
    in
        Layout.render mdlMsg
            mdlModel
            [ Layout.fixedHeader ]
            { header =
                [ Layout.row []
                    [ Layout.title [] [ Html.a [ Route.href Route.Index ] [ Html.text "App" ] ]
                    , Layout.spacer
                    , Layout.navigation [] userGreeting
                    ]
                ]
            , drawer = [ Layout.title [] [ Html.text "App" ] ]
            , tabs = ( [], [] )
            , main = [ content ]
            }
