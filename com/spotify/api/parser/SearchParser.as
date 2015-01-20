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

	import com.spotify.api.vo.result.AlbumSearchVO;
	import com.spotify.api.response.ErrorMessages;
	import com.spotify.api.events.SpotifyQueryResultEvent;
	import com.spotify.api.methods.Search;
	import com.spotify.api.ns.opensearch;
	import com.spotify.api.ns.spotify;
	import com.spotify.api.vo.AlbumVO;
	import com.spotify.api.vo.ArtistVO;
	import com.spotify.api.vo.TerritoryRestrictionsVO;
	import com.spotify.api.vo.TrackSearchVO;
	import com.spotify.api.vo.result.OpenSearchMetadataVO;
	import com.spotify.api.vo.result.SearchResultVO;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Sidney de Koning
	 */
	final public class SearchParser {
		
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
				case Search.ALBUM:
					if(response.album != "") {
						responseLength = response.album.length(); 
						
						for(var i : int = 0;i < responseLength; ++i) {
							
							var albumSearchData:AlbumSearchVO = new AlbumSearchVO();
							albumSearchData.album_id 	= (response.spotify::album[i].attribute("href") != "") ? response.spotify::album[i].attribute("href") : "No track id.";
							albumSearchData.album_name 	= (response.spotify::album[i].name.text() != "") ? response.spotify::album[i].name.text() : "No track name.";
							albumSearchData.id_type	 	= (response.spotify::album[i].id.attribute("type") != "") ? response.spotify::album[i].id.attribute("type") : "No track name.";
							albumSearchData.id_value 	= (response.spotify::album[i].id.text() != "") ? response.spotify::album[i].id.text() : "No track name.";
							albumSearchData.popularity 	= (response.spotify::album[i].popularity.text() != "") ? response.spotify::album[i].popularity.text() : "No track name.";
							
							var albumSearchArtistData:ArtistVO = new ArtistVO();
							albumSearchArtistData.artist_id 	= (response.spotify::album[i].artist.attribute("href") != "") ? response.spotify::album[i].artist.attribute("href") : "No artist name.";
							albumSearchArtistData.artist_name 	= (response.spotify::album[i].artist.name.text() != "") ? response.spotify::album[i].artist.name.text() : "No artist name.";
							
							var albumSearchTerroirData:TerritoryRestrictionsVO = new TerritoryRestrictionsVO();
							albumSearchTerroirData.territory = (response.spotify::album[i].album.availability.territories.text() != "") ? response.spotify::album[i].album.availability.territories.text() : "No territory data.";
							
							albumSearchData.artist = albumSearchArtistData;
							albumSearchData.album_availability_territories = albumSearchTerroirData;
							
							// Add all data to tracks
							searchResult.result.push(albumSearchData);
						}
					} else {
						throw Error(ErrorMessages.DOES_NOT_CONTAIN_CORRECT_NODES);
					}
					break;
				case Search.TRACK:
					if(response.track != "") {
						responseLength = response.track.length(); 
					
						for(var j : int = 0;j < responseLength; ++j) {
							var track : TrackSearchVO = new TrackSearchVO();
							track.track_id 		= (response.spotify::track[j].attribute("href") != "") ? response.spotify::track[j].attribute("href") : "No track id.";
							track.track_name 	= (response.spotify::track[j].name.text() != "") ? response.spotify::track[j].name.text() : "No track name.";
							track.id_type	 	= (response.spotify::track[j].id.attribute("type") != "") ? response.spotify::track[j].id.attribute("type") : "No track name.";
							track.id_value	 	= (response.spotify::track[j].id.text() != "") ? response.spotify::track[j].id.text() : "No track name.";
							track.track_number 	= (response.spotify::track[j]["track-number"] != "") ? response.spotify::track[j]["track-number"] : "No track name.";
							track.track_length 	= (response.spotify::track[j]["length"] != "") ? response.spotify::track[j]["length"] : "No track name.";
							track.popularity 	= (response.spotify::track[j].popularity.text() != "") ? response.spotify::track[j].popularity.text() : "No track name.";
							
							var artistData:ArtistVO = new ArtistVO();
							artistData.artist_id 	= (response.spotify::track[j].artist.attribute("href") != "") ? response.spotify::track[j].artist.attribute("href") : "No artist name.";
							artistData.artist_name 	= (response.spotify::track[j].artist.name.text() != "") ? response.spotify::track[j].artist.name.text() : "No artist name.";
							
							var albumData:AlbumVO = new AlbumVO();
							albumData.album_id	 			= (response.spotify::track[j].album.attribute("href") != "") ? response.spotify::track[j].album.attribute("href") : "No album id.";
							albumData.album_name 			= (response.spotify::track[j].album.name.text() != "") ? response.spotify::track[j].album.name.text() : "No album name.";
							albumData.album_year_released 	= (response.spotify::track[j].album.released.text() != "") ? response.spotify::track[j].album.released.text() : "No album year.";
							
							var terroirData:TerritoryRestrictionsVO = new TerritoryRestrictionsVO();
							terroirData.territory = (response.spotify::track[j].album.availability.territories.text() != "") ? response.spotify::track[j].album.availability.territories.text() : "No territory data.";
							
							// Add terroir data
							albumData.album_availability_territories = TerritoryRestrictionsVO(terroirData);
							// Add artist data
							track.artist = ArtistVO(artistData);
							// Add album
							track.album = AlbumVO(albumData);
							// Add all data to tracks
							searchResult.result.push(track);
						}
					} else {
						throw Error(ErrorMessages.DOES_NOT_CONTAIN_CORRECT_NODES);
					}
					break;
				case Search.ARTIST:
					if(response.artist != "") {
						responseLength = response.artist.length(); 
					
						for(var k : int = 0;k < responseLength; ++k) {
							var arstistSearch:ArtistVO = new ArtistVO();
							arstistSearch.artist_id 	= (response.spotify::artist[k].attribute("href") != "") ? response.spotify::artist[k].attribute("href") : "No artist id.";
							arstistSearch.artist_name 	= (response.spotify::artist[k].name.text() != "") ? response.spotify::artist[k].name.text() : "No artist name.";
							arstistSearch.popularity 	= (response.spotify::artist[k].popularity.text() != "") ? response.spotify::artist[k].popularity.text() : "No track name.";
							
							searchResult.result.push(arstistSearch);
						}
					}
					break;
			}
			SearchParser.dispatchEvent(new SpotifyQueryResultEvent(SpotifyQueryResultEvent.SEARCH_RESULT, searchResult));
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
