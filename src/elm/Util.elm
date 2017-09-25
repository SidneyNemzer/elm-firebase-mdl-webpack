module Util exposing (sneakyLog)


sneakyLog : a -> b -> b
sneakyLog value pass =
    Debug.log "Log" value
        |> (\_ -> pass)
