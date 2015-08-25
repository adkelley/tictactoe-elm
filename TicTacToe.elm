module TicTacToe where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String exposing ( toUpper )

import Debug exposing (..)

import Signal exposing ( Address )
import StartApp

import TTTModel exposing (..)

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
      addMove model position |> Debug.log "Add move" 
      
          

-- View
title : String -> Html
title message =
  message
    |> toUpper
    |> text


pageHeader : Html
pageHeader = 
  h1 [ id "header" ] [ title "tic-tac-toe" ]



renderSquare : Address Action -> Model -> Position -> Html
renderSquare address model position =
  let move = getMove (.state model) position
      class' = case move of
                      Just (_, X) -> "cross"
                      Just (_, O) -> "nought"
                      otherwise -> "empty"
      text' = case move of
                  Just (_, O) -> "O"
                  Just (_, X) -> "X"
                  otherwise -> " "
  in
    div [ class "square"
        , onClick address ( AddMove position  )
        ]
    [ p [ class class' ] [ text text' ]  ]


newGameBoard : Address Action -> Model -> Html
newGameBoard address model =
  let board = [(1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3)]
  in
    div [ id "board" ] (List.map (renderSquare address model) board)


blinkWinner : GameState -> String
blinkWinner state =
  let player = other (turn state)
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


renderScores : GameState -> Score -> Html
renderScores state points =
  div [ id "score" ]
      [ ul [  ]
         [ renderScore (blinkWinner state) points.o
         , renderScore (blinkWinner state) points.ties
         , renderScore (blinkWinner state) points.x
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
      points = (.points model)
      player = turn state
  in
    div [ id "panel" ]
          [ panelLabel "nought" ( blinkTurn O player) "O"
          , panelLabel "tie" "no_blink" "Tie"
          , panelLabel "cross" ( blinkTurn  X player ) "X"
          , renderScores state points
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
        , newGameBoard  address model
        , renderScorePanel model
        , button
          [ id "reset", onClick address Reset ] [ text "Reset" ]
        , pageFooter
        ]
    

main =
  StartApp.start
  {
    model = newModel,
    view = view,
    update = update
  }

--}
