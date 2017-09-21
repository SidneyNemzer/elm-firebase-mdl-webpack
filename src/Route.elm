module Route exposing (Route(..), fromLocation)

import Navigation exposing (Location)
import UrlParser as Url exposing (Parser)


type Route
    = NotFound
    | Index


router : Parser (Route -> a) a
router =
    Url.oneOf
        []


fromLocation : Location -> Route
fromLocation location =
    if String.isEmpty location.hash then
        Index
    else
        Url.parseHash router location
            |> Maybe.withDefault NotFound
