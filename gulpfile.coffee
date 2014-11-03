fs = require('fs')
gulp = require('gulp')
gutil = require('gulp-util')
del = require('del')
argv = require('yargs').argv
exec = require('child_process').exec

browserSync = require('browser-sync')
concat = require('gulp-concat')
angularTemplatecache = require('gulp-angular-templatecache')
coffeelint = require('gulp-coffeelint')
jshint = require('gulp-jshint')
protractor = require('gulp-protractor').protractor
coffee = require('gulp-coffee')
sass = require('gulp-sass')
ngConstant = require('gulp-ng-constant')
bowerRequireJS = require('bower-requirejs')
requirejs = require('requirejs')
amdclean = require('amdclean')
UglifyJS = require('uglify-js')

DESTINATION = './target'
DEV_DIR='app'

JS_DIR= "#{DESTINATION}/#{DEV_DIR}"
APP_DIR="#{DESTINATION}/#{DEV_DIR}"

DEPLOY_APP_DIR="#{DESTINATION}/deploy"
DEPLOY_JS_DIR="#{DESTINATION}/js"

NG_CONSTANT_CONFIG = {
	name: 'app.constants'
	wrap: 'amd'
}

gulp.task('coffee2js', ->
	gulp.src(['./app/**/*.coffee', '!./app/**/*_test.coffee'])
		.pipe(coffee({bare: true})
		.on('error', gutil.log))
		.pipe(jshint())
		.pipe(jshint.reporter('default'))
		.pipe(gulp.dest(JS_DIR))
)

gulp.task('bower-requirejs', ['templates', 'coffee2js'], (cb) ->
	options = {
		config: "#{JS_DIR}/main.js"
		exclude: []
		baseUrl: ''
		transitive: false
		'exclude-dev': true
	}

	done = (out) ->
		if ! out.paths
			return cb(out)
		cb()

	bowerRequireJS(options, done)
)

gulp.task('r.js', ['set-deploy-config', 'bower-requirejs'], (cb) ->
	requirejs.optimize({
		name: 'main'
		baseUrl: "#{JS_DIR}"
		mainConfigFile: "#{JS_DIR}/main.js"
		out: "#{DEPLOY_APP_DIR}/main.js"
		optimize: 'none'
		onModuleBundleComplete: ((data) ->

			cleaned = amdclean.clean({
				transformAMDChecks: true
				filePath: "#{DEPLOY_APP_DIR}/main.js"
				wrap: {
					start: '(function() { window.amdCleaned = true; var google_code_prettify; ' # https://github.com/gfranko/amdclean/issues/63
					end: '}());'
				}
			})
			fs.writeFileSync("#{DEPLOY_APP_DIR}/main.js", cleaned)

			uglified = UglifyJS.minify("#{DEPLOY_APP_DIR}/main.js")

			fs.writeFile("#{DEPLOY_APP_DIR}/main.js", uglified.code, cb)
		)
	})
)

gulp.task('lint', ->
	gulp.src(['./app/**/*.coffee', 'gulpfile.coffee'])
		.pipe(coffeelint())
		.pipe(coffeelint.reporter())
)

gulp.task('templates', ->
	#combine all template files of the app into a js file
	gulp.src(['./app/**/*.html', '!./app/index.html'])
		.pipe(angularTemplatecache('templates.js', {standalone: true}))
		.pipe(gulp.dest(JS_DIR))
)

gulp.task('css', ->
	gulp.src('./app/**/*.scss')
		.pipe(sass())
		.pipe(concat('app.css'))
		.pipe(gulp.dest(APP_DIR))
)

gulp.task('css-vendor', ->
	#concatenate vendor CSS files
	gulp.src(['./bower_components/**/*.css', '!./bower_components/**/*.min.css'])
		.pipe(concat('lib.css'))
		.pipe(gulp.dest(APP_DIR))
)

gulp.task('copy-fonts', ->
	gulp.src('./bower_components/bootstrap/fonts/*')
		.pipe(gulp.dest("#{APP_DIR}/fonts"))
)

gulp.task('copy-images', ->
	gulp.src('./app/images/*')
		.pipe(gulp.dest("#{APP_DIR}/images"))
)

gulp.task('copy-index', ->
	gulp.src('./app/index.html')
		.pipe(gulp.dest(APP_DIR))
)

gulp.task('copy-requirejs', ->
	gulp.src('./bower_components/requirejs/require.js')
		.pipe(gulp.dest(APP_DIR))
)

gulp.task('config', ->
	gulp.src('./app/config.json')
		.pipe(ngConstant(NG_CONSTANT_CONFIG))
		.pipe(gulp.dest(JS_DIR))
)

gulp.task('config-prod', ['set-deploy-config'], ->
	gulp.src('./app/config-prod.json')
		.pipe(ngConstant(NG_CONSTANT_CONFIG))
		.pipe(concat('config.js'))
		.pipe(gulp.dest(JS_DIR))
)

gulp.task('watch', ->
	gulp.watch(["#{APP_DIR}/**"], -> browserSync.reload())

	gulp.watch(['./app/**/*.coffee', '!./app/**/*test.coffee'], ['lint', 'coffee2js'])
	gulp.watch(['./app/**/*.html', '!./app/index.html'], ['templates'])
	gulp.watch('./app/**/*.scss', ['css'])
	gulp.watch('./app/index.html', ['copy-index'])
	gulp.watch('./app/config.json', ['config'])
)

gulp.task('connect', ['connect-server'])
gulp.task('connect-deploy', ['deploy', 'connect-server'])
gulp.task('connect-server', ->
	browserSync({
		open: false
		notify: false
		port: argv.p || 9000
		server: {
			baseDir: APP_DIR
			routes: {
				'/bower_components': './bower_components' # hack this here so that paths in the bower file work
			}
		}
	})
)

gulp.task('test:e2e', ->
	gulp.src(['./tests/e2e/**/*.js']).pipe(protractor(
		{
			configFile: 'protractor.config.js'
			args: ['--baseUrl', 'http://127.0.0.1:8000']
		}
	)).on('error', (e) ->
		throw e
	)
)

gulp.task('set-deploy-config', ->
	APP_DIR = DEPLOY_APP_DIR
	JS_DIR = DEPLOY_JS_DIR
)

gulp.task('clean', (cb) ->
	del([APP_DIR, JS_DIR], cb)
)

gulp.task('css-and-copy', [
	'css'
	'css-vendor'
	'copy-index'
	'copy-fonts'
	'copy-images'
])

gulp.task('heroku', [
	'connect-deploy'
])

gulp.task('deploy', [
	'config-prod'
	'r.js'
	'css-and-copy'
])

gulp.task('development', [
	'coffee2js'
	'templates'
	'config'
	'copy-requirejs'
	'css-and-copy'
	'watch'
])

gulp.task('default', [
	'connect'
	'development'
])
