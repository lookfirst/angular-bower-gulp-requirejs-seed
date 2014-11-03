configureRequire = ->
	do (require) ->
		require.config({
			waitSeconds: 60
			preserveLicenseComments: false
			paths: {
				'angular': '../bower_components/angular/angular'
				'angular-bootstrap': '../bower_components/angular-bootstrap/ui-bootstrap-tpls.min'
				'angular-ui-router': '../bower_components/angular-ui-router/release/angular-ui-router'
				'angular-resource': '../bower_components/angular-resource/angular-resource'
				'angular-flash': '../bower_components/angular-flash/dist/angular-flash'
				'angular-cookies': '../bower_components/angular-cookies/angular-cookies'
				'google-code-prettify': '../bower_components/google-code-prettify/src/prettify'
				'lodash': '../bower_components/lodash/dist/lodash.compat'
				'jsog': '../bower_components/jsog/lib/JSOG'
				'ng-sortable': '../bower_components/ng-sortable/dist/ng-sortable'
			}
			shim: {
				'angular':
					{exports: 'angular'}
				'angular-ui-router':
					{deps: ['angular']}
				'angular-resource':
					{deps: ['angular']}
				'angular-cookies':
					{deps: ['angular']}
				'angular-flash':
					{deps: ['angular']}
				'angular-bootstrap':
					{deps: ['angular']}
				'ng-sortable':
					{deps: ['angular']}
				'templates':
					{deps: ['angular']}
				'config':
					{deps: ['angular']}
			}

			deps: ['app']
		})

if window && ! window.amdCleaned # This is defined in the gulpfile
	if ! require?
		# Inject a script in the page
		inject = (src) ->
			s = document.createElement('script')
			s.type = 'text/javascript'
			s.async = false
			s.src = src
			s.onload = -> configureRequire()
			t = document.getElementsByTagName('script')[0]
			t.parentNode.insertBefore(s,t)
		inject('/require.js')
	else
		configureRequire()
