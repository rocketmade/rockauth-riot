# REQUIRE

gulp    = require 'gulp'
riot    = require 'gulp-riot'
tape    = require 'gulp-tape'
spec    = require 'tap-spec'
shell   = require 'gulp-shell'
concat  = require 'gulp-concat'
uglify  = require 'gulp-uglify'
gulpif  = require 'gulp-if'
coffee  = require 'gulp-coffee'

# TASKS

gulp.task 'default', ['start', 'mock', 'watch', 'reload']

# START

gulp.task 'start', shell.task 'coffee index.coffee'

# RELOAD

gulp.task 'reload', ['rockauth.js'], ->
  gulp.start 'test'

# WATCH

gulp.task 'watch', ->
  gulp.watch ['tags/*', 'rockauth.coffee', 'test.coffee'], ['reload']

# ROCKAUTH MOCK

gulp.task 'mock', ['mock:db', 'mock:api']

gulp.task 'mock:db', shell.task [
  'postgres -D /usr/local/var/postgres'
], quiet: true

gulp.task 'mock:api', shell.task [
  'bundle exec rails server -e test -p 3011',
], cwd: "rockauth", quiet: true

gulp.task 'mock:reset', shell.task [
  'bundle exec rake db:reset RAILS_ENV=test'
], cwd: "rockauth", quiet: true

# TESTS

gulp.task 'test', ['test.js'], ->
  gulp.src('test.js')
    .pipe(tape(reporter: spec()))

gulp.task 'test.js', ->
  gulp.src('test.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('.'))

# ROCKAUTH.JS

gulp.task 'rockauth.js', ['mock:reset'], ->
  gulp.src(['rockauth.coffee', 'tags/*'])
    .pipe(gulpif(/\.coffee$/, coffee()))
    .pipe(gulpif(/\.tag$/, riot(template: 'jade')))
    .pipe(concat("rockauth.js"))
    .pipe(uglify())
    .pipe(gulp.dest('.'))
