// Replace Tictactoe with the name of your
// application file

module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "tictactoe.js": ["TicTacToe.elm"]
        }
      }
    },
    jade: {
      compile: {
        options: {
          pretty: true,
          data: {
            debug: false
          }
        },
        files: {
          "index.html": "./jade/index.jade"
        }
      }
    },
    watch: {
      elm: {
        files: ["TicTacToe.elm"],
        tasks: ["elm"]
      },
      jade: { 
        files: [ "./jade/index.jade" ],
        tasks: [ "jade" ]
      }
    },
    clean: ["elm-stuff/build-artifacts"]
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-elm');
  grunt.loadNpmTasks( 'grunt-contrib-jade' );

  grunt.registerTask('default', ['elm', 'jade']);

};
