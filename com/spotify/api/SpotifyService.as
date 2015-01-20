/*
 * 	This product uses a SPOTIFY API but is not endorsed, certified or otherwise approved in any way by Spotify. 
 * 	Spotify is the registered trade mark of the Spotify Group.
 * 
 * 	1. THE USE OF THE API AND THE METADATA IS AT YOUR OWN RISK. THE API AND THE METADATA 
 * 	IS PROVIDED ON AN “AS IS” AND “AS AVAILABLE” BASIS. THERE IS NO WARRANTY, EXPRESSED 
 * 	OR IMPLIED, AS TO THE QUALITY, CONTENT AND AVAILABILITY OR FITNESS FOR A SPECIFIC 
 *  PURPOSE OF THE API OR THE METADATA. NO ADVICE OR INFORMATION, WHETHER ORAL OR IN WRITING, 
 *  OBTAINED BY YOU FROM SPOTIFY SHALL CREATE ANY WARRANTY ON BEHALF OF SPOTIFY IN THIS REGARD.
 * 
 * 	2. IN NO EVENT SHALL SPOTIFY, ITS AFFILIATES, OFFICERS, DIRECTORS AND EMPLOYEES BE LIABLE 
 * 	FOR ANY INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED 
 * 	TO ANY LOSS OF DATA, SERVICE INTERRRUPTION, COMPUTER FAILURE OR PECUNIARY LOSS) ARISING 
 * 	OUT OF THE USE OF OR INABILITY TO USE THE API OR THE METADATA, INCLUDING ANY DAMAGES 
 * 	RESULTING THEREFROM. YOUR ONLY RIGHT WITH RESPECT TO ANY PROBLEMS OR DISSATISFACTION 
 * 	WITH THE API OR THE METADATA IS TO STOP USING THE API. 
*/
package com.spotify.api {

	import com.spotify.api.events.SpotifyEvent;
	import com.spotify.api.events.SpotifyQueryResultEvent;
	import com.spotify.api.methods.Lookup;
	import com.spotify.api.methods.Search;
	import com.spotify.api.parser.LookupParser;
	import com.spotify.api.parser.SearchParser;
	import com.spotify.api.servicemethods.ServicesMethods;
	import com.spotify.api.util.StringUtils;
	import com.spotify.api.vo.result.SearchResultVO;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * Spotify Metadata AS3 API 
	 * AS3 API implementation of the Spotify Metadata API
	 * 
	 * @author Sidney de Koning - sidney[ at ]funky-monkey.nl
	 *
	 * @see http://www.funky-monkey.nl/blog/
	 * @see http://developer.spotify.com/en/metadata-api/terms-of-use/
	 * 
	 * @version 1.0.1
	 */
	  
	final public class SpotifyService extends EventDispatcher {

		private static const SPOTIFY_API_VERSION : String = "Spotify Metadata API V0.4";
		//
		private static const API_URL : String 		= "http://ws.spotify.com/";
		private static const API_VERSION : String 	= "1";
		private static const PAGE_QUERY : String 	= "&page=";
		private static const EXTRA_QUERY : String 	= "&extras=";
		//
		public static const XML_RESPONSE : String 	= "xml"; /** For now only XML support */
		public static const JSON_RESPONSE : String 	= ".json"; /** Not (yet) supported */
		//
		private var _format : String;
		private var _method : String;
		private var _loader : URLLoader;
		private var _debug : Boolean;
		private var _services : String;
		private var _parsedResult : SearchResultVO;
		private var _callBackFunction : Function;

		//
		public function SpotifyService( responseFormat : String = SpotifyService.XML_RESPONSE, debug : Boolean = false ) {
			
			_debug = debug;
			_format = responseFormat;

			_loader = new URLLoader();
			_loader.addEventListener( IOErrorEvent.IO_ERROR, handleIOErrorRequest );
			_loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus );

			trace( SPOTIFY_API_VERSION );
		}

		public function call( services : String, method : String, searchQuery : String, page : int = 1, extras : String = "" ) : void {
			
			_services = services;
			_method = method;
			_loader.addEventListener( Event.COMPLETE, handleRequestResponse );
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			// Replace all the spaces with a plus sign +
			var searchArgument : String = StringUtils.replaceSpacesWithPlusses( searchQuery );

			var pagePart : String = (page != 1) ? PAGE_QUERY + page : "";
			var extraPart : String = (extras != "") ? EXTRA_QUERY + extras : "";

			var sQuery : String;
			var url : String;

			switch(services) {
				case ServicesMethods.SEARCH_METHOD:
					sQuery = "?q=";
					url = API_URL + services + "/" + API_VERSION + "/" + method + sQuery + searchArgument + pagePart + extraPart;
					break;
				case ServicesMethods.LOOKUP_METHOD:
					sQuery = "?uri=";
					url = API_URL + services + "/" + API_VERSION + "/" + sQuery + searchArgument + pagePart + extraPart;
					break;
			}

			var req : URLRequest = new URLRequest( url );

			if (debugMode == true) {
				trace( url );
			}

			_loader.load(req);
		}

		private function handleIOErrorRequest( event : IOErrorEvent ) : void {
			
			event.stopPropagation();
			dispatchEvent( new SpotifyEvent(SpotifyEvent.HTTP_RESPONSE, 0, event.text) );
		}
		
		private function handleHTTPStatus( event : HTTPStatusEvent ) : void {
			
			event.stopPropagation();
			dispatchEvent( new SpotifyEvent(SpotifyEvent.HTTP_RESPONSE, event.status) );
		}

		private function handleRequestResponse( event : Event ) : void {
			
			var response : XML = new XML( event.target.data ) as XML;
			XML.ignoreWhitespace = true;
			XML.ignoreComments = true;

			switch( method ) {
				case Search.ALBUM:
				case Search.ARTIST:
				case Search.TRACK:
					SearchParser.addEventListener( SpotifyQueryResultEvent.SEARCH_RESULT, parsedResult );
					SearchParser.parse( response, method );
					break;
				case Lookup.ALBUM:
				case Lookup.ARTIST:
				case Lookup.TRACK:
					LookupParser.addEventListener( SpotifyQueryResultEvent.LOOKUP_RESULT, parsedResult );
					LookupParser.parse( response, method );
					break;
			}

			_loader.removeEventListener( Event.COMPLETE, handleRequestResponse );
		}

		private function parsedResult( event : SpotifyQueryResultEvent ) : void {
			
			_parsedResult = event.data;
			if (_callBackFunction !== null) {
				callBackFuction(  );
			} else {
				dispatchEvent( event );
			}
		}
		
		public function callBack( onCallBack:Function = null ):void {
			if(onCallBack !== null) _callBackFunction = onCallBack;
		}
		
		private function callBackFuction():void {	
			_callBackFunction( _parsedResult );
		}

		public function get services() : String {
			return _services;
		}

		public function get method() : String {
			return _method;
		}

		public function get debugMode() : Boolean {
			return _debug;
		}

		public function set debugMode( value : Boolean ) : void {
			_debug = value;
		}
	}
}
