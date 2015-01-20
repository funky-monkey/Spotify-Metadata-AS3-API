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
package com.spotify.api.parser {

	import com.spotify.api.events.SpotifyQueryResultEvent;
	import com.spotify.api.methods.Lookup;
	import com.spotify.api.methods.Search;
	import com.spotify.api.ns.opensearch;
	import com.spotify.api.ns.spotify;
	import com.spotify.api.response.ErrorMessages;
	import com.spotify.api.vo.AlbumVO;
	import com.spotify.api.vo.ArtistVO;
	import com.spotify.api.vo.TerritoryRestrictionsVO;
	import com.spotify.api.vo.TrackSearchVO;
	import com.spotify.api.vo.result.AlbumSearchVO;
	import com.spotify.api.vo.result.OpenSearchMetadataVO;
	import com.spotify.api.vo.result.SearchResultVO;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Sidney de Koning
	 */
	final public class LookupParser {
		
		private static var _dispatcher : EventDispatcher = new EventDispatcher();
		
		public static function parse(response : XML, method:String) : void {
			
			var metadata:OpenSearchMetadataVO = new OpenSearchMetadataVO();
			metadata.role 			= response.opensearch::Query.@role;
			metadata.searchTerms 	= response.opensearch::Query.@searchTerms;
			metadata.startPage 		= response.opensearch::Query.@startPage;
			metadata.totalResults	= response.opensearch::totalResults.text();
			metadata.startIndex		= response.opensearch::startIndex.text();
			metadata.itemsPerPage	= response.opensearch::itemsPerPage.text();
			
			var searchResult:SearchResultVO = new SearchResultVO();
			searchResult.openSearchMetadata = metadata;
			
			use namespace spotify; 
			
			var responseLength:int;
			
			// Switch on different methods
			switch( method ) {
				case Lookup.ALBUM:
					break;
				case Search.TRACK:
					break;
				case Search.ARTIST:
					break;
			}
			SearchParser.dispatchEvent(new SpotifyQueryResultEvent(SpotifyQueryResultEvent.LOOKUP_RESULT, searchResult));
		}

		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. 
		 * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
		 * @param type The type of event.
		 * @param listener The listener function that processes the event. This function must accept an Event object as its only parameter and must return nothing.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 * @param priority The priority level of the event listener.
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak.
		 * @throws ArgumentError The listener specified is not a function. 
		 */
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
		 * @param type The type of event. 
		 * @param listener The listener object to remove.
		 * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases. 
		 * If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both, 
		 * one call with useCapture() set to true, and another call with useCapture() set to false. 
		 */
		public static function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * Dispatches an event to all the registered listeners. 
		 * @param event Event object.
		 * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise.
		 * @throws Error The event dispatch recursion limit has been reached. 
		 */
		public static function dispatchEvent(event : Event) : Boolean {
			return _dispatcher.dispatchEvent(event);
		}

		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event. This allows you to determine where an EventDispatcher object has 
		 * altered handling of an event type in the event flow hierarchy.
		 * @param event The type of event.  
		 * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise. 
		 */
		public static function hasEventListener(type : String) : Boolean {
			return _dispatcher.hasEventListener(type);
		}
	}
}
