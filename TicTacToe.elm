module TicTacToe where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String exposing ( toUpper )

import Debug exposing (..)

import Signal exposing ( Address )
import StartApp

import TTModel exposing (..)

-- Update
type Action
  = NoOp
  | Reset
  | AddMove Position


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
      
    Reset ->
      newModel

    AddMove position ->
      addMove model (position, turn)
      
          

-- View
title : String -> Html
title message =
  message
    |> toUpper
    |> text


pageHeader : Html
pageHeader = 
  h1 [ id "header" ] [ title "tic-tac-toe" ]



renderSquare : Address Action -> Model -> (Position, Player) -> Html
renderSquare address (position, player) =
  let square = if 
    div [ class "square"
        , onClick address ( AddMove position  )
        ]
    [ p [ class ( case  of
                    Just O  -> "nought"
                    Just X  -> "cross"
                    Just Blank  -> "empty" )
        ]
      [ text ( case move of
                 Just O -> "O"
                 Just X -> "X"
                 Just Blank -> " " )
      ]
    ]


renderGameBoard : Address Action -> Model -> Html
renderGameBoard address model =
  let board = getBoard (.state model)
  div [ id "board"  ] 


blinkWinner : GameState -> String
blinkWinner state =
  let player = otherPlayer (whoseTurn state)
  in
   case state of
     (FinishedGame (Winner X) _) -> if player == X then "blink" else "no-blink"
     (FinishedGame (Winner O) _) -> if player == O then "blink" else "no-blink"
     (FinishedGame Draw _) -> "blink"
     otherwise -> "no-blink"

renderScore : String -> Int -> Html
renderScore blink score =
  li [ class blink ]
     [ text ( toString score ) ]


renderScores : GameState -> Scores -> Html
renderScores state scores =
  div [ id "score" ]
      [ ul [  ]
         [ renderScore (blinkWinner state) scores.nought
         , renderScore (blinkWinner state) scores.ties
         , renderScore (blinkWinner state) scores.cross
         ]
      ]
    

panelLabel : String -> String -> String -> Html
panelLabel id' class' label =
  div [ id id' ] [ h2 [ class class'  ] [ text label ] ]


blinkTurn : Player -> Player -> String
blinkTurn player turn =
   if ( player == turn ) then "blink" else "no-blink"


renderScorePanel : Model -> Html
renderScorePanel model  =
  let state = (.state model)
      scores = (.scores model)
      player = whoseTurn state
  in
    div [ id "panel" ]
          [ panelLabel "nought" ( blinkTurn O player) "O"
          , panelLabel "tie" "no_blink" "Tie"
          , panelLabel "cross" ( blinkTurn  X player ) "X"
          , renderScores state scores
          ]


pageFooter : Html
pageFooter =
  footer [ id "footer"  ]
    [ a [ href "https://github.com/adkelley" ]
        [ text "view github repository" ]
    ]
    

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
        [ pageHeader
        , renderGameBoard  address model
        , renderScorePanel model
        , button
          [ id "reset", onClick address Reset ] [ text "Reset" ]
        , pageFooter
        ]
    

main =
  StartApp.start
  {
    model = initModel,
    view = view,
    update = update
  }

--}
