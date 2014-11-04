define((require) ->
	homeModule = require('home/homeModule')

	homeModule.controller('HomeController', ['$scope', '$rootScope', '$log', ($scope, $rootScope, $log) ->
		$rootScope.active = null
		$log.info('main app ctrl')
	])
)
