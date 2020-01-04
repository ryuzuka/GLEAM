package src.gleam {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import src.Static;

	import ryuzuka.utils.RandomText;

	public class Index extends MovieClip {
		private var whiteTop : MovieClip;
		private var whiteBottom : MovieClip;
		private var black : MovieClip;
		private var title : MovieClip;
		private var line : MovieClip;
		private var arrWhite : Array = [];
		private var titleX : int;
		private var titleY : int;
		private var length : Number;
		private var step : String = "0";
		private var randomText : RandomText;

		public function Index() {
			if (stage) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}

		private function addedToStage(e : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}

		public function init() : void {
			setArray();
			setStage();
			intro();

			initialize();
		}

		private function setArray() : void {
			arrWhite = [whiteTop, whiteBottom];
		}

		private function initialize() : void {
			black.width = stage.stageWidth;
			black.height = stage.stageHeight;

			line.x = 0;
			MovieClip(line["line"]).alpha = 0;
			MovieClip(line).width = stage.stageWidth;
			MovieClip(line["progress"]).scaleX = 0;

			for (var i : int = 0; i < arrWhite.length; i++) {
				MovieClip(arrWhite[i]).y = stage.stageHeight / 2;
				MovieClip(arrWhite[i]).width = stage.stageWidth;
				MovieClip(arrWhite[i]).height = 0;
			}
		}

		private function setStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		// --------------------------------------------------------------------------------------------------------------------------------
		private function onResize(e : Event) : void {
			titleX = Math.round(stage.stageWidth / 2);
			titleY = Math.round(stage.stageHeight / 2);

			black.width = stage.stageWidth;
			black.height = stage.stageHeight;

			title.x = titleX;
			title.y = line.y = titleY;

			for (var i : int = 0; i < arrWhite.length; i++) {
				MovieClip(arrWhite[i]).y = stage.stageHeight / 2;
				MovieClip(arrWhite[i]).width = stage.stageWidth;
			}

			if (step == "0") {
				line.width = stage.stageWidth;
			}
			if (step == "1") {
				line.width = stage.stageWidth;
				TweenMax.to(line[".progress"], 0.5, {scaleX:length * 0.01, ease:Quint.easeOut, onComplete:coverWhite});
			}
			if (step == "2") {
				line.width = stage.stageWidth;
				TweenMax.to(arrWhite[0], 0.7, {height:stage.stageHeight / 2, ease:Expo.easeOut});
				TweenMax.to(arrWhite[1], 0.7, {height:stage.stageHeight / 2, ease:Expo.easeOut, onComplete:completeCoverWhite});
			}
			if (step == "3") {
				line.width = stage.stageWidth;
				return;
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			randomText = new RandomText(title["txt"], "GLEAM : A GLEAM OF HOPE", "en", 35);
			randomText.start("all");
			randomText.addEventListener("COMPLETE_RANDOM_TEXT", completeRandomText);
		}

		private function completeRandomText(e : Event) : void {
			loadRyuzukaAtGleam();
		}

		private function loadRyuzukaAtGleam() : void {
			randomText.removeEventListener("COMPLETE_RANDOM_TEXT", completeRandomText);
			MovieClip(line).x = 0;
			MovieClip(line["line"]).alpha = 0;
			if (parent != stage) {
				Static.gleam.loadRyuzuka();
			}
		}

		public function chkProcess($length : Number) : void {
			step = "1";
			length = $length;
			if ($length == 100) {
				TweenMax.to(line["progress"], 1, {scaleX:$length * 0.01, ease:Expo.easeInOut, onComplete:coverWhite});
			} else {
				TweenMax.to(line["progress"], 0.3, {scaleX:$length * 0.01, ease:Expo.easeInOut});
			}
		}

		public function coverWhite() : void {
			step = "2";
			TweenMax.to(arrWhite[0], 0.3, {height:stage.stageHeight / 2, ease:Expo.easeInOut, delay:0.5});
			TweenMax.to(arrWhite[1], 0.3, {height:stage.stageHeight / 2, ease:Expo.easeInOut, delay:0.49, onComplete:completeCoverWhite});
		}

		private function completeCoverWhite() : void {
			step = "3";
			Static.gleam.completeCoverWhite();
		}
	}
}












