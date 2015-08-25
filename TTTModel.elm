-- Model.elm

module TTTModel where

import TTTUtils exposing (subsequences)
import Debug exposing (log)

-- Model
type Player = O | X

-- Pos(ition) = (Row, Col)
type alias Position = (Int, Int)

type alias Move = (Position, Player)

type alias Moves = List Move

type Result = Draw | Winner Player
            
type alias Score = 
  {
    ties : Int,
    o : Int,
    x : Int
  }

type GameState = 
    FinishedGame Result Moves
    | UnFinishedGame Player Moves
     

type alias Model =
  {
    points : Score,
    state : GameState
  }

-- Model
-- X always goes first. Todo: randomly pick first player 
newModel : Model
newModel =
  {
    points = { ties = 0, x = 0, o = 0 },
    state = UnFinishedGame X []
  }


newScore : Score -> Result -> Score
newScore points result =
  case result of
    Winner X ->
      { points | x <- ((+) 1 points.x) }
    Winner O ->
      { points | o <- ((+) 1 points.o) }
    Draw ->
      { points | ties <- ((+) 1 points.ties) }


isLegalMove : Moves -> Position -> Bool
isLegalMove moves position =
  List.all (\move -> not (fst move == position)) moves
    

getMoves : GameState -> Moves
getMoves state =
  case state of
    (UnFinishedGame _ moves) -> moves
    (FinishedGame _ moves) -> moves


getMove : GameState -> Position -> Maybe Move
getMove state position =
  let moves = getMoves state
  in
    List.head <| List.filter (\(position', player) -> position' == position) moves

  
addMove : Model -> Position -> Model
addMove model position =
   let state = (.state model)
       moves = getMoves state
       player = turn state
       newMoves = if | isLegalMove moves position -> (position, player) :: moves 
                     | otherwise -> moves
   in
     if | playerWon player newMoves ->
          { model |  state <- (FinishedGame (Winner player) newMoves)
                   , points <- (newScore model.points (Winner player)) }
        | List.length newMoves == 9 ->
          { model |  state <- (FinishedGame Draw newMoves)
                   , points <- (newScore model.points Draw) }
        | otherwise ->
          { model |  state <- (UnFinishedGame (other player) newMoves) }


playerWon : Player -> (Moves -> Bool)
playerWon player =
  let posAreInLine moves =
        List.all (\(_, col) -> col == 1) moves ||
        List.all (\(_, col) -> col == 2) moves ||
        List.all (\(_, col) -> col == 3) moves ||
        List.all (\(row, _) -> row == 1) moves ||
        List.all (\(row, _) -> row == 2) moves ||
        List.all (\(row, _) -> row == 3) moves ||
        List.all (\(row, col) -> col == row) moves ||
        List.all (\(row, col) -> col + row == 4) moves
  in subsequences
     >> List.filter (\x -> List.length x == 3)
     >> List.filter (List.all (\(_, p) -> p == player))
     >> List.map (List.map fst)
     >> List.filter posAreInLine
     >> List.isEmpty
     >> not


turn : GameState -> Player
turn state =
  case state of
    (UnFinishedGame X _) -> X
    (UnFinishedGame O _) -> O
    (FinishedGame (Winner X) _) -> O
    (FinishedGame (Winner O) _) -> X
    (FinishedGame Draw _) -> X
                               


other : Player -> Player
other player =
   case player of 
     X -> O
     O -> X
