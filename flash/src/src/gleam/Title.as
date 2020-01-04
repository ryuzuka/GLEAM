package src.gleam {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import src.Static;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Title extends MovieClip {
		private var arrT : Array = [];
		private var arrS : Array = [];
		private var arrReverseT : Array = [];
		private var arrReverseS : Array = [];
		private var t : MovieClip;
		private var s : MovieClip;
		private var btn : MovieClip;
		private var cover : MovieClip;

		public function Title() {
		}

		public function init() : void {
			setInstance();
			setArray();
			initialize();
		}

		private function setInstance() : void {
			t = this.getChildByName("t_mc") as MovieClip;
			s = this.getChildByName("s_mc") as MovieClip;
			btn = this.getChildByName("btn_mc") as MovieClip;
			cover = this.getChildByName("cover_mc") as MovieClip;
		}

		private function setArray() : void {
			arrT = [t["t0"], t["t1"], t["t2"], t["t3"], t["t4"]];
			arrS = [s["s0"], s["s1"], s["s2"], s["s3"], s["s4"], s["s5"], s["s6"], s["s7"], s["s8"], s["s9"], s["s10"], s["s11"]];

			arrReverseT = [t["t4"], t["t3"], t["t2"], t["t1"], t["t0"]];
			arrReverseS = [s["s11"], s["s10"], s["s9"], s["s8"], s["s7"], s["s6"], s["s5"], s["s4"], s["s3"], s["s2"], s["s1"], s["s0"]];
		}

		private function initialize() : void {
			t.alpha = 0;
			s.alpha = 0;
			this.visible = false;
			cover.visible = false;
		}

		public function intro() : void {
			Static.gleam.addRyuzuka();
			this.visible = true;
			bounceTitle();
			TweenMax.to(this, 1.1, {scaleX:1, onComplete:completeFunc1});
		}

		private function completeFunc1() : void {
			crossOut();
			Static.gleam.menu.intro();
			TweenMax.to(this, 0.2, {scaleX:1, onComplete:completeFunc2});
		}

		private function completeFunc2() : void {
			setTitle();

			crossIn();
			this.dispatchEvent(new Event("COMPLETE_TITLE_INTRO"));
		}

		private function crossIn() : void {
			TweenMax.to(t, 0.4, {alpha:1, ease:Expo.easeOut});
			TweenMax.to(s, 0.4, {alpha:1, ease:Expo.easeOut});
			TweenMax.to(t, 0.4, {x:77, ease:Expo.easeOut});
			TweenMax.to(s, 0.4, {x:101, ease:Expo.easeOut});
		}

		private function crossOut() : void {
			TweenMax.to(t, 0.4, {alpha:0, ease:Expo.easeOut});
			TweenMax.to(s, 0.4, {alpha:0, ease:Expo.easeOut});
			TweenMax.to(t, 0.5, {x:225, ease:Expo.easeOut});
			TweenMax.to(s, 0.5, {x:-55, ease:Expo.easeOut});
		}

		public function jumpTitle() : void {
			var i : int;
			for (i = 0; i < arrT.length; i++) {
				TweenMax.to(arrT[i], 0.3, {y:-39, ease:Back.easeInOut, onComplete:completeFuncT});
			}
			function completeFuncT() : void {
				for (i = 0; i < arrT.length; i++) {
					if (i == 0) {
						TweenMax.to(arrT[i], 0.3, {y:-29, ease:Back.easeOut});
					} else {
						TweenMax.to(arrT[i], 0.3, {y:-26, ease:Back.easeOut});
					}
				}
			}
			for (i = 0; i < arrS.length; i++) {
				TweenMax.to(arrS[i], 0.16, {y:-16, ease:Quad.easeInOut, delay:0.04 * i, onComplete:completeFuncH, onCompleteParams:[i]});
			}
			function completeFuncH($i : int) : void {
				TweenMax.to(arrS[$i], 0.16, {y:-6, ease:Quad.easeInOut});
			}
		}

		private function bounceTitle() : void {
			t.y = -200;
			s.y = -200;
			t.rotation = 50;
			s.rotation = -30;
			TweenMax.to(t, 1, {alpha:1, y:29, rotation:0, ease:Bounce.easeOut, delay:0.2});
			TweenMax.to(s, 1, {alpha:1, y:45, rotation:0, ease:Bounce.easeOut, delay:0.3});
		}

		private function setTitle() : void {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, titleMouseEvent);
			this.addEventListener(MouseEvent.ROLL_OUT, titleMouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OVER, titleMouseEvent);
		}

		private function titleMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.CLICK:
					if (Static.isMenu == false) {
						// Static.isMenu = true;//<-----------------------------------------------------
						Static.gleam.clickTitle();
					}
					jumpTitle();
					break;
				case MouseEvent.ROLL_OVER:
					cover.visible = true;
					jumpTitle();
					break;
				case MouseEvent.ROLL_OUT:
					cover.visible = false;
					break;
			}
		}
	}
}