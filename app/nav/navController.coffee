define((require) ->
	navModule = require('nav/navModule')

	navModule.controller('NavController', ['$scope', '$rootScope', '$location', 'flash', ($scope, $rootScope, $location, flash) ->
		$scope.isCollapsed = true
		$scope.alerts = []
		return # make jslint happy
	])
)
