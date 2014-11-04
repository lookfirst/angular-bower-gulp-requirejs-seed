define((require) ->
	homeModule = require('home/homeModule')

	homeModule.controller('HomeController', ['$scope', '$rootScope', '$log', ($scope, $rootScope, $log) ->
		$rootScope.active = null
		debugger
		$log.info('main app ctrl')
	])
)
