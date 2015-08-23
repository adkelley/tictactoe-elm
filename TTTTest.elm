module TTTTest where

import String

import Graphics.Element exposing (..)
import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

import TTTModel exposing (..)

addRow : Model -> Int -> Int -> Player -> Model
addRow model row col player =
  case col of
    4 -> model
    otherwise ->
      addRow (addMove model ((row, col), player)) row (col+1) player 

addCol : Model -> Int -> Int -> Player -> Model
addCol model row col player =
  case row of
    4 -> model
    otherwise ->
      addCol (addMove model ((row, col), player)) (row+1) col player 

tests : Test
tests = suite "TicTacToe Model Test Suite"
        [ test "Inital Model" ( assertEqual
                                newModel
                                { points = { ties = 0, x = 0, o = 0 },
                                  state = UnFinishedGame X [] } )
        , test "Row Winner" (assertEqual
                             (addRow newModel 1 1 X)
                             { points = { ties = 0, x = 1, o = 0 },
                               state = FinishedGame (Winner X) [((1,3), X), ((1,2), X), ((1,1), X)] })
        , test "Col Winner" (assertEqual
                             (addCol newModel 1 1 O)
                             { points = { ties = 0, x = 0, o = 1 },
                               state = FinishedGame (Winner O) [((3,1), O), ((2,1), O), ((1,1), O)] })
        , test "Draw"       (assertEqual
                             (addMove (addMove (addMove
                                (addMove (addMove (addMove
                                   (addMove (addMove (addMove
                                                      newModel
                                                      ((1,1),X)) ((1,2),O)) ((1,3),X))
                                                      ((2,1),X)) ((2,2),O)) ((2,3),O))
                                                      ((3,1),O)) ((3,2),X)) ((3,3),X))

                             { points = { ties = 1, x = 0, o = 0 },
                               state = FinishedGame Draw [  ((3,3),X), ((3,2),X), ((3,1),O)
                                                          , ((2,3),O), ((2,2),O), ((2,1),X)
                                                          , ((1,3),X), ((1,2),O), ((1,1),X)
                                                         ] })
        ]

main : Element
main = runDisplay tests
