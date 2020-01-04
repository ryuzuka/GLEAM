package src.gleam.content.work {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;

	import src.gleam.content.Work;

	import ryuzuka.utils.CMLoading;
	import ryuzuka.utils.RandomText;

	import flash.net.navigateToURL;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Info extends MovieClip {
		public var img : MovieClip;
		private var infoBox : MovieClip;
		private var launch : MovieClip;
		public var close : MovieClip;
		public var closeBtn : MovieClip;
		public var arrow0 : MovieClip;
		public var arrow1 : MovieClip;
		private var info : Bitmap;
		public var xml : XML;
		private var loader : Loader;
		private var urq : URLRequest = new URLRequest();
		private var randomText : RandomText;
		private var loading : CMLoading;
		public var arrTf : Array = [];
		private var arrText : Array = [];
		private var arrRandomText : Array = [];
		private var arrArrow : Array = [];
		private var isClear : Boolean;
		private var chkDirection : int;
		private var groupIndex : int;
		private var itemIndex : int;
		public var isChanging : Boolean;

		public function Info() {
		}

		public function initialize() : void {
			var i : int;
			close.alpha = 0;
			launch.alpha = 0;

			for (i = 0; i < arrArrow.length; i++) {
				MovieClip(arrArrow[i]).stop();
			}
		}

		public function init($xml : XML) : void {
			xml = $xml;

			setInstance();
			setArray();
			setLaunch();
			setArrow();

			initialize();
		}

		private function setInstance() : void {
			img = this.getChildByName("img_mc") as MovieClip;
			infoBox = this.getChildByName("info_mc") as MovieClip;
			close = this.getChildByName("close_mc") as MovieClip;
			closeBtn = this.getChildByName("closeBtn_mc") as MovieClip;
			launch = infoBox.getChildByName("launch_mc") as MovieClip;
			arrow0 = this.getChildByName("arrow0_mc") as MovieClip;
			arrow1 = this.getChildByName("arrow1_mc") as MovieClip;
		}

		private function setArray() : void {
			arrTf = [infoBox["txt0"], infoBox["txt1"], infoBox["txt2"]];
			arrArrow = [arrow0, arrow1];
		}

		private function setArrow() : void {
			for (var i : int = 0; i < arrArrow.length; i++) {
				arrArrow[i]["index"] = i;
				MovieClip(arrArrow[i]).buttonMode = true;
			}
		}

		public function addArrowListener() : void {
			for (var i : int = 0; i < arrArrow.length; i++) {
				MovieClip(arrArrow[i]).addEventListener(MouseEvent.ROLL_OVER, arrowMouseEvent);
				MovieClip(arrArrow[i]).addEventListener(MouseEvent.ROLL_OUT, arrowMouseEvent);
				MovieClip(arrArrow[i]).addEventListener(MouseEvent.CLICK, arrowMouseEvent);
			}
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelEvent);
		}

		public function removeArrowListener() : void {
			for (var i : int = 0; i < arrArrow.length; i++) {
				MovieClip(arrArrow[i]).removeEventListener(MouseEvent.ROLL_OVER, arrowMouseEvent);
				MovieClip(arrArrow[i]).removeEventListener(MouseEvent.ROLL_OUT, arrowMouseEvent);
				MovieClip(arrArrow[i]).removeEventListener(MouseEvent.CLICK, arrowMouseEvent);
			}
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelEvent);
		}

		private function setLaunch() : void {
			launch.buttonMode = true;
			launch.addEventListener(MouseEvent.CLICK, launchMouseEvent);
			launch.addEventListener(MouseEvent.ROLL_OVER, launchMouseEvent);
			launch.addEventListener(MouseEvent.ROLL_OUT, launchMouseEvent);
		}

		private function launchMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					TweenMax.to(e.currentTarget, 0, {tint:0xbd0000});
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(e.currentTarget, 0, {tint:null});
					break;
				case MouseEvent.CLICK:
					var linkTarget : String = xml["group"][groupIndex]["item"][itemIndex]["linkURL"].@linkTarget;
					var linkURL : String = xml["group"][groupIndex]["item"][itemIndex]["linkURL"];
					if ( linkTarget == "_blank") {
						navigateToURL(new URLRequest(linkURL), xml["group"][groupIndex]["item"][itemIndex]["linkURL"].@linkTarget);
					} else {
						if (ExternalInterface.available) ExternalInterface.call("openProject", String(linkTarget), String(linkURL));
					}
					break;
			}
		}

		private function wheelEvent(e : MouseEvent) : void {
			if (e.delta > 0) {
				MovieClip(arrArrow[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			} else {
				MovieClip(arrArrow[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		private function arrowMouseEvent(e : MouseEvent) : void {
			var arrow : MovieClip = e.currentTarget as MovieClip;
			var chkNum : int = e.currentTarget["index"];
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					TweenMax.to(arrow["arrow"], 0.2, {scaleX:0.7, scaleY:0.7});
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(arrow["arrow"], 0.3, {scaleX:0.8, scaleY:0.8});
					break;
				case MouseEvent.CLICK:
					if (isChanging == false) {
						if (XMLList(xml["group"][groupIndex]["item"]).length() != 1) {
							TweenMax.to(arrow["arrow"], 0.1, {scaleX:0.7, scaleY:0.7});
							TweenMax.to(arrow["arrow"], 0.3, {scaleX:0.8, scaleY:0.8, delay:0.1});

							chkDirection = chkNum;

							if (chkNum == 0) {
								itemIndex--;
								if (itemIndex < 0) {
									groupIndex--;
									if (groupIndex < 0) {
										groupIndex = XMLList(xml["group"]).length() - 1;
									}
									itemIndex = XMLList(xml["group"][groupIndex]["item"]).length() - 1;
									MovieClip(Work.arrArrow[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
								}
							} else {
								itemIndex++;
								if (itemIndex > XMLList(xml["group"][groupIndex]["item"]).length() - 1) {
									groupIndex++;
									itemIndex = 0;
									if (groupIndex > XMLList(xml["group"]).length() - 1) {
										groupIndex = 0;
									}
									MovieClip(Work.arrArrow[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
								}
							}
							isChanging = true;
							removeArrowListener();
							resetData(groupIndex, itemIndex);
						}
					}
					break;
			}
		}

		// :: INFO_ON :: --------------------------------------------------------------------
		public function infoOn($groupIndex : int, $itemIndex : int) : void {
			var i : int;
			isClear = false;
			loadImg($groupIndex, $itemIndex);
			TweenMax.to(close, 0.5, {alpha:1, ease:Expo.easeInOut, onComplete:completeFunc});
			for (i = 0; i < arrArrow.length; i++) {
				MovieClip(arrArrow[i]).gotoAndPlay(2);
			}
			function completeFunc() : void {
				close.gotoAndPlay(2);
			}
		}

		// :: RESET_DATA :: --------------------------------------------------------------------
		public function resetData($groupIndex : int, $itemIndex : int) : void {
			TweenMax.to(arrTf[0], 0.3, {alpha:0, ease:Quad.easeInOut});
			TweenMax.to(arrTf[1], 0.3, {alpha:0, ease:Quad.easeInOut});
			TweenMax.to(arrTf[2], 0.3, {alpha:0, ease:Quad.easeInOut});

			TweenMax.to(info, 0.3, {alpha:0, ease:Quad.easeInOut, onComplete:function() : void {
				arrTf[0]["text"] = "";
				arrTf[1]["text"] = "";
				arrTf[2]["text"] = "";

				img.removeChild(info);
				info = null;
				loadImg($groupIndex, $itemIndex);
			}});
		}

		private function loadImg($groupIndex : int, $itemIndex : int) : void {
			groupIndex = $groupIndex;
			itemIndex = $itemIndex;

			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoad);
			urq.url = xml["group"][$groupIndex]["item"][$itemIndex]["info"];
			loader.load(urq);
			startLoading();
		}

		private function completeLoad(e : Event) : void {
			loader.contentLoaderInfo.removeEventListener(Event.SOUND_COMPLETE, completeLoad);
			loader = null;
			stopLoading();
			info = e.currentTarget["content"];
			info.smoothing = true;
			info.alpha = 0;
			img.addChild(info);
			startRandomText();

			TweenMax.to(info, 1, {alpha:1, ease:Expo.easeInOut});
			TweenMax.to(infoBox, 1, {alpha:1, ease:Expo.easeInOut});
			TweenMax.to(launch, 0.5, {alpha:1, ease:Expo.easeOut, onComplete:function() : void {
				addArrowListener();
				isChanging = false;
			}});
		}

		private function startRandomText() : void {
			arrText = [xml["group"][groupIndex]["item"][itemIndex]["title"], xml["group"][groupIndex]["item"][itemIndex]["date"], xml["group"][groupIndex]["item"][itemIndex]["client"]];
			for (var i : int = 0; i < arrTf.length; i++) {
				arrTf[i]["alpha"] = 1;
				randomText = new RandomText(arrTf[i], arrText[i], "en", 20);
				arrRandomText[i] = randomText;
				RandomText(arrRandomText[i]).start();
			}
		}

		public function clear() : void {
			var i : int;
			if (isClear == false) {
				isClear = true;
				loader = null;
				img.removeChild(info);
				info = null;
				close.alpha = 0;
				launch.alpha = 0;
				for (i = 0; i < arrTf.length; i++) {
					RandomText(arrRandomText[i]).stop();
					arrRandomText[i] = null;
					arrTf[i]["text"] = "";
				}
			}
			for (i = 0; i < arrArrow.length; i++) {
				MovieClip(arrArrow[i]).gotoAndStop(1);
			}
		}

		private function startLoading() : void {
			loading = new CMLoading(11, 6, 1.5, 4, 0xBCBCBC, 0.6, false);
			img.addChild(loading);
			loading.alpha = 0;
			loading.x = img.width / 2;
			loading.y = img.height / 2;
			loading.start();
			TweenMax.to(loading, 0.2, {alpha:0.8, ease:Quad.easeOut});
		}

		private function stopLoading() : void {
			TweenMax.to(loading, 0.6, {alpha:0, ease:Quad.easeInOut, onComplete:completeLoading, delay:0.2});
		}

		private function completeLoading() : void {
			img.removeChild(loading);
			loading.stop();
			loading = null;
		}
	}
}