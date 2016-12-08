module EasyLogin.Decoder exposing (signIn, decodeSession)

import Json.Decode
import Json.Encode
import JsonApi exposing (Document, Resource)
import JsonApiExtra as JsonApiExtra
import JsonApi.Decode
import JsonApi.Documents
import JsonApi.Resources
import EasyLogin.Model as Model


signIn : String -> String -> String -> Cmd Model.Msg
signIn path email password =
    let
        attributes =
            Json.Encode.object
                [ ( "email", Json.Encode.string email )
                , ( "password", Json.Encode.string password )
                ]

        body =
            Json.Encode.object
                [ ( "data"
                  , Json.Encode.object
                        [ ( "type", Json.Encode.string "sessions" )
                        , ( "attributes", attributes )
                        ]
                  )
                ]
    in
        request body path


request : Json.Encode.Value -> String -> Cmd Model.Msg
request body url =
    JsonApiExtra.post url body Model.LogInResult JsonApi.Decode.document


decodeSession : Document -> String
decodeSession document =
    case JsonApi.Documents.primaryResource document of
        Err error ->
            Debug.crash error

        Ok session ->
            decodeSesionAttributes session


decodeSesionAttributes : Resource -> String
decodeSesionAttributes session =
    let
        decoder =
            Json.Decode.field "user-id" Json.Decode.string
    in
        JsonApi.Resources.attributes decoder session
            |> Result.toMaybe
            |> Maybe.withDefault ""
