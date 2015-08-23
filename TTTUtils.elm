module TTTUtils where

{-
   return all subsequences of a list
   example: subsequences [] -> [[]]
   subsequneces [1] -> [[], [1]]
-}
subsequences : List a -> List (List a)
subsequences lst =
  case lst of
    [] -> [[]]
    h::t ->
      let st = subsequences t
      in
        st ++ List.map (\x -> h::x) st
