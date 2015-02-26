gulp = require 'gulp'
browserSync = require 'browser-sync'
jade = require 'gulp-jade'
util = require 'gulp-util'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
autoprefixer = require 'gulp-autoprefixer'
nib = require 'nib'

# define extensions
jadeExtensions = ['jade']
coffeeExtensions = ['coffee']
stylusExtensions = ['styl', 'stylus']
htmlExtensions = ['htm', 'html']
imageExtensions = ['jpg', 'png', 'gif']
cssExtensions = ['css']
jsExtensions = ['js']
staticExtensions = [].concat htmlExtensions, imageExtensions, cssExtensions, jsExtensions

# define directories
APP_DIR = 'app'
SOURCE_DIR = 'src'

# return paths
srcPaths = (extensions, excludeUnderscoredFile = false) ->
  extensions = [extensions] unless extensions instanceof Array
  exclusion = if excludeUnderscoredFile then "[^_]" else ""
  for extension in extensions
    "#{SOURCE_DIR}/**/#{exclusion}*.#{extension}"

# launch server
gulp.task 'server', ->
  browserSync server: baseDir: APP_DIR

# compile jade and deploy
gulp.task 'jade', ->
  gulp.src srcPaths(jadeExtensions, true)
    .pipe jade()
    .pipe gulp.dest APP_DIR

# compile coffee and deploy
gulp.task 'coffee', ->
  gulp.src srcPaths(coffeeExtensions)
    .pipe coffee(bare: true).on 'error', util.log
    .pipe gulp.dest APP_DIR

# compile stylus and deploy
gulp.task 'stylus', ->
  gulp.src srcPaths(stylusExtensions)
    .pipe stylus use: [nib()]
    .pipe autoprefixer browsers: ['last 2 versions'], cascade: true
    .pipe gulp.dest APP_DIR

# deploy images
gulp.task 'static', ->
  gulp.src srcPaths(staticExtensions)
    .pipe gulp.dest APP_DIR

# deploy bower components
gulp.task 'bower', ->
  gulp.src 'bower_components/**/*'
    .pipe gulp.dest "#{APP_DIR}/bower_components"

# watch and reload
gulp.task 'watch', ->
  gulp.watch srcPaths(jadeExtensions), ['jade', browserSync.reload]
  gulp.watch srcPaths(coffeeExtensions), ['coffee', browserSync.reload]
  gulp.watch srcPaths(stylusExtensions), ['stylus', browserSync.reload]
  gulp.watch srcPaths(staticExtensions), ['static', browserSync.reload]

# default set
gulp.task 'default', ['jade', 'coffee', 'stylus', 'static', 'bower', 'server', 'watch']
