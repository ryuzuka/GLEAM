package src.gleam.music {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.events.Event;
	import flash.display.MovieClip;

	/**
	 * @author ryuzuka
	 */
	public class Equalizer extends MovieClip {
		public var bar0 : MovieClip;
		public var bar1 : MovieClip;
		public var bar2 : MovieClip;
		public var bar3 : MovieClip;
		public var bar4 : MovieClip;

		public function Equalizer() {
			if (stage) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private var arrBar : Array = [];

		public function init(e : Event = null) : void {
			bar0 = this.getChildByName("bar0") as MovieClip;
			bar1 = this.getChildByName("bar1") as MovieClip;
			bar2 = this.getChildByName("bar2") as MovieClip;
			bar3 = this.getChildByName("bar3") as MovieClip;
			bar4 = this.getChildByName("bar4") as MovieClip;

			arrBar = [bar0["stick"], bar1["stick"], bar2["stick"], bar3["stick"], bar4["stick"]];
		}

		private function equalizerEnter(e : Event) : void {
			var i : int;
			for (i = 0; i < arrBar.length; i++) {
				if (1 == int(Math.random() * 30)) {
					TweenMax.to(arrBar[i], 0.4, {scaleY:Math.random(), ease:Strong.easeOut});
				}
			}
		}

		public function toggleEqualizer($isPlay : Boolean) : void {
			for (var i : int = 0; i < arrBar.length; i++) {
				if ($isPlay == true) {
					MovieClip(arrBar[i]).addEventListener(Event.ENTER_FRAME, equalizerEnter);
				} else {
					MovieClip(arrBar[i]).removeEventListener(Event.ENTER_FRAME, equalizerEnter);
					TweenMax.to(arrBar[i], 1.5, {scaleY:0.1, ease:Strong.easeOut});
				}
			}
		}
	}
}
