package src.gleam.content {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.System;

	import src.Static;

	import ryuzuka.utils.RandomText;

	import src.gleam.content.contact.MailBox;

	import flash.net.navigateToURL;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Contact extends MovieClip {
		private var index : int = 4;
		private var arrT : Array = [];
		private var arrLink : Array = [];
		private var arrText : Array = [];
		private var arrLang : Array = [];
		private var arrRandomText : Array = [];
		private var title : MovieClip;
		private var ryuzuka : MovieClip;
		private var container : MovieClip;
		private var mailBox : MailBox;
		private var url : MovieClip;
		private var  randomText : RandomText;

		public function Contact() {
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
			var i : int;
			container.x = int((stage.stageWidth - 300) / 2);
			container.y = int((stage.stageHeight - 557) / 2);
			MovieClip(title["msk0"]).width = 0;
			MovieClip(title["msk1"]).width = 0;
			for (i = 0; i < arrT.length; i++) {
				arrT[i]["alpha"] = 0;
				randomText = new RandomText(arrT[i], arrText[i], arrLang[i], 0);
				randomText.start("all");
			}
			ryuzuka.alpha = 0;
			ryuzuka.y = 170;
			url.y = 260;
		}

		public function init() : void {
			System.useCodePage = true;

			setStage();
			setInstance();
			setArray();
			setResize();
			setRandomText();
			setRyuzuka();
			setLink();
			initialize();

			intro();
			// setTest();
		}

		private function setStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function setInstance() : void {
			container = this.getChildByName("container_mc") as MovieClip;
			title = container.getChildByName("title") as MovieClip;
			ryuzuka = container.getChildByName("ryuzuka") as MovieClip;
			url = container.getChildByName("url") as MovieClip;
			mailBox = container.getChildByName("mailBox") as MailBox;
		}

		private function setArray() : void {
			arrT = [container["txt0"], container["txt1"], container["txt2"], container["txt3"], container["txt4"], container["txt5"], container["txt6"], container["txt7"], container["txt8"], container["txt9"]];
			arrText = ["kim seung gwon", "t", "010 . 8700 . 9469", "e", "ryuzuka @ naver.com", "m", "ryuzuka @ nate.com", "F", "http://www.facebook.com/kimseunggwon", "ryuzuka"];
			arrLang = ["en", "en", "num", "en", "en", "en", "en", "en", "en", "en"];
			arrLink = [container["link0"], container["link1"]];
		}

		private function setResize() : void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function onResize(e : Event) : void {
			var containerX : int = int((stage.stageWidth - 300) / 2);
			var containerY : int = int((stage.stageHeight - 557) / 2);
			TweenMax.to(container, 1, {x:containerX, y:containerY, ease:Quint.easeInOut});
		}

		// --------------------------------------------------------------------------------------------------------------------------------------------
		private function setRandomText() : void {
			var time : int;
			for (var i : int = 0; i < arrText.length; i++) {
				time = 40 + i * 4;
				if (i == 8) {
					time = 20;
				}
				if (i == arrText.length - 1) {
					time = 100;
				}
				randomText = new RandomText(arrT[i], arrText[i], arrLang[i], time);
				arrRandomText[i] = randomText;
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------------------
		private function setRyuzuka() : void {
			ryuzuka.addEventListener(MouseEvent.ROLL_OVER, ryuzukaMouseEvent);
			ryuzuka.addEventListener(MouseEvent.ROLL_OUT, ryuzukaMouseEvent);
			ryuzuka.addEventListener(MouseEvent.CLICK, ryuzukaMouseEvent);
		}

		private function ryuzukaMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					for (var i : int = 0; i < arrRandomText.length; i++) {
						RandomText(arrRandomText[i]).start("all");
					}
					TweenMax.to(url, 0.1, {tint:0x4850DD});
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(url, 0.1, {tint:null});
					break;
				case MouseEvent.CLICK:
					// navigateToURL(new URLRequest("http://ryuzuka.cafe24.com"), "_blank");
					navigateToURL(new URLRequest("http://www.ryuzuka.com"), "_blank");
					break;
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------------------
		private function setLink() : void {
			for (var i : int = 0; i < arrLink.length; i++) {
				MovieClip(arrLink[i])["index"] = i;
				MovieClip(arrLink[i]).buttonMode = true;
				MovieClip(arrLink[i]).addEventListener(MouseEvent.CLICK, facebookMouseEvent);
				MovieClip(arrLink[i]).addEventListener(MouseEvent.ROLL_OVER, facebookMouseEvent);
				MovieClip(arrLink[i]).addEventListener(MouseEvent.ROLL_OUT, facebookMouseEvent);
			}
		}

		private function facebookMouseEvent(e : MouseEvent) : void {
			var chkNum : int = e.currentTarget["index"];
			switch(e.type) {
				case MouseEvent.CLICK:
					if (chkNum == 0) {
						navigateToURL(new URLRequest("http://www.facebook.com/kimseunggwon"), "_blank");
					} else if (chkNum == 1) {
						// navigateToURL(new URLRequest("http://ryuzuka.cafe24.com"), "_blank");
						navigateToURL(new URLRequest("http://www.ryuzuka.com"), "_blank");
					}
					break;
				case MouseEvent.ROLL_OVER:
					if (chkNum == 0) {
						TweenMax.to(arrT[7], 0.1, {tint:0x4850DD});
						TweenMax.to(arrT[8], 0.1, {tint:0x4850DD});
					} else if (chkNum == 1) {
						TweenMax.to(url, 0.1, {tint:0x4850DD});
					}
					break;
				case MouseEvent.ROLL_OUT:
					if (chkNum == 0) {
						TweenMax.to(arrT[7], 0.1, {tint:null});
						TweenMax.to(arrT[8], 0.1, {tint:null});
					} else if (chkNum == 1) {
						TweenMax.to(url, 0.1, {tint:null});
					}
					break;
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------------------
		// --------------------------------------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			trace("contact : intro()");
			var i : int;
			TweenMax.to(title["msk0"], 0.8, {width:218, ease:Expo.easeInOut});
			TweenMax.to(title["msk1"], 0.9, {width:218, ease:Expo.easeOut, delay:0.5});
			TweenMax.to(title["msk0"], 0.8, {x:218, ease:Expo.easeInOut, delay:0.6});
			for (i = 0; i < arrT.length; i++) {
				TweenMax.to(arrT[i], 0.9, {alpha:1, ease:Expo.easeInOut, delay:0.3 + 0.1 * i, onComplete:completeFunc, onCompleteParams:[i]});
			}
			function completeFunc($i : int) : void {
				RandomText(arrRandomText[$i]).start("all");
				if ($i == arrT.length - 7) {
					Static.isMenu = false;
					mailBox.intro();
					TweenMax.to(ryuzuka, 1, {y:225, ease:Bounce.easeOut});
					TweenMax.to(ryuzuka, 1, {alpha:1, ease:Expo.easeInOut});
					TweenMax.to(url, 0.3, {y:250, ease:Expo.easeInOut, delay:0.2});
				}
			}
		}

		// --------------------------------------------------------------------------------------------------------------------------------------------
		public function outro() : void {
			trace("contact : outro()");
			var i : int;
			for (i = 0; i < arrT.length; i++) {
				TweenMax.killTweensOf(arrT[i]);
			}

			mailBox.outro();
			mailBox.resetTextField();
			TweenMax.to(url, 0.3, {y:288, ease:Expo.easeInOut, delay:0.5});
			TweenMax.to(url, 1, {alpha:1, onComplete:completeFunc});
			function completeFunc() : void {
				for (i = 0; i < arrRandomText.length; i++) {
					RandomText(arrRandomText[i]).start("all");
				}
				TweenMax.to(title["msk0"], 0.8, {x:0, ease:Expo.easeInOut});
				TweenMax.to(title["msk1"], 0.8, {width:0, ease:Expo.easeInOut, delay:0.7});
				TweenMax.to(title["msk0"], 0.8, {width:0, ease:Expo.easeInOut, delay:0.7, onComplete:completeOutro});
			}
			TweenMax.to(ryuzuka, 0.6, {y:180, ease:Expo.easeInOut, delay:0.5});
			TweenMax.to(ryuzuka, 0.5, {alpha:0, delay:0.5, ease:Expo.easeOut});
			for (i = arrT.length - 1; i >= 0; i--) {
				TweenMax.to(arrT[i], 0.8, {alpha:0, ease:Expo.easeInOut, delay:0.3 + 0.1 * (arrT.length - 1 - i)});
			}
		}

		private function completeOutro() : void {
			System.useCodePage = false;
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

		// --------------------------------------------------------------------------------------------------------------------------------------------
		private var isTest : Boolean = true;

		public function setTest() : void {
			title.addEventListener(MouseEvent.CLICK, onClick);
			function onClick(e : MouseEvent) : void {
				if (isTest == false) {
					isTest = true;
					intro();
				} else {
					isTest = false;
					outro();
				}
			}
		}
	}
}