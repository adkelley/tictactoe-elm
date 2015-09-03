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
  | Next


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
      
    Reset ->
      resetModel

    AddMove position ->
      addMove model position |> Debug.log "Add move"
        
    Next ->
      nextGame model
      
      
          

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
  let state = (.state model)
      blinkX = case state of
                 (FinishedGame (Winner X) _) -> "blink"
                 otherwise -> "no-blink"
      blinkO = case state of
                 (FinishedGame (Winner O) _) -> "blink"
                 otherwise -> "no-blink"
      move = getMove state position
      class' = case move of
                      Just (_, X) -> blinkX ++ " cross"
                      Just (_, O) -> blinkO ++ " nought"
                      otherwise -> "empty"
      text' = case move of
                  Just (_, X) -> "X"
                  Just (_, O) -> "O"
                  otherwise -> " "
  in
    div [ class "square"
        , onClick address ( AddMove position  )
        ]
    [ p [ class class' ] [ text text' ]  ]


newGameBoard : Address Action -> Model -> Html
newGameBoard address model =
--  let board = [(1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3)]
  let board = List.concat <| List.map ( \i -> List.map ( \j -> ( i, j ) ) [ 1..3 ] ) [ 1..3 ]
  in
    div [ id "board" ] (List.map (renderSquare address model) board)


renderScore : Int -> Html
renderScore score =
  li [ ]
     [ text ( toString score ) ]


renderScores : GameState -> Score -> Html
renderScores state points =
  div [ id "score" ]
      [ ul [  ]
         [ renderScore points.o
         , renderScore points.ties
         , renderScore points.x
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
          , panelLabel "tie" "no-blink" "Tie"
          , panelLabel "cross" ( blinkTurn  X player ) "X"
          , renderScores state points
          ]


pageFooter : Html
pageFooter =
  footer [ id "footer"  ]
    [ a [ href "https://github.com/adkelley" ]
          [ text "2015 - Alex Kelley" ]
    ]
    
    

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
        [ pageHeader
        , newGameBoard  address model
        , renderScorePanel model
        , button
          [ id "reset", onClick address Reset ] [ text "Reset" ]
        , button
          [ id "next-game", onClick address Next ] [ text "Next Game" ]
        , pageFooter
        ]
    

main =
  StartApp.start
  {
    model = resetModel,
    view = view,
    update = update
  }

--}
