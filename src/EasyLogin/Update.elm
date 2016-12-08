port module EasyLogin.Update exposing (init, update)

import EasyLogin.Model exposing (..)
import EasyLogin.Decoder as Decoder


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
                fieldVisibility id =
                    case id of
                        Email ->
                            model.email.visible

                        Password ->
                            model.password.visible

                newField id =
                    { value = value, error = Nothing, visible = fieldVisibility id }

                newModel =
                    case id of
                        Email ->
                            { model | email = newField Email }

                        Password ->
                            { model | password = newField Password }
            in
                ( newModel, Cmd.none )

        LogIn ->
            ( { model | loading = True }
            , Decoder.signIn
                model.settings.loginPath
                model.email.value
                model.password.value
            )

        LogInResult (Ok document) ->
            let
                userId =
                    Decoder.decodeSession document

                visible =
                    String.isEmpty model.email.value |> not

                error =
                    if passwordField.visible && String.isEmpty userId then
                        Just "Invalid password"
                    else
                        Nothing

                passwordField =
                    model.password

                newPasswordField =
                    { passwordField | visible = visible, error = error }

                reload =
                    not (String.isEmpty userId)
            in
                ( { model
                    | userId = userId
                    , password = newPasswordField
                    , loading = reload
                  }
                , if reload then
                    onSuccess userId
                  else
                    Cmd.none
                )

        LogInResult (Err error) ->
            let
                oldEmail =
                    model.email

                email =
                    { oldEmail | error = Just (toString error) }
            in
                ( { model | loading = False, email = email }, Cmd.none )

        SendPassword ->
            Debug.crash model.email.value
