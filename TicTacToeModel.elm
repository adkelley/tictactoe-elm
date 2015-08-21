-- Model.elm

module TicTacToeModel where

import Array exposing (Array, get, set, repeat, length)

-- Model
type Player = O | X | Blank

type alias Field = Int

type alias Move = Player

type alias Board = Array Move

type Result = Draw | Winner Player
            
type alias Scores = 
  {
    ties : Int,
    nought : Int,
    cross  : Int
  }

type GameState = 
    FinishedGame Result Board
    | UnFinishedGame Player Board
     

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

initModel : Model
initModel =
  {
    scores = initScores,
    state = UnFinishedGame Blank (Array.repeat 9 Blank)
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


isDraw : Board -> Maybe Result
isDraw board =
    if (== (Array.length board) 9) then Just Draw else Nothing

-- threeInRow : Board -> Player -> Player
-- threeInRow board =
--   let row = List.take 3 (Array.toList board)
--   in
--     case row of
--       Empty ->
--         Player
      
--     threeInRow row X

isWinner : Model -> Model
isWinner model =
  let
    state = (.state model)
    board = getBoard state
    result = 
    draw = draw board
  in
    { model | scores <- (updateScores (Winner X) (.scores model)) }


-- Todo: use random to pick a who goes first at
-- upon resetting the game (i.e., player == Blank)
whoseTurn : GameState -> Player
whoseTurn state =
  case state of
    (UnFinishedGame X _) -> X
    (UnFinishedGame O _) -> O
    (UnFinishedGame Blank _) -> X
    (FinishedGame (Winner X) _) -> X
    (FinishedGame (Winner O) _) -> O
    (FinishedGame Draw _) -> X
                            


otherPlayer : Player -> Player
otherPlayer player =
   case player of 
     X -> O
     O -> X


getBoard : GameState -> Board
getBoard state =
  case state of
    (UnFinishedGame _ board) -> board
    (FinishedGame _ board) -> board



