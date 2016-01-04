# REQUIRE

gulp    = require 'gulp'
riot    = require 'gulp-riot'
shell   = require 'gulp-shell'
concat  = require 'gulp-concat'
uglify  = require 'gulp-uglify'

# TASKS

gulp.task 'default', ['start', 'watch', 'reload']

# START

gulp.task 'start', shell.task 'coffee index.coffee'

# WATCH

gulp.task 'watch', ->
  gulp.watch ['tags/*'], ['reload']

# RELOAD

gulp.task 'reload', ->
  gulp.src('tags/*')
    .pipe(riot(template: 'jade'))
    .pipe(concat("rockauth.js"))
    .pipe(uglify())
    .pipe(gulp.dest('dest'))
