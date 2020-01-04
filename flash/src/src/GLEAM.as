package src {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	import src.gleam.ContentLoader;
	import src.gleam.Menu;
	import src.gleam.ryuzuka.RyuzukaPosition;
	import src.Static;
	import src.gleam.Title;

	import ryuzuka.utils.CMLoading;
	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author ...
	 */
	public class GLEAM extends MovieClip {
		private var xml : XML;
		private var loader : Loader;
		private var playerLoader : Loader;
		private var urlLoader : URLLoader = new URLLoader();
		private var loading : CMLoading = new CMLoading(11, 8, 2, 5, 0xBCBCBC, 0.8, false);
		public var ryuzuka : MovieClip;
		public var index : MovieClip;
		public var about : MovieClip;
		public var works : MovieClip;
		public var favorite : MovieClip;
		public var board : MovieClip;
		public var contact : MovieClip;
		public var title : Title;
		public var menu : Menu;
		public var gleam : MovieClip;
		public var footer : MovieClip;
		public var black : MovieClip;
		public var percent : MovieClip;
		public var contentContainer : MovieClip;
		public var ryuzukaContainer : MovieClip;
		private var playerContainer : MovieClip;
		public var contentLoader : ContentLoader = new ContentLoader();
		private var menuY : int;
		private var currentIndex : int;
		private var isResizeTitle : Boolean = true;
		public var arrContent : Array = [];

		public function GLEAM() {
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

		private function initialize() : void {
			Static.gleam = this;
			loading.alpha = 0;
			percent.alpha = 0;
			title.x = Math.round((stage.stageWidth - title.width) / 2);
			title.y = Math.round((stage.stageHeight - title.height) / 2);
			footer.visible = false;
			playerContainer.y = -27;
			MovieClip(footer["copyright"]).y = 42;
		}

		private function init() : void {
			setStage();
			setInstance();
			setArray();
			setResize();
			setTitle();
			setFooter();

			loadXml();
			loadIndex();

			setGleam();
			setGleamRandomText();
			// ------------------------------

			initialize();
		}

		private function setStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function setArray() : void {
			arrContent = [about, works, favorite, board, contact];
			arrGleamTextField = [gleam["txt0"], gleam["txt1"], gleam["txt2"], gleam["txt3"], gleam["txt4"], gleam["txt5"]];
			arrText = ["A GLEAM OF HOPE", "WELCOME TO RYUZUKA`S GLEAM", "DANMA RYUZI", "+", "EIKICHI ONIZUKA", "RYUZUKA"];
		}

		private function setInstance() : void {
			Static.currentIndex = 100;

			title = this.getChildByName("title") as Title;
			menu = this.getChildByName("menu") as Menu;
			gleam = this.getChildByName("gleam") as MovieClip;
			black = this.getChildByName("black") as MovieClip;
			percent = this.getChildByName("percent") as MovieClip;
			contentContainer = this.getChildByName("contentContainer") as MovieClip;
			ryuzukaContainer = this.getChildByName("ryuzukaContainer") as MovieClip;
			footer = this.getChildByName("footer") as MovieClip;
			playerContainer = footer.getChildByName("playerContainer") as MovieClip;
		}

		private function setResize() : void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function onResize(e : Event) : void {
			black.width = stage.stageWidth;
			black.height = stage.stageHeight;
			loading.x = stage.stageWidth / 2;
			loading.y = stage.stageHeight / 2;

			TweenMax.killChildTweensOf(percent);
			percent.x = stage.stageWidth / 2;
			percent.y = stage.stageHeight / 2 + 20;
			menuY = int(stage.stageHeight * (1 / 6));

			TweenMax.to(gleam, 1, {x:Math.round((stage.stageWidth - 160) / 2), y:Math.round((stage.stageHeight - 190) / 2), ease:Quint.easeInOut});

			if (menuY < 70) {
				menuY = 70;
			} else {
				TweenMax.to(menu, 0.9, {y:menuY, ease:Quint.easeInOut});
			}

			if (footer.y < 140) {
				footer.y = 140;
			} else {
				footer.y = stage.stageHeight - 32 - 5;
			}

			if (isResizeTitle == true) {
				title.x = Math.round((stage.stageWidth - title.width) / 2);
				title.y = Math.round((stage.stageHeight - title.height) / 2);
			}
		}

		// -------------------loadXml()---------------------------------------------------------------------------------------------------------------------------
		private function loadXml() : void {
			urlLoader.addEventListener(Event.COMPLETE, completeLoadXml);
			urlLoader.load(new URLRequest("xml/gleam.xml"));
		}

		private function completeLoadXml(e : Event) : void {
			urlLoader.removeEventListener(Event.COMPLETE, completeLoadXml);
			xml = new XML(e.target["data"]);
			Static.xml = xml;
			urlLoader = null;
		}

		// -------------------loadIndex()---------------------------------------------------------------------------------------------------------------------------
		private function loadIndex() : void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteIntro);
			loader.load(new URLRequest("index.swf"));
			startLoading();
		}

		private function loadCompleteIntro(e : Event) : void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteIntro);
			index = e.currentTarget["content"] as MovieClip;
			loader = null;
			TweenMax.to(loading, 0.9, {alpha:0, ease:Cubic.easeInOut, onComplete:completeIndexLoading});
		}

		private function completeIndexLoading() : void {
			this.removeChild(loading);
			loading.stop();
			contentContainer.addChild(index);
		}

		// -----------------loadRyuzuka()-----------------------------------------------------------------------------------------------------------------------------
		public function loadRyuzuka() : void {
			percent.visible = true;
			this.addChild(percent);
			percent.addEventListener(Event.ENTER_FRAME, percentEnter);
			TweenMax.to(percent, 0.5, {alpha:1, ease:Quad.easeInOut});
			TweenMax.to(this, 0.5, {alpha:1, onComplete:completeFunc});
			function completeFunc() : void {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadRyuzuka);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, chkProgress);
				loader.load(new URLRequest("ryuzuka.swf"));
			}
		}

		private function completeLoadRyuzuka(e : Event) : void {
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, chkProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeLoadRyuzuka);
			ryuzuka = e.currentTarget["content"] as MovieClip;
			loader = null;
		}

		private function chkProgress(e : ProgressEvent) : void {
			var length : Number = (e.bytesLoaded / e.bytesTotal) * 100;
			index["chkProcess"](length);
		}

		private function percentEnter(e : Event) : void {
			TextField(percent["txt"]).text = String(int(MovieClip(index["line"]["progress"]).scaleX * 100));
			if (TextField(percent["txt"]).text == "99") {
				TextField(percent["txt"]).text = "100";
			}
		}

		public function completeCoverWhite() : void {
			percent.removeEventListener(Event.ENTER_FRAME, percentEnter);
			percent.visible = false;
			black.visible = false;
			index.visible = false;
			index = null;

			Title(title).intro();
		}

		public function addRyuzuka() : void {
			ryuzukaContainer.addChildAt(ryuzuka, 0);
		}

		// -----------------setTitle()-----------------------------------------------------------------------------------------------------------------------------
		private function setTitle() : void {
			title.init();
			title.x = Math.round((stage.stageWidth - title.width) / 2);
			title.y = Math.round((stage.stageHeight - title.height) / 2);
			title.addEventListener("COMPLETE_TITLE_INTRO", completeTitleIntro);
		}

		private function completeTitleIntro(e : Event) : void {
			moveTitle();
			moveUpFooter();
			intro();
		}

		public function moveTitle() : void {
			isResizeTitle = false;
			title.x = 5;
			title.y = 3;
		}

		// -----------------setFooter()-----------------------------------------------------------------------------------------------------------------------------
		public function setFooter() : void {
			playerLoader = new Loader();
			playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadPlayer);
			playerLoader.load(new URLRequest("player.swf"));
		}

		private function completeLoadPlayer(e : Event) : void {
			playerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeLoadPlayer);
			playerContainer.addChild(e.currentTarget["content"]);
			MovieClip(e.currentTarget["content"]["player"]).dispatchEvent(new Event("COMPLETE_MOVE_UP_FOOTER"));

			playerLoader = null;
		}

		public function moveUpFooter() : void {
			footer.visible = true;
			TweenMax.to(playerContainer, 0.3, {y:0, ease:Expo.easeInOut, delay:0});
			TweenMax.to(footer["copyright"], 0.3, {y:22, ease:Expo.easeOut, delay:0.1});
		}

		// -------------------loadContent()----------------------------------------------------------------------------------------------------------------------
		public function loadContent() : void {
			trace("loadContent - Static.currentIndex : " + Static.currentIndex);
			Static.gleam.contentLoader.loadContent(Static.currentIndex);
		}

		// -------------------removeContent()------------------------------------------------------------------------------------------------------------------
		public function removeContent($removeIndex : int) : void {
			trace("GLEAM - removeContent : " + arrContent[$removeIndex]);
			contentContainer.removeChild(arrContent[$removeIndex]);
			arrContent[$removeIndex] = null;
		}

		// -------------------addContent()----------------------------------------------------------------------------------------------------------------------------
		public function addContent() : void {
			contentContainer.addChild(arrContent[Static.currentIndex]);
		}

		// -------------------switchRyuzuka()----------------------------------------------------------------------------------------------------------------------------
		public function switchRyuzuka() : void {
			RyuzukaPosition.switchRyuzuka();
		}

		// -------------------loading()----------------------------------------------------------------------------------------------------------------------------
		public function startLoading() : void {
			this.addChild(loading);
			loading.x = stage.stageWidth / 2;
			loading.y = stage.stageHeight / 2;
			loading.start();
			TweenMax.to(loading, 1, {alpha:1, ease:Strong.easeOut});
		}

		public function stopLoading() : void {
			TweenMax.to(loading, 1, {alpha:0, ease:Strong.easeOut, onComplete:completeLoading, delay:0.5});
			switchRyuzuka();
			addContent();
		}

		public function completeLoading() : void {
			loading.stop();
			this.removeChild(loading);
		}

		// -------------------setGleam()-------------------------------------------------------------------------------------------------------------------------
		private var randomText : RandomText;
		private var arrRandomText : Array = [];
		private var arrGleamTextField : Array = [];
		private var arrText : Array = [];

		private function setGleam() : void {
			gleam.visible = false;
			MovieClip(gleam["ryuzuka"]).y = 60;
			MovieClip(gleam["ryuzuka"]).alpha = 0;
			gleam.addEventListener(MouseEvent.ROLL_OVER, gleamMouseEvent);
		}

		private function gleamMouseEvent(e : MouseEvent) : void {
			rollingRandomText();
		}

		private function setGleamRandomText() : void {
			var time : int = 40;
			for (var i : int = 0; i < arrGleamTextField.length; i++) {
				TextField(arrGleamTextField[i]).alpha = 0;
				randomText = new RandomText(arrGleamTextField[i], arrText[i], "en", time);
				arrRandomText[i] = randomText;
			}
		}

		private function rollingRandomText() : void {
			for (var i : int = 0; i < arrRandomText.length; i++) {
				RandomText(arrRandomText[i]).start("all");
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------------------------------------------
		// :: intro ::
		public function intro() : void {
			var i : int;
			gleam.visible = true;

			switchRyuzuka();
			TweenMax.to(loading, 1, {alpha:0, ease:Strong.easeOut, delay:0.5});

			TweenMax.to(gleam["title"]["msk0"], 0.8, {x:2, ease:Expo.easeInOut});
			TweenMax.to(gleam["title"]["msk1"], 0.9, {x:2, ease:Expo.easeOut, delay:0.6});
			TweenMax.to(gleam["title"]["msk0"], 0.8, {width:0, ease:Expo.easeInOut, delay:0.9});

			for (i = 0; i < arrGleamTextField.length; i++) {
				TweenMax.to(TextField(arrGleamTextField[i]), 0, {scaleX:1, delay:0.5 + 0.1 * i, onComplete:completeFunc, onCompleteParams:[i]});
			}

			function completeFunc($i : int) : void {
				RandomText(arrRandomText[$i]).start("all");
				TweenMax.to(arrGleamTextField[$i], 1, {alpha:1, ease:Expo.easeInOut});
				if ($i == 2) {
					TweenMax.to(gleam["ryuzuka"], 1, {alpha:1, y:80, ease:Expo.easeInOut, onComplete:completeRandomText});
				}
			}
		}

		private function completeRandomText() : void {
			Static.isMenu = false;
			rollingRandomText();
		}

		// :: outro ::
		public function outro() : void {
			TweenMax.killAll();

			var i : int;
			for (i = arrGleamTextField.length - 1; i >= 0; i--) {
				RandomText(arrRandomText[i]).start("all");
				TweenMax.to(arrGleamTextField[i], 1, {alpha:0, ease:Expo.easeInOut, delay:0.1 * (5 - i)});
			}
			TweenMax.to(gleam["ryuzuka"], 0.5, {alpha:0, y:70, ease:Expo.easeInOut, delay:0.5});
			TweenMax.to(gleam["title"]["msk0"], 0.8, {width:88, ease:Expo.easeInOut});
			TweenMax.to(gleam["title"]["msk1"], 0.8, {x:90, ease:Expo.easeInOut, delay:0.8});
			TweenMax.to(gleam["title"]["msk0"], 0.8, {x:90, ease:Expo.easeInOut, delay:0.8, onComplete:completeOutro});
		}

		private function completeOutro() : void {
			gleam.visible = false;
			loadContent();
		}

		public function clickTitle() : void {
			if (Static.currentIndex == 100) {
				return;
			} else {
				arrContent[Static.currentIndex]["outro"]();
				Static.currentIndex = currentIndex = 100;
				menu.initializeMenu();
			}
		}
	}
}
















