define((require) ->
	miscModule = require('misc/miscModule')
	miscModule.factory('JSOGInterceptor', [ ->
		{
			response: (response) ->
				JSOG.decode(response)
		}
	])
)
