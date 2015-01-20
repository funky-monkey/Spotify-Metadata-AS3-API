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
package com.spotify.api.response {

	/**
	 * @author Sidney de Koning 
	 */
	final public class SpotifyHTTPResponse {
		
		public static const RESPONSE_200 : String = "200: The request was successfully processed.";
		public static const RESPONSE_304 : String = "304: The data hasn’t changed since your last request.";
		public static const RESPONSE_400 : String = "400: The request was not understood. Used for example when a required parameter was omitted.";
		public static const RESPONSE_403 : String = "403: The rate limiting has kicked in.";
		public static const RESPONSE_404 : String = "404: The requested resource was not found. Also used if a format is requested using the url and the format isn’t available.";
		public static const RESPONSE_406 : String = "406: The requested format isn’t available.";
		public static const RESPONSE_500 : String = "500: The server encountered an unexpected problem. Should not happen.";
		public static const RESPONSE_503 : String = "503: The API is temporarily unavailable.";
	}
}
