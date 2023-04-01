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
const sourcemaps = require('gulp-sourcemaps');
const buffer = require('vinyl-buffer');

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
        extensions: ['.coffee', '.js'],
        debug: true  // enable source maps
    })
        .transform('coffeeify')
        .bundle()
        .on('error', notify.onError('build error'))
        .on('error', errorHandler)
        .pipe(source(bundleFile))
        .pipe(gulp.dest(outDir))

        .pipe(buffer())  // convert streaming contents into buffer contents (because gulp-sourcemaps does not support streaming contents)
        .pipe(sourcemaps.init({loadMaps: true}))  // initialize source maps from browserify
        .pipe(sourcemaps.write('.'))       // write the source map file to the same directory as the bundle
        .pipe(gulp.dest('./public'))
        // Create the minified file
        //.pipe(_uglify());                // uglify could be removed for faster build
    // .pipe(notify('build completed'));
}

// Compile all coffee files
// coffee -c -o ./public/main.js ./src/coffee/*.coffee
// ------------------------------------------------------------------------
// Bundle all js files into one file
// browserify -t coffeeify ./src/coffee/app.coffee -o ./public/main.js  // not working

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
    gulp.watch(['./src/coffee/*.coffee'], {events: 'all'}, gulp.series('build'));
}

gulp.task('watch', watch);


// Run multiple tasks
gulp.task('start', gulp.series('build', 'uglify'));
gulp.task('default', gulp.series('watch'));
gulp.task('full', gulp.series('lint', 'build', 'test', 'uglify'));

// HOW TO RUN: gulp watch or gulp start