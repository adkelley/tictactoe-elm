module TicTacToe where

import Html exposing ( li, text, ul)
import Html.Attributes exposing ( class )
    
main =
  ul [ class "test-list" ]
   [ li [ ] [ text "oranges" ]
   , li [ ] [ text "potatoes" ]
   , li [ ] [ text "pears" ]
   , li [ ] [ text "soda" ]
   ]
