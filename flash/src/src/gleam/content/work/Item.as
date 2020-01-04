package src.gleam.content.work {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;

	import src.gleam.content.Work;

	import ryuzuka.utils.CMLoading;
	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Item extends MovieClip {
		private var arrTf : Array = [];
		private var arrText : Array = [];
		private var arrRandomText : Array = [];
		private var arrColor : Array = [];
		private var txt0 : TextField;
		private var txt1 : TextField;
		private var txt2 : TextField;
		private var over : MovieClip;
		private var img : MovieClip;
		public var btn : MovieClip;
		private var msk : MovieClip;
		private var bg : MovieClip;
		private var loader : Loader;
		public var xml : XML;
		private var randomText : RandomText;
		private var loading : CMLoading;
		private var thumb : Bitmap = new Bitmap();
		private var isLoading : Boolean;
		public var isOn : Boolean;
		public var itemIndex : int;
		public var groupIndex : int;

		public function Item() {
		}

		public function initialize() : void {
			var i : int;
			msk.width = 74;
			msk.height = 46;
			thumb.alpha = 0;

			for (i = 0; i < arrRandomText.length; i++) {
				arrTf[i]["text"] = "";
			}

			TweenMax.to(over, 0, {tint:arrColor[Work.categoryIndex]});
		}

		public function init($xml : XML) : void {
			xml = $xml;

			setInstance();
			setArray();
			setRandomText();
			setMouseEvent();

			initialize();
		}

		private function setInstance() : void {
			txt0 = this.getChildByName("txt0_tf") as TextField;
			txt1 = this.getChildByName("txt1_tf") as TextField;
			txt2 = this.getChildByName("txt2_tf") as TextField;
			over = this.getChildByName("over_mc") as MovieClip;
			img = this.getChildByName("img_mc") as MovieClip;
			msk = this.getChildByName("mask_mc") as MovieClip;
			btn = this.getChildByName("btn_mc") as MovieClip;
			bg = this.getChildByName("bg_mc") as MovieClip;
		}

		private function setArray() : void {
			arrTf = [txt0, txt1, txt2];
			arrText = [String(xml["title"]), String(xml["date"]), String(xml["client"])];
			arrColor = ["0x4850DD", "0xBD0000", "0x629000"];
		}

		private function setRandomText() : void {
			for (var i : int = 0; i < arrText.length; i++) {
				randomText = new RandomText(arrTf[i], arrText[i], "en", 15);
				arrRandomText[i] = randomText;
			}
		}

		private function setMouseEvent() : void {
			btn.buttonMode = true;
			this.addEventListener(MouseEvent.ROLL_OVER, mouseEvent);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseEvent);
		}

		private function mouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					itemOn();
					break;
				case MouseEvent.ROLL_OUT:
					itemOff();
					break;
			}
		}

		public function getData() : void {
			if (isLoading == false) {
				loadImg();
			}
		}

		private function startLoading() : void {
			loading = new CMLoading(11, 5, 1, 4, 0x000000, 0.8, false);
			this.addChild(loading);
			loading.alpha = 0;
			loading.x = img.width / 2;
			loading.y = img.height / 2;
			loading.start();
			TweenMax.to(loading, 0.3, {alpha:1, ease:Quad.easeInOut});
		}

		private function stopLoading() : void {
			TweenMax.to(loading, 0.5, {alpha:0, ease:Quad.easeInOut, onComplete:completeLoading, delay:0.2});
		}

		private function completeLoading() : void {
			loading.stop();
			this.removeChild(loading);
			loading = null;
			loader = null;
		}

		private function loadImg() : void {
			startLoading();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(new URLRequest(xml["thumb"]));
		}

		private function loadComplete(e : Event) : void {
			stopLoading();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			thumb = e.currentTarget["content"];
			thumb.smoothing = true;
			thumb.alpha = 0;
			img.addChild(thumb);
			TweenMax.to(thumb, 0.5, {alpha:1, ease:Expo.easeInOut});

			itemOff();
			fillText();
		}

		private function fillText() : void {
			for (var i : int = 0; i < arrRandomText.length; i++) {
				arrRandomText[i] = new RandomText(arrTf[i], arrText[i], "en", 15);
				TweenMax.to(this, 0, {onComplete:completeFunc, onCompleteParams:[i], delay:0.1 * i});
			}
			function completeFunc($i : int) : void {
				RandomText(arrRandomText[$i]).start();
			}
		}

		public function itemOn() : void {
			TweenMax.to(msk, 0.15, {width:74, height:46});
			TweenMax.to(bg, 0.15, {tint:arrColor[Work.categoryIndex]});
		}

		public function itemOff() : void {
			TweenMax.to(msk, 0.6, {width:84, height:56, ease:Cubic.easeInOut});
			TweenMax.to(bg, 0.6, {tint:null, ease:Cubic.easeInOut});
		}
	}
}