module TicTacToe where

import TicTacToeModel exposing ( .. )
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String exposing ( toUpper )

import Random exposing ( int )

import Signal exposing ( Address )
import StartApp

-- Update
type Action
  = NoOp
  | Reset


update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
      
    Reset ->
      resetGame model

--     -- Todo: Maybe needed if user does something wrong
--     ToggleSquare id ->
--       let updateSquare ( player, id' ) =
--             if ( ( id' == id ) && ( square == empty ) ) then ( model.turn, id ) else ( player, id )
--       in
-- --        { model | board <- List.map updateSquare model.board, turn <- whoseTurn model.turn }
--           { model | turn <- whoseTurn model.turn, board <- List.map updateSquare model.board }
--|> isWinner


-- View
title : String -> Html
title message =
  message
    |> toUpper
    |> text


pageHeader : Html
pageHeader = 
  h1 [ id "header" ] [ title "tic-tac-toe" ]


-- square : Address Action -> ( Player, Id ) -> Html
-- square address ( player, id ) = 
--   div [ class "square"
--       , onClick address ( ToggleSquare id )
--       ]
--       [  p [ class ( case player of
--                        O  -> "nought"
--                        X  -> "cross"
--                        otherwise  -> "empty" )
--            ]
--          [ text ( case player of
--                     O -> "O"
--                     X -> "X"
--                     otherwise -> " "
--                 )
--          ]
--       ]
      

-- gameBoard : Address Action -> Moves -> Html
-- gameBoard address moves =
--   div [ id "board"  ] ( List.map ( square address ) board )


renderScore : Int -> Html
renderScore score =
  li [ ]
     [ text ( toString score ) ]


renderScores : Scores -> Html
renderScores scores =
  div [ id "score" ]
      [ ul [  ]
         [ renderScore scores.ties
         , renderScore scores.nought
         , renderScore scores.cross
         ]
      ]
    
panelLabel : String -> String -> String -> Html
panelLabel id' class' label =
  div [ id id' ] [ h2 [ class class'  ] [ text label ] ]

blinkClass : Player -> Player -> String
blinkClass player turn =
   if ( player == turn ) then "blink" else "no-blink"

scorePanel : Model -> Html
scorePanel model  =
  let scores = (.scores model)
      player = case (.state model) of
                 NotFinishedGame X _ -> X
                 NotFinishedGame O _ -> O
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
        -- , ( gameBoard  address ( .board model ) )
        , scorePanel model
        , button
          [ id "reset", onClick address Reset ] [ text "Reset" ]
        , pageFooter
        ]
    
main =
  StartApp.start
  {
    model = initialModel,
    view = view,
    update = update
  }

--}
