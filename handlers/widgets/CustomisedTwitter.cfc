component {

	property name="TwitterAPIService"  inject="TwitterAPIService";

	private function index( event, prc, rc, args={} ) {

		var userTimeline = TwitterAPIService.getUserTimeLine( screen_name="@GOC_UK", count=2, trim_user=true, exclude_replies=true, include_rts=true );

		writeDump(userTimeline);
		abort;
	}


}
