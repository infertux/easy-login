module EasyLogin exposing (main)

{-| A small app providing a user-friendly way to sign up and sign in.

@docs main
-}

import Html
import EasyLogin.Model exposing (Model, Settings, Msg)
import EasyLogin.Update exposing (init, update)
import EasyLogin.View exposing (view)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


{-| Main app
-}
main : Program Settings Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
