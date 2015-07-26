// Replace Filename with the name of your
// application file

module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "filename.js": ["Filename.elm"]
        }
      }
    },
    watch: {
      elm: {
        files: ["Filename.elm", "FilenameUtils.elm"],
        tasks: ["elm"]
      }
    },
    clean: ["elm-stuff/build-artifacts"]
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-elm');

  grunt.registerTask('default', ['elm']);

};
