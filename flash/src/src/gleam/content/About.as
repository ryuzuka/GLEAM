package src.gleam.content {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import src.Static;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author ...
	 */
	public class About extends MovieClip {
		private var randomText : RandomText;
		private var container : MovieClip;
		private var title : MovieClip;
		private var arrText : Array = [];
		private var arrTextField : Array = [];
		private var arrRandomText : Array = [];
		private var index : int = 0;

		public function About() {
			if (stage) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}

		private function addedToStage(e : Event) : void {
			init();
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function initialize() : void {
			container.x = stage.stageWidth / 2;
			container.y = (stage.stageHeight - container.height) / 2;
		}

		private function init() : void {
			setStage();
			setInstance();
			setArray();
			setResize();
			setRandomText();

			initialize();
			intro();
		}

		private function setStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function setInstance() : void {
			container = this.getChildByName("container_mc") as MovieClip;
			title = container.getChildByName("title") as MovieClip;
		}

		private function setArray() : void {
			arrTextField = [container["txt0"], container["txt1"], container["txt2"], container["txt3"], container["txt4"], container["txt5"], container["txt6"], container["txt7"]];
			arrText = ["RYUZUKA", "KIM SEUNG GWON", "MALE", "RH+ O", "1985 . 12 . 22", "ANYANG, KOREA", "010 . 8700 . 9469", "RYUZUKA @ NAVER.COM"];
		}

		private function setResize() : void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function onResize(e : Event) : void {
			TweenMax.to(container, 1, {x:int(stage.stageWidth / 2), y:int((stage.stageHeight - container.height) / 2), ease:Quint.easeInOut});
		}

		private function setRandomText() : void {
			var time : int = 40;
			for (var i : int = 0; i < arrTextField.length; i++) {
				randomText = new RandomText(arrTextField[i], arrText[i], "en", time);
				arrRandomText[i] = randomText;
			}
		}

		private function setOver() : void {
			MovieClip(container["btn"]).addEventListener(MouseEvent.ROLL_OVER, containerMouseEvent);
		}

		private function containerMouseEvent(e : MouseEvent) : void {
			for (var i : int = 0; i < arrRandomText.length; i++) {
				RandomText(arrRandomText[i]).start("all");
			}
		}

		public function intro() : void {
			trace("About : intro()");
			var i : int;
			step1();
			function step1() : void {
				TweenMax.to(title["msk0"], 0.8, {x:0, ease:Expo.easeInOut});
				TweenMax.to(title["msk1"], 0.9, {x:0, ease:Expo.easeOut, delay:0.6});
				TweenMax.to(title["msk0"], 0.8, {width:0, ease:Expo.easeInOut, delay:0.9});
				TweenMax.to(title["msk0"], 0.8, {y:MovieClip(title["msk0"]).y, onComplete:step2});
			}
			function step2() : void {
				for (i = 0; i < arrTextField.length; i++) {
					TweenMax.to(arrTextField[i], 0, {scaleX:1, delay:0.1 * i, onComplete:completeFunc1, onCompleteParams:[i]});
					TweenMax.to(this, 1.3, {alpha:1, onComplete:completeFunc2});
				}
				function completeFunc1($i : int) : void {
					RandomText(arrRandomText[$i]).start();
				}
				function completeFunc2() : void {
					Static.isMenu = false;
					setOver();
					for (i = 0; i < arrTextField.length; i++) {
						RandomText(arrRandomText[i]).start("all");
					}
				}
			}
		}

		public function outro() : void {
			var i : int;
			trace("About : outro()");
			TweenMax.killAll();
			for (i = 0; i < arrRandomText.length; i++) {
				RandomText(arrRandomText[i]).stop();
				RandomText(arrRandomText[i]).start("backward");
			}
			TweenMax.to(title["msk0"], 0.8, {width:254, ease:Expo.easeInOut});
			TweenMax.to(title["msk1"], 0.8, {x:254, ease:Expo.easeInOut, delay:0.8});
			TweenMax.to(title["msk0"], 0.8, {x:254, ease:Expo.easeInOut, delay:0.8, onComplete:completeOutro});
			MovieClip(container["btn"]).removeEventListener(MouseEvent.ROLL_OVER, containerMouseEvent);
		}

		private function completeOutro() : void {
			removeListener();
			Static.gleam.removeContent(index);
			if (Static.currentIndex == 100) {
				Static.gleam.intro();
			} else {
				Static.gleam.loadContent();
			}
		}

		private function removeListener() : void {
			stage.removeEventListener(Event.RESIZE, onResize);
		}
	}
}