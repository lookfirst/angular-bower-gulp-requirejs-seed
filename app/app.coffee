define((require) ->
	angular = require('angular')
	require('angular-ui-router')
	require('angular-bootstrap')
	require('angular-resource')
	require('angular-cookies')
	require('angular-flash')
	require('ng-sortable')
	require('google-code-prettify')
	require('jsog')

	require('nav/navController')
	require('home/homeController')
	require('misc/jsogInterceptor')

	require('templates')
	require('config')
	require('session')

	angular.module('app', ['ui.bootstrap', 'ui.router', 'ui.sortable', 'ngResource', 'ngCookies', 'angular-flash.service', 'angular-flash.flash-alert-directive',
							'Home', 'Nav', 'Misc', 'templates', 'Session', 'app.constants'])
	.config(['$httpProvider', '$stateProvider', '$urlRouterProvider', '$locationProvider', '$sceDelegateProvider', 'API_HOST',
	($httpProvider, $stateProvider, $urlRouterProvider, $locationProvider, $sceDelegateProvider, API_HOST) ->

		$sceDelegateProvider.resourceUrlWhitelist(['self', "#{API_HOST}/**"])

		$httpProvider.interceptors.push('JSOGInterceptor')
		$stateProvider
			.state('index',
				{
					'url': '/'
					'controller': 'HomeController'
					'template': '<h1>App</h1>'
				})

		$urlRouterProvider.otherwise('/')
	])

	.run(['$rootScope', 'Session', ($rootScope, Session) ->
		$rootScope.session = new Session()
		return
	])

	angular.bootstrap(document, ['app'])
)
