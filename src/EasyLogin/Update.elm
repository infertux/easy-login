port module EasyLogin.Update exposing (init, update)

import Http
import EasyLogin.Model exposing (..)
import EasyLogin.Api as Api


{-| Port will send userId if logged in successfully
-}
port onSuccess : String -> Cmd msg


init : Settings -> ( Model, Cmd Msg )
init settings =
    ( { initialModel | settings = settings }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input id value ->
            let
                newField field =
                    { value = value, error = Nothing, visible = field.visible }

                newModel =
                    case id of
                        Email ->
                            { model | email = newField model.email }

                        Password ->
                            { model | password = newField model.password }
            in
                ( newModel, Cmd.none )

        LogIn ->
            ( { model | loading = True }
            , Api.signIn
                model.settings.loginPath
                model.email.value
                model.password.value
            )

        LogInResult (Ok document) ->
            let
                userId =
                    Api.getUserId document

                reload =
                    userId
                        /= Nothing
                        && not (String.isEmpty model.password.value)
            in
                ( { model | userId = userId, loading = reload }
                , if reload then
                    onSuccess <| Maybe.withDefault "" userId
                  else
                    Cmd.none
                )

        LogInResult (Err error) ->
            let
                message =
                    case error of
                        Http.BadStatus response ->
                            if response.status.code == 401 then
                                if String.isEmpty model.password.value then
                                    Nothing
                                else
                                    Just "Wrong password"
                            else
                                Just response.status.message

                        error ->
                            Just (toString error)

                oldPassword =
                    model.password

                password =
                    { oldPassword | error = message, visible = True }
            in
                ( { model | loading = False, password = password }, Cmd.none )

        SendPassword ->
            ( { model | userId = Just "dummy" }
            , Api.sendPassword
                model.settings.lostPasswordPath
                model.email.value
            )
