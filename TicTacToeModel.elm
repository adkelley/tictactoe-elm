-- Model.elm

module TicTacToeModel where

import List exposing (..)

-- Model
type Player = O | X

type alias Field = {  row: Int, col: Int }

type alias Move = ( Field, Player )

type alias Moves = List Move

type Result = Draw | Winner Player
            
type alias Scores = 
  {
    ties : Int,
    nought : Int,
    cross  : Int
  }

type GameState = 
    FinishedGame Result Moves
    | NotFinishedGame Player Moves
     

type alias Model =
  {
    scores : Scores,
    state : GameState
  }

initScores : Scores
initScores =
  {
    ties = 0,
    nought = 0,
    cross = 0
  }

initialModel : Model
initialModel =
  {
    scores = initScores,
    state = NotFinishedGame X [  ]
  }

updateScores : Result -> Scores -> Scores
updateScores result scores =
  case result of
    Winner X ->
      { scores | cross <- scores.cross + 1 }
    Winner O ->
      { scores | nought <- scores.nought + 1 }
    Draw ->
      { scores | ties <- scores.ties + 1 }


otherPlayer : Player -> Player
otherPlayer player =
   case player of 
     X -> O
     O -> X


-- Todo how can I alternate players?
resetGame : Model -> Model
resetGame model =
  {
    scores = initScores,
    state = case (.state model) of
              FinishedGame (Winner X) _ -> NotFinishedGame O []
              FinishedGame (Winner O) _ -> NotFinishedGame X []
              FinishedGame Draw _ -> NotFinishedGame X []
              NotFinishedGame X _ -> NotFinishedGame O []
              NotFinishedGame O _ -> NotFinishedGame X []
  }

