
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

type alias Model =
  { current : Maybe Member
  , allMembers : List Member
  }

type Msg
  = NameChanged String
  | EmailChanged String
  | AddMemberClicked
  | SaveMemberClicked

init : (Model, Cmd Msg)
init = ( { current = Nothing, allMembers = []} , Cmd.none)
-- init = (Member 7 "Anders And" "aa@andeby.quack", Cmd.none)
-- init = ({ id = 7, name = "Anders And", email = "aa@andeby.quack"}, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ currentMemberForm model.current
    , button [ onClick AddMemberClicked ] [ text "Add a member" ]
    , hr [] []
    , div [] <| List.map viewMember model.allMembers
    ]

viewMember : Member -> Html nomsg
viewMember member =
  div [] [ text <| "Member #"++(toString member.id)++": "++member.name++" "++member.email ]

currentMemberForm : Maybe Member -> Html Msg
currentMemberForm memberOrNot =
  case memberOrNot of
    Nothing ->
      div [] [ text "No member selected" ]
    Just member ->
      div []
        [ div [] [ text <| "Member #"++(toString member.id)]
        , div [] [ input [ onInput NameChanged, value member.name ] []]
        , div [] [ input [ onInput EmailChanged, value member.email ] []]
        , button [ onClick SaveMemberClicked ] [ text "Save" ]
        ]


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
      AddMemberClicked ->
        ({ model | current = Just {id = (List.length model.allMembers) + 1, name = "", email = "" }}, Cmd.none)
      NameChanged newName ->
        case model.current of
          Nothing -> (model, Cmd.none)
          Just member ->
            ({ model | current = Just { member | name = newName } }, Cmd.none)
      EmailChanged newEmail ->
        case model.current of
          Nothing -> (model, Cmd.none)
          Just member ->
            ({ model | current = Just { member | email = newEmail } }, Cmd.none)
      SaveMemberClicked ->
        case model.current of
          Nothing -> (model, Cmd.none)
          Just member ->
            ({ model | allMembers = (model.allMembers ++ [member]), current = Nothing }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
