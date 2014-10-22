gulp = require 'gulp'
browserSync = require 'browser-sync'
jade = require 'gulp-jade'
util = require 'gulp-util'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
nib = require 'nib'

# launch server
gulp.task 'server', ->
  browserSync server: baseDir: 'app'

# compile jade and deploy
gulp.task 'jade', ->
  gulp.src 'src/**/*.jade'
    .pipe jade()
    .pipe gulp.dest 'app'

# compile coffee and deploy
gulp.task 'coffee', ->
  gulp.src 'src/**/*.coffee'
    .pipe coffee(bare: true).on 'error', util.log
    .pipe gulp.dest 'app'

# compile stylus and deploy
gulp.task 'stylus', ->
  gulp.src ['src/**/*.styl', 'src/**/*.stylus']
    .pipe stylus use: [nib()]
    .pipe gulp.dest 'app'

# deploy images
gulp.task 'image', ->
  gulp.src ['src/**/*.jpg', 'src/**/*.png', 'src/**/*.gif']
    .pipe gulp.dest 'app'

# watch and reload
gulp.task 'watch', ->
  gulp.watch ['src/**/*.jade'], ['jade', browserSync.reload]
  gulp.watch ['src/**/*.coffee'], ['coffee', browserSync.reload]
  gulp.watch ['src/**/*.styl', 'src/**/*.stylus'], ['stylus', browserSync.reload]
  gulp.watch ['src/**/*.jpg', 'src/**/*.png', 'src/**/*.gif'], ['image', browserSync.reload]

# default set
gulp.task 'default', ['jade', 'coffee', 'stylus', 'image', 'server', 'watch']
