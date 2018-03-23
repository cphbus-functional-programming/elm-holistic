
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model = String

type Msg
  = NoMessage
  | SomeMessage

init : (Model, Cmd Msg)
init = ("No information yet", Cmd.none)

view : Model -> Html Msg
view model =
  div [] [ text model ]

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NoMessage ->
      (model, Cmd.none)
    SomeMessage ->
      (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
