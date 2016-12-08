module JsonApiExtra exposing (get, post)

import Http
import Json.Decode
import Json.Encode
import Time exposing (Time)


type alias RequestParams a =
    { method : String
    , headers : List Http.Header
    , url : String
    , body : Http.Body
    , expect : Http.Expect a
    , timeout : Maybe Time
    , withCredentials : Bool
    }


get : String -> (Result Http.Error a -> msg) -> Json.Decode.Decoder a -> Cmd msg
get url result decoder =
    Http.send result <|
        Http.request <|
            makeRequest "GET" url Http.emptyBody decoder


post : String -> Json.Encode.Value -> (Result Http.Error a -> msg) -> Json.Decode.Decoder a -> Cmd msg
post url body result decoder =
    let
        stringBody =
            body
                |> Json.Encode.encode 0
                |> Http.stringBody "application/vnd.api+json"
    in
        Http.send result <|
            Http.request <|
                makeRequest "POST" url stringBody decoder


makeRequest : String -> String -> Http.Body -> Json.Decode.Decoder a -> RequestParams a
makeRequest method url body decoder =
    { method = method
    , url = url
    , body = body
    , expect = Http.expectJson decoder
    , headers = [ Http.header "Accept" "application/vnd.api+json" ]
    , timeout = Nothing
    , withCredentials = True
    }
