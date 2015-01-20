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
package com.spotify.api.events {
	import com.spotify.api.vo.result.SearchResultVO;
	import flash.events.Event;

	/**
	 * @author Sidney de Koning
	 */
	final public class SpotifyQueryResultEvent extends Event {

		public static const SEARCH_RESULT : String 	= "SpotifyQueryResultEvent.SEARCH_RESULT";
		public static const LOOKUP_RESULT : String 	= "SpotifyQueryResultEvent.LOOKUP_RESULT";

		private var _data : SearchResultVO;

		public function SpotifyQueryResultEvent(type : String, data : SearchResultVO, bubbles : Boolean = false, cancelable : Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		}

		public function get data() : SearchResultVO {
			return _data;
		}

		public function set data(value : SearchResultVO) : void {
			_data = value;
		}

		override public function clone() : Event {
			return new SpotifyQueryResultEvent(type, data, bubbles, cancelable);
		}

		override public function toString() : String {
			return formatToString("SpotifyQueryResultEvent", "type", "data", "bubbles", "cancelable");
		}
	}
}
