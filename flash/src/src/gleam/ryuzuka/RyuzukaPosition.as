package src.gleam.ryuzuka {
	import flash.display.MovieClip;

	import src.Static;

	import flash.events.Event;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class RyuzukaPosition extends MovieClip {
		public function RyuzukaPosition() {
		}

		static public function switchRyuzuka() : void {
			if (Static.currentIndex == 0) {
				Static.gleam.ryuzuka.dispatchEvent(new Event("SWITCH_ABOUT_POSITION"));
			} else {
				Static.gleam.ryuzuka.dispatchEvent(new Event("SWITCH_CENTER_POSITION"));
			}
		}
	}
}