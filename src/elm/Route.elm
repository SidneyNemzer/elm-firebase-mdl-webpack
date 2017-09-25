module Route exposing (Route(..), goTo, fromLocation, href, layoutLink)

import Html exposing (Html)
import Html.Attributes
import Navigation exposing (Location)
import Material.Layout as Layout
import UrlParser as Url exposing (Parser)


type Route
    = NotFound
    | Index
    | Login
    | Logout


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                NotFound ->
                    [ "404" ]

                Index ->
                    []

                Login ->
                    [ "login" ]

                Logout ->
                    [ "logout" ]
    in
        "#/" ++ String.join "/" pieces


href : Route -> Html.Attribute msg
href route =
    Html.Attributes.href (routeToString route)


layoutLink : Route -> String -> Html msg
layoutLink route text =
    Layout.link [ Layout.href (routeToString route) ] [ Html.text text ]


goTo : String -> Cmd msg
goTo =
    Navigation.newUrl


router : Parser (Route -> a) a
router =
    Url.oneOf
        [ Url.map Login (Url.s "login")
        , Url.map Logout (Url.s "logout")
        ]


fromLocation : Location -> Route
fromLocation location =
    if String.isEmpty location.hash || location.hash == "#/" then
        Index
    else
        Url.parseHash router location
            |> Maybe.withDefault NotFound
