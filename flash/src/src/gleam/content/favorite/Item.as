package src.gleam.content.favorite {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import src.gleam.content.Favorite;

	import ryuzuka.utils.CMLoading;

	import flash.net.navigateToURL;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Item extends MovieClip {
		private var xml : XML;
		private var loader : Loader;
		private var urq : URLRequest;
		private var loading : CMLoading;
		private var thumb : Bitmap;
		public var panel : MovieClip;
		public var msk : MovieClip;
		private var over : MovieClip;
		private var img : MovieClip;
		private var pop : MovieClip;
		private var arrLine : Array = [];
		public var index : int;

		public function Item() {
		}

		public function initialize() : void {
			panel.scaleX = 0;
			panel.scaleY = 0;
			if (index % 2 == 0) {
				panel.gotoAndStop(1);
			} else {
				panel.gotoAndStop(2);
			}
			MovieClip(panel["line1"]).scaleX = 0;
			MovieClip(panel["line0"]).scaleY = 0;
			over.alpha = 0;
			img.alpha = 0;
			msk.width = 128;
			msk.height = 80;
			pop.visible = false;
			pop.scaleX = 0;

			TweenMax.to(img, 0, {colorMatrixFilter:{saturation:1}, ease:Strong.easeOut});
		}

		public function init($xml : XML, $index : int) : void {
			xml = $xml;
			index = $index;
			setInstance();
			setArray();
			setPop();

			initialize();
		}

		private function setInstance() : void {
			panel = this.getChildByName("panel_mc") as MovieClip;
			over = this.getChildByName("over_mc") as MovieClip;
			msk = this.getChildByName("mask_mc") as MovieClip;
			img = this.getChildByName("img_mc") as MovieClip;
			pop = this.getChildByName("pop_mc") as MovieClip;
		}

		private function setArray() : void {
			arrLine = [panel["line0"], panel["line1"]];
		}

		public function loadImg() : void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadImg);
			urq = new URLRequest(xml["thumb"]);
			loader.load(urq);
			startLoading();
		}

		private function completeLoadImg(e : Event) : void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeLoadImg);
			loader = null;
			thumb = e.currentTarget["content"] as Bitmap;
			thumb.smoothing = true;
			thumb.x = -1 * thumb.width / 2;
			thumb.y = -1 * thumb.height / 2;
			img.addChild(thumb);
			stopLoading();
		}

		private function startLoading() : void {
			loading = new CMLoading(11, 5, 1, 4, 0x000000, 0.8, false);
			this.addChild(loading);
			loading.alpha = 0;
			loading.x = img.x;
			loading.y = img.y;
			loading.start();
			TweenMax.to(loading, 0.3, {alpha:1, ease:Quad.easeInOut});
		}

		public function stopLoading() : void {
			TweenMax.to(loading, 0.5, {alpha:0, ease:Quad.easeInOut, onComplete:completeLoading, delay:0.1});
		}

		private function completeLoading() : void {
			loading.stop();
			this.removeChild(loading);
			loading = null;

			imgOn();

			TweenMax.to(this, 1, {alpha:1, onComplete:completeFunc});
			function completeFunc() : void {
				if (index == Favorite.itemIndex) {
					itemOn();
				} else {
					itemOff();
				}
			}
		}

		private function imgOn() : void {
			TweenMax.to(img, 0.5, {alpha:1, ease:Quad.easeInOut, onComplete:completeImgOn});
		}

		private function completeImgOn() : void {
			over.alpha = 1;
			this.dispatchEvent(new Event("COMPLETE_ITEM_ON"));
		}

		public function imgOut() : void {
			over.alpha = 0;
			TweenMax.to(img, 0.5, {alpha:0, ease:Quad.easeInOut});
		}

		public function itemOn() : void {
			TweenMax.to(msk, 0.2, {width:116, height:68});
			// TweenMax.to(img, 0.2, {colorMatrixFilter:{saturation:1}});
		}

		public function itemOff() : void {
			TweenMax.to(msk, 1, {width:128, height:80, ease:Strong.easeOut});
			// TweenMax.to(img, 1, { colorMatrixFilter: { saturation:0 }, ease:Strong.easeOut } );
		}

		public function panelOn() : void {
			TweenMax.to(panel, 0.6, {scaleX:1, scaleY:1, ease:Quad.easeInOut});
		}

		public function panelOff() : void {
			TweenMax.to(panel, 0.6, {scaleX:0, scaleY:0, ease:Quad.easeInOut, onComplete:completePanelOff});
		}

		private function completePanelOff() : void {
			this.dispatchEvent(new Event("COMPLETE_PANEL_OFF"));
		}

		public function lineOn() : void {
			for (var i : int = 0; i < arrLine.length; i++) {
				TweenMax.to(arrLine[i], 0.6, {scaleX:1, scaleY:1, ease:Quad.easeInOut});
			}
		}

		public function lineOff() : void {
			for (var i : int = 0; i < arrLine.length; i++) {
				TweenMax.to(arrLine[i], 0.6, {scaleX:0, scaleY:0, ease:Quad.easeInOut});
			}
		}

		public function popOn() : void {
			pop.visible = true;
			pop.x = mouseX;
			pop.y = mouseY;
			pop.addEventListener(Event.ENTER_FRAME, popEnter);
			TweenMax.to(pop, 0.6, {scaleX:1, alpha:1, ease:Expo.easeOut});
		}

		public function popOff() : void {
			TweenMax.to(pop, 0.5, {scaleX:0, alpha:1, ease:Expo.easeInOut, onComplete:completeFunc});
			function completeFunc() : void {
				pop.removeEventListener(Event.ENTER_FRAME, popEnter);
				pop.visible = false;
			}
		}

		private function popEnter(e : Event) : void {
			var popX : int = int(mouseX);
			var popY : int = int(mouseY);

			if (popX < 10) popX = 10;
			if (popX > 118) popX = 118;

			if (popY < 40) popY = 40;
			if (popY > 73) popY = 73;

			TweenMax.to(pop, 0.8, {x:popX, y:popY});
		}

		private function setPop() : void {
			TextField(pop["url_txt"]).autoSize = TextFieldAutoSize.CENTER;
			TextField(pop["url_txt"]).text = xml["linkURL"];
			TextField(pop["title_txt"]).autoSize = TextFieldAutoSize.CENTER;
			TextField(pop["title_txt"]).text = xml["title"];
			MovieClip(pop["bg0"]).width = int(TextField(pop["url_txt"]).width / 2 + 3);
			MovieClip(pop["bg1"]).width = int(TextField(pop["url_txt"]).width / 2 + 3);
			MovieClip(pop["btn"]).width = int(TextField(pop["url_txt"]).width);
			MovieClip(pop["btn"]).buttonMode = true;
			MovieClip(pop["btn"]).addEventListener(MouseEvent.CLICK, popMouseEvent);
			MovieClip(pop["btn"]).addEventListener(MouseEvent.ROLL_OVER, popMouseEvent);
			MovieClip(pop["btn"]).addEventListener(MouseEvent.ROLL_OUT, popMouseEvent);
		}

		private function popMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.CLICK:
					navigateToURL(new URLRequest(xml["linkURL"]));
					popURLOff();
					break;
				case MouseEvent.ROLL_OVER:
					popURLOn();
					break;
				case MouseEvent.ROLL_OUT:
					popURLOff();
					break;
			}
		}

		private function popURLOn() : void {
			TweenMax.to(pop["url_txt"], 0, {tint:0XEC0000});
		}

		private function popURLOff() : void {
			TweenMax.to(pop["url_txt"], 0, {tint:null});
		}
	}
}