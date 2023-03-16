const coffee = require('gulp-coffee');
const gulp = require('gulp');
const gutil = require('gulp-util');
const notify = require('gulp-notify');
const browserify = require('browserify');
const source = require('vinyl-source-stream');
const coffeelint = require('gulp-coffeelint');
// const concat = require('gulp-concat');
// const plumber = require('gulp-plumber');
const mocha = require('gulp-mocha');
const uglify = require('gulp-uglify');
const rename = require('gulp-rename');
const fs = require('fs');

const outDir = './public/'  //'./build/static/';
const bundleFile = 'coffee-main.js' //'main.js';

const errorHandler = function (err) {
    gutil.log(err);
    this.emit('end');
}

function lint() {
    return gulp.src('./src/coffee/**/*.coffee')
        .pipe(coffeelint('./coffeelint.json'))
        .pipe(coffeelint.reporter())
}

gulp.task('lint', lint);

function js() {   // this is only for testing purposes to see the js files
    return gulp.src('./src/coffee/**/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest(outDir + 'coffee-js/'))   // or just ./build/static/js/
}

gulp.task('js', js);

function build() {
    // if bundleFile does not exist, it will be created empty
    if (!fs.existsSync(outDir + bundleFile)) {
        fs.closeSync(fs.openSync(outDir + bundleFile, 'w'));
    }

    return browserify({
        entries: ['./src/coffee/app.coffee'],
        extensions: ['.coffee', '.js']
    })
        .transform('coffeeify')
        .bundle()
        .on('error', notify.onError('build error'))
        .on('error', errorHandler)
        .pipe(source(bundleFile))
        .pipe(gulp.dest(outDir))
        .pipe(notify('build completed'))
        .pipe(_uglify());                   // uglify could be removed for faster build
}

gulp.task('build', build);

function _uglify() {
    return gulp.src(outDir + bundleFile)
        .pipe(rename(bundleFile.replace('.js', '.min.js')))     // rename to .min.js
        .pipe(uglify())
        .pipe(gulp.dest(outDir));
}

gulp.task('uglify', _uglify);

function test() {
    return gulp.src('./test/**/*-spec.coffee', {read: false})
        .pipe(mocha({ui: 'bdd', reporter: 'spec', compilers: 'coffee-script/register'}))
        .on('error', notify.onError('test error'))
        .on('error', errorHandler)
}

gulp.task('test', test);

function coverage() {
    return gulp.src('./test/coverage-test.coffee', {read: false})
        .pipe(mocha({ui: 'bdd', reporter: 'html-cov', compilers: 'coffee-script/register'}))
        .on('error', notify.onError('test error'))
        .on('error', errorHandler)
        .pipe(gulp.dest('./coverage/'));
}

gulp.task('coverage', coverage);

function watch() {
    // First time build
    build();
    gulp.watch(['./src/coffee/*.coffee'], build);
}

gulp.task('watch', watch);


// Run multiple tasks
gulp.task('start', gulp.series('build', 'uglify'));
gulp.task('default', gulp.series('watch'));
gulp.task('full', gulp.series('lint', 'build', 'test', 'uglify'));

// HOW TO RUN: gulp watch or gulp start