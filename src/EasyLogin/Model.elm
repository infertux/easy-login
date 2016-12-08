module EasyLogin.Model exposing (..)

import Http exposing (Error)
import JsonApi exposing (Document)


type Msg
    = Input FieldId String
    | LogIn
    | LogInResult (Result Http.Error Document)
    | SendPassword


type FieldId
    = Email
    | Password


type alias Model =
    { email : Field
    , password : Field
    , userId : String
    , loading : Bool
    , settings : Settings
    }


type alias Settings =
    { loginPath : String
    , lostPasswordPath : String
    }


type alias Field =
    { value : String
    , visible : Bool
    , error : Maybe String
    }


initialField : Field
initialField =
    { value = ""
    , visible = False
    , error = Nothing
    }


initialSettings : Settings
initialSettings =
    { loginPath = "/api/sessions"
    , lostPasswordPath = "/api/lost-password?userId=%s"
    }


initialModel : Model
initialModel =
    { email = { initialField | visible = True }
    , password = initialField
    , userId = ""
    , loading = False
    , settings = initialSettings
    }
