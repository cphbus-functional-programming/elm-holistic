
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

type alias Member =
  { id : Int
  , name : String
  , email : String
  }

type alias Model = Member

type Msg
  = NameChanged String
  | EmailChanged String
  | ButtonClicked

init : (Model, Cmd Msg)
-- init = (Member 7 "Anders And" "aa@andeby.quack", Cmd.none)
init = ({ id = 7, name = "Anders And", email = "aa@andeby.quack"}, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ text ("This is "++model.name++" with number "++(toString model.id))
    , input [ onInput NameChanged, value model.name ] []
    , input [ onInput EmailChanged, value model.email ] []
    , button [ onClick ButtonClicked ] [ text "Click me!" ]
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NameChanged newName ->
      ( { model | name = newName }, Cmd.none)
    EmailChanged newEmail ->
      ( { model | email = newEmail }, Cmd.none)
    ButtonClicked ->
      (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
