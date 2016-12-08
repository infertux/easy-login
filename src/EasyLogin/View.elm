module EasyLogin.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import EasyLogin.Model exposing (..)


view : Model -> Html Msg
view model =
    Html.form [ onSubmit LogIn ] <|
        List.concat
            [ emailInput model.email
            , passwordInput model.password
            , buttons model
            ]


emailInput : Field -> List (Html Msg)
emailInput field =
    formGroup field
        [ input
            [ onInput (Input Email)
            , name "email"
            , placeholder "Enter your email"
            , type_ "email"
            , class "form-control"
            , required True
            ]
            []
        ]


passwordInput : Field -> List (Html Msg)
passwordInput field =
    formGroup field
        [ input
            [ onInput (Input Password)
            , name "password"
            , placeholder "Enter your password"
            , type_ "password"
            , class "form-control"
            , required True
            ]
            []
        ]


formGroup : Field -> List (Html Msg) -> List (Html Msg)
formGroup field input =
    let
        error =
            errorBlock field.error

        errored =
            error /= []

        errorClass =
            if errored then
                " has-danger"
            else
                ""
    in
        [ div [ class <| "form-group" ++ errorClass ] <|
            List.concat
                [ showIf field.visible input
                , error
                ]
        ]


errorBlock : Maybe String -> List (Html Msg)
errorBlock error =
    case error of
        Just error ->
            [ div [ class "form-control-feedback help-block" ] [ text error ] ]

        Nothing ->
            []


buttons : Model -> List (Html Msg)
buttons model =
    [ div [ class "form-group text-xs-center" ] <|
        List.concat
            [ submitButton model.loading
            , showIf model.password.visible noPasswordButton
            ]
    ]


submitButton : Bool -> List (Html Msg)
submitButton isDisabled =
    [ input
        [ type_ "submit"
        , class <|
            "btn btn-primary btn-block"
                ++ if isDisabled then
                    " fa-spin"
                   else
                    ""
        , disabled isDisabled
        , value <|
            if isDisabled then
                "..."
            else
                "Next"
        ]
        []
    ]


noPasswordButton : List (Html Msg)
noPasswordButton =
    [ a
        [ class "btn btn-secondary btn-block mt-1"
        , href "#"
        , onClick SendPassword
        ]
        [ text "Don't know your password?" ]
    ]


showIf : Bool -> List (Html Msg) -> List (Html Msg)
showIf condition html =
    if condition then
        html
    else
        []
