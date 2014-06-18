module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      compile:
        expand: true
        cwd: "."
        src: "**/*.coffee"
        dest: "."
        ext: ".js"
        extDot :"last"


  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.registerTask('default', ['coffee'])
  grunt.registerTask('heroku', ['coffee'])
