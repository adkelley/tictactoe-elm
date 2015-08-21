module TicTacToe where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String exposing ( toUpper )
import Array exposing (Array, get, set, repeat)

import Random exposing ( int )
import Debug exposing (..)
import Result exposing (toMaybe)

import Signal exposing ( Address )
import StartApp

import TicTacToeModel exposing ( .. )

-- Update
type Action
  = NoOp
  | Reset
  | ToggleSquare Field


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
      
    Reset ->
      initModel

    ToggleSquare id ->
      let state = (.state model)
          player = whoseTurn state
          board = getBoard state
          square = Array.get id board
          nextPlayer = otherPlayer player
          newBoard = Array.set id player (getBoard state)
      in
        if square == Just Blank then
          Debug.log "ToggleSquare"
                 { model | state <- (UnFinishedGame nextPlayer newBoard) }
                 |> isWinner
        else
          Debug.log "ToggleSquare"
                 model
          

-- View
title : String -> Html
title message =
  message
    |> toUpper
    |> text


pageHeader : Html
pageHeader = 
  h1 [ id "header" ] [ title "tic-tac-toe" ]



renderSquare : Address Action -> Model -> Field -> Html
renderSquare address model field = 
  let
    state = (.state model)
    square = Array.get field (getBoard state)
  in
    div [ id (toString field), class "square"
        , onClick address ( ToggleSquare field  )
        ]
    [ p [ class ( case square of
                    Just O  -> "nought"
                    Just X  -> "cross"
                    Just Blank  -> "empty" )
        ]
      [ text ( case square of
                 Just O -> "O"
                 Just X -> "X"
                 Just Blank -> " " )
      ]
    ]


renderGameBoard : Address Action -> Model -> Html
renderGameBoard address model =
  div [ id "board"  ] (List.map  (renderSquare address model ) [0..8])


renderScore : Int -> Html
renderScore score =
  li [ ]
     [ text ( toString score ) ]


renderScores : Scores -> Html
renderScores scores =
  div [ id "score" ]
      [ ul [  ]
         [ renderScore scores.nought
         , renderScore scores.ties
         , renderScore scores.cross
         ]
      ]
    

panelLabel : String -> String -> String -> Html
panelLabel id' class' label =
  div [ id id' ] [ h2 [ class class'  ] [ text label ] ]


blinkClass : Player -> Player -> String
blinkClass player turn =
   if ( player == turn ) then "blink" else "no-blink"


renderScorePanel : Model -> Html
renderScorePanel model  =
  let scores = (.scores model)
      player = whoseTurn (.state model)
  in
    div [ id "panel" ]
          [ panelLabel "nought" ( blinkClass O player) "O"
          , panelLabel "tie" "no_blink" "Tie"
          , panelLabel "cross" ( blinkClass  X player ) "X"
          , renderScores scores
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
