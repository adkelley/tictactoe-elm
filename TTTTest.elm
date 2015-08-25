module TTTTest where

import String

import Graphics.Element exposing (..)
import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)

import TTTModel exposing (..)

addRow : Model -> Int -> Int -> Model
addRow model row col =
  case col of
    4 -> model
    otherwise ->
      addRow ((addMove model (row, col)) row (col+1)
                       

addCol : Model -> Int -> Int -> Model
addCol model row col =
  case row of
    4 -> model
    otherwise ->
      addCol (addMove model (row, col)) (row+1) col

tests : Test
tests = suite "TicTacToe Model Test Suite"
        [ test "Inital Model" ( assertEqual
                                newModel
                                { points = { ties = 0, x = 0, o = 0 },
                                  state = UnFinishedGame X [] } )
        , test "Row Winner" (assertEqual
                             (addRow newModel 1 1)
                             { points = { ties = 0, x = 1, o = 0 },
                               state = FinishedGame (Winner X) [((1,3), X), ((1,2), X), ((1,1), X)] })
        , test "Col Winner" (assertEqual
                             (addCol newModel 1 1)
                             { points = { ties = 0, x = 0, o = 1 },
                               state = FinishedGame (Winner X) [((3,1), X), ((2,1), X), ((1,1), X)] })
        , test "Draw"       (assertEqual
                             (addMove (addMove (addMove
                                (addMove (addMove (addMove
                                   (addMove (addMove (addMove
                                                      newModel
                                                      (1,1) (1,2) (1,3))
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
