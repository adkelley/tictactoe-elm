# Tic-Tac-Toe in Elm
----------------------
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

A Tic-Tac-Toe game in the browser implemented in the [Elm Programming Language](http://elm-lang.org) 

For a comparison see my [implementation](https://github.com/Project_1_TTT) in Javascript 

## Build/Run
1. Ensure that you've installed the latest [elm and its build tools](http://elm-lang.org/install)
2. Run **elm-package** to install dependencies
3. Run **grunt** to transpile the elm and jade files to **tictactoe.js** and **index.html**, respectively
4. Open **index.html** in your favorite browser

## Deployment
To deploy to Heroku manually, you'll need to set the BuildPack and config points:
1. heroku config:set BUILDPACK_URL=https://github.com/srid/heroku-buildpack-elm.git
2. heroku config:set ELM_COMPILE="elm make TicTacToe.elm"
3. heroku config:set ELM_STATIC_DIR="."

[heroku live deployment](https://polar-oasis-5892.herokuapp.com)