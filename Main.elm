
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)

main : Program Never Model Msg
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
  , webresult : String
  }

type Msg
  = NameChanged String
  | EmailChanged String
  | AddMemberClicked
  | SaveMemberClicked
  | GetWebResult
  | GetAllMembers
  | MemberListStringArrived (Result Http.Error String)
  | MemberArrived (Result Http.Error Member)
  | MemberListArrived (Result Http.Error (List Member))

init : (Model, Cmd Msg)
init = ( { current = Nothing, allMembers = [], webresult = "None yet"} , Cmd.none)
-- init = (Member 7 "Anders And" "aa@andeby.quack", Cmd.none)
-- init = ({ id = 7, name = "Anders And", email = "aa@andeby.quack"}, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ text <| "Web result was: "++model.webresult
    , currentMemberForm model.current
    , button [ onClick AddMemberClicked ] [ text "Add a member" ]
    , button [ onClick GetWebResult ] [ text "Get single member from web" ]
    , button [ onClick GetAllMembers ] [ text "Get all members from web" ]
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
      MemberArrived (Err _) -> (model, Cmd.none)
      MemberArrived (Ok member) -> ({ model | current = Just member }, Cmd.none)

      MemberListArrived (Err _) -> (model, Cmd.none)
      MemberListArrived (Ok members) -> ({ model | allMembers = members }, Cmd.none )

      MemberListStringArrived (Err _) -> (model, Cmd.none)
      MemberListStringArrived (Ok payload) -> ({ model | webresult = payload }, Cmd.none )
      -- GetWebResult -> (model, getMemberList)
      GetWebResult -> (model, getMember 2)
      GetAllMembers -> (model, getMemberList)
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

getMemberListOld : Cmd Msg
getMemberListOld =
  let
    url = "http://localhost:8080/member"
  in
    Http.send MemberListStringArrived (Http.getString url)

getMemberList : Cmd Msg
getMemberList =
  let
    url = "http://localhost:8080/member"
  in
    Http.send MemberListArrived (Http.get url memberListDecoder)

getMember : Int -> Cmd Msg
getMember id =
  let
    url = "http://localhost:8080/member/" ++ (toString id)
  in
    Http.send MemberArrived (Http.get url memberDecoder)

memberDecoder : Decoder Member
memberDecoder =
  Decode.map3 Member
    (Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "email" Decode.string)

memberListDecoder : Decoder (List Member)
memberListDecoder = Decode.list memberDecoder
