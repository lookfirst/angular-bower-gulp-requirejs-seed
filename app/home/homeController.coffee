define((require) ->
	homeModule = require('home/homeModule')

	homeModule.controller('HomeController', ['$scope', '$rootScope', ($scope, $rootScope) ->
		$rootScope.active = null
		console.log('main app ctrl')
	])
)
