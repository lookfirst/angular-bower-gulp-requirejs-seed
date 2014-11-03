define((require) ->
	angular = require('angular')
	config = require('config')
	angular.module('Session',[]).factory('Session', ->
		class Session
			constructor: ->

			getConfig: -> config
		return Session
	)
)
