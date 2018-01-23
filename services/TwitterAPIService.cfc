/**
 * @presideService
 */
 component singleton=true {

// CONSTRUCTOR
	/**
	 * @TwitterAPIWrapper.inject  TwitterAPIWrapper
	 *
	 */
	public function init( required any twitterAPIWrapper ) {
		_setTwitterAPIWrapper( arguments.twitterAPIWrapper );

		return this;
	}

// PUBLIC METHODS
	// Returns a collection of the most recent Tweets posted by the user indicated by the screen_name or user_id parameters.
	// https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-user_timeline
	public struct function getUserTimeLine( boolean useCache=true ) {
		return _getTwitterAPIWrapper().appAuthRequest(
			  method   = "get"
			, endpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
			, params   = arguments
		);
	}

// GETTERS AND SETTERS
	private any function _getTwitterAPIWrapper() {
		return _twitterAPIWrapper;
	}

	private void function _setTwitterAPIWrapper( required any twitterAPIWrapper ) {
		_twitterAPIWrapper = arguments.twitterAPIWrapper;
	}

}