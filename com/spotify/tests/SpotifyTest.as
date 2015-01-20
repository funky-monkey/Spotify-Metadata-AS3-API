package com.spotify.tests {

	import com.spotify.api.SpotifyService;
	import com.spotify.api.events.SpotifyEvent;
	import com.spotify.api.events.SpotifyQueryResultEvent;
	import com.spotify.api.methods.Lookup;
	import com.spotify.api.methods.Search;
	import com.spotify.api.response.SpotifyHTTPResponse;
	import com.spotify.api.servicemethods.ServicesMethods;
	import com.spotify.api.vo.ArtistVO;
	import com.spotify.api.vo.TrackSearchVO;
	import com.spotify.api.vo.result.AlbumSearchVO;
	import com.spotify.api.vo.result.SearchResultVO;

	import flash.display.Sprite;
	
	/**
	 * Spotify Metadata AS3 API 
	 * Implementation of the SpotifyService class to show all functionality of the AS3 Metadata API
	 * 
	 * @author Sidney de Koning
	 *
	 * @see http://www.funky-monkey.nl/blog/
	 * @see http://developer.spotify.com/en/metadata-api/terms-of-use/
	 * 
	 * @version 1.0.1
	 */
	public class SpotifyTest extends Sprite {

		private var _spotifyService : SpotifyService;

		public function SpotifyTest() {
			
			_spotifyService = new SpotifyService( SpotifyService.XML_RESPONSE, true );
			_spotifyService.addEventListener( SpotifyEvent.HTTP_RESPONSE, handleSpotifyHTTPStatus );
			_spotifyService.addEventListener( SpotifyEvent.IO_ERROR, handleIOErrorRequest );
			_spotifyService.addEventListener( SpotifyQueryResultEvent.SEARCH_RESULT, handleSpotifySearchResult );
			_spotifyService.addEventListener( SpotifyQueryResultEvent.LOOKUP_RESULT, handleSpotifyLookupResult );
			
			// If this is commented out, Events are used.
//			_spotifyService.callBack( spotifyResultHandler );
			_spotifyService.debugMode = true;
			
			// Make the actual call
//			_spotifyService.call( ServicesMethods.SEARCH_METHOD, Search.TRACK, "stereo mc", 1 );
			// _spotifyService.call( ServicesMethods.SEARCH_METHOD, Search.ARTIST, "stereo mc", 1 );
			 _spotifyService.call( ServicesMethods.SEARCH_METHOD, Search.ALBUM, "stereo mc", 1 );
//			_spotifyService.call( ServicesMethods.LOOKUP_METHOD, Lookup.ALBUM, "stereo mc", 1, Lookup.EXTRAS_ALBUM );
		}

		private function spotifyResultHandler( data : SearchResultVO ) : void {
			
			if (_spotifyService.debugMode) {
				trace( "Call back mode" );
				var dataLength : int = SearchResultVO( data ).result.length;
				trace( "You have searched for '" + SearchResultVO( data ).openSearchMetadata.searchTerms + "'. Found " + SearchResultVO( data ).openSearchMetadata.totalResults + " results" );
			}
			
			switch (_spotifyService.method) {
				case Search.ALBUM:
					for (var k : int = 0; k < dataLength; k++) {
						trace( int( k + 1 ) + "\t " + AlbumSearchVO( data.result[k] ).album_id + " - " + AlbumSearchVO( data.result[k] ).album_name + " - " + AlbumSearchVO( data.result[k] ).id_type + " - " + AlbumSearchVO( data.result[k] ).id_value );
					}
					break;
				case Search.ARTIST:
					for (var i : int = 0; i < dataLength; i++) {
						trace( int( i + 1 ) + "\t " + ArtistVO( data.result[i] ).artist_id + " - " + ArtistVO( data.result[i] ).artist_name + " - " + ArtistVO( data.result[i] ).popularity );
					}
					break;
				case Search.TRACK:
					for (var j : int = 0; j < dataLength; j++) {
						trace( int( j + 1 ) + "\t " + TrackSearchVO( data.result[j] ).album.album_year_released + " - " + TrackSearchVO( data.result[j] ).artist.artist_name + " - " + TrackSearchVO( data.result[j] ).album.album_name + " - ALBUM: " + TrackSearchVO( data.result[j] ).track_name );
					}
					break;
			}
		}

		private function handleSpotifyHTTPStatus( event : SpotifyEvent ) : void {
			
			if (_spotifyService.debugMode) {
				switch( event.status) {
					case 200: trace( SpotifyHTTPResponse.RESPONSE_200 ); break;
					case 304: trace( SpotifyHTTPResponse.RESPONSE_304 ); break;
					case 400: trace( SpotifyHTTPResponse.RESPONSE_400 ); break;
					case 404: trace( SpotifyHTTPResponse.RESPONSE_404 ); break;
					case 406: trace( SpotifyHTTPResponse.RESPONSE_406 ); break;
					case 500: trace( SpotifyHTTPResponse.RESPONSE_500 ); break;
					case 503: trace( SpotifyHTTPResponse.RESPONSE_503 ); break;
				}
			}
		}

		private function handleIOErrorRequest( event : SpotifyEvent ) : void {
			
			trace( "Spotify Metadata API is probably not working : " + event.text );
		}
		
		private function handleSpotifyLookupResult( event : SpotifyQueryResultEvent ) : void {
			var targetData : SpotifyQueryResultEvent = event as SpotifyQueryResultEvent;

			if (_spotifyService.debugMode) {
				var dataLength : int = SearchResultVO( targetData.data ).result.length;
				trace( "You have searched for '" + SearchResultVO( targetData.data ).openSearchMetadata.searchTerms + "'. Found " + SearchResultVO( targetData.data ).openSearchMetadata.totalResults + " results" );
			}
			
			if (event.type == SpotifyQueryResultEvent.LOOKUP_RESULT) {
				trace( "lookup result garble!" );
			}
		}

		private function handleSpotifySearchResult( event : SpotifyQueryResultEvent ) : void {
			
			var targetData : SpotifyQueryResultEvent = event as SpotifyQueryResultEvent;

			if (_spotifyService.debugMode) {
				var dataLength : int = SearchResultVO( targetData.data ).result.length;
				trace( "You have searched for '" + SearchResultVO( targetData.data ).openSearchMetadata.searchTerms + "'. Found " + SearchResultVO( targetData.data ).openSearchMetadata.totalResults + " results" );
			}

			var service : SpotifyService = event.target as SpotifyService;
			service.removeEventListener( SpotifyQueryResultEvent.SEARCH_RESULT, handleSpotifySearchResult );
			service.removeEventListener( SpotifyQueryResultEvent.LOOKUP_RESULT, handleSpotifySearchResult );

			if (event.type == SpotifyQueryResultEvent.SEARCH_RESULT) {
				switch (service.method) {
					case Search.ALBUM:
						for (var k : int = 0; k < dataLength; k++) {
							trace( int( k + 1 ) + "\t " + AlbumSearchVO( targetData.data.result[k] ).album_id + " - " + AlbumSearchVO( targetData.data.result[k] ).album_name + " - " + AlbumSearchVO( targetData.data.result[k] ).id_type + " - " + AlbumSearchVO( targetData.data.result[k] ).id_value );
						}
						break;
					case Search.ARTIST:
						for (var i : int = 0; i < dataLength; i++) {
							trace( int( i + 1 ) + "\t " + ArtistVO( targetData.data.result[i] ).artist_id + " - " + ArtistVO( targetData.data.result[i] ).artist_name + " - " + ArtistVO( targetData.data.result[i] ).popularity );
						}
						break;
					case Search.TRACK:
						for (var j : int = 0; j < dataLength; j++) {
							trace( int( j + 1 ) + "\t " + TrackSearchVO( targetData.data.result[j] ).album.album_year_released + " - " + TrackSearchVO( targetData.data.result[j] ).artist.artist_name + " - " + TrackSearchVO( targetData.data.result[j] ).album.album_name + " - ALBUM: " + TrackSearchVO( targetData.data.result[j] ).track_name );
						}
						break;
				}
			} else if (event.type == SpotifyQueryResultEvent.LOOKUP_RESULT) {
				trace( "lookup result garble!" );
			}
		}
	}
}
