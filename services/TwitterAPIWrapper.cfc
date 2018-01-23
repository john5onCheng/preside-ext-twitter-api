/**
 * @presideService
 */
component singleton=true{

// CONSTRUCTOR
	public any function init()  {
		return this;
	}

// PUBLIC METHODS
	/**
	* Makes an Application-Only-Auth request
	* as per https://developer.twitter.com/en/docs/basics/authentication/overview/application-only
	*	*/
	public struct function appAuthRequest( required string method, required string endpoint, struct params={} ) {

		var authTokenResult = getAuthToken();

		if ( !authTokenResult.ok ) {
			return authTokenResult;
		}

		return _apiCall( method, endpoint, params, "Bearer #authTokenResult.data.access_token#" );
	}


	/**
	* Gets an Access Token for Bearer Authorization (Application only) based on API Key and API Secret
	*/
	public struct function getAuthToken() {

		var bearerToken = toBase64( _getAPIkey() & ":" & _getAPIsecret() );

		return _apiCall( "POST", "https://api.twitter.com/oauth2/token", { "<body>": "grant_type=client_credentials" }, "Basic #bearerToken#" );
	}

// PRIVATE METHODS
	private function _apiCall( required string method, required string endpoint, required struct params, required string authHeader ) {

		var resultContent     = {};
		var httpResult = {};
		var result     = {
		 	  ok       : false
			, metadata : {}
		};

		var paramsType = "url";
		if ( arguments.method == "post" ) {
			if ( arguments.params.keyExists( "<body>" ) ) {
				paramsType = "body";
			} else {
				paramsType = "form";
			}
		}

		try {
			http method=arguments.method url=arguments.endpoint charset="utf-8" result="httpResult" timeout=10 {

				httpparam type="header" name="Content-Type"  value="application/x-www-form-urlencoded;charset=UTF-8";
				httpparam type="header" name="Authorization" value="#arguments.authHeader#";

				for( var param in arguments.params ) {
					httpparam name=param value=arguments.params[ param ] type=paramsType;
				}
			}

			result = {
			 	  ok       : left( httpResult.statusCode, 1 ) == "2"
				, metadata : httpResult.responseHeader
				, data     : deserializeJSON( httpResult.fileContent )
			};

		} catch( e ) {
			$raiseError( e );
		}

		if ( !result.ok ) {
			result.errors = resultContent.errors ?: [];
		}

		return result;

	}

// GETTERS AND SETTERS
	private string function _getAPIkey() {
		return $getPresideSetting( 'twitter_api', 'api_key', 'GlMPQCZl6GXHX5iYzz77wfTZx' );
	}

	private string function _getAPIsecret() {
		return $getPresideSetting( 'twitter_api', 'api_secret', 'yZo34mP2Rjbov5omAn6ZDqwoPlCeuxb1M41oEjH3mIQ9aOyS47' );
	}

}