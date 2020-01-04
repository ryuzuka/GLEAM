package src.gleam.content {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	import src.gleam.content.favorite.Item;
	import src.Static;

	import ryuzuka.utils.RandomText;

	public class Favorite extends MovieClip {
		private var index : int = 2;
		private var item : Item;
		private var container : MovieClip;
		private var title : MovieClip;
		private var textBox : MovieClip;
		private var itemContainer : MovieClip;
		private var controller : MovieClip;
		private var arrArrow : Array = [];
		private var arrItem : Array = [];
		private var arrTf : Array = [];
		private var arrText : Array = [];
		private var arrRandomText : Array = [];
		private var xml : XML;
		private var itemTimer : Timer;
		private var urlLoader : URLLoader;
		private var randomText : RandomText;
		private var itemNum : int = 5;
		private var chkIndex : int;
		static private var _itemIndex : int = 0;

		public function Favorite() {
			if (stage == true) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
			}
		}

		private function addToStage(e : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			init();
		}

		private function initialize() : void {
			chkIndex = 0;
			itemIndex = 0;
			controller.alpha = 0;
			controller.visible = false;
			container.x = int((stage.stageWidth - 660) / 2);
			container.y = int((stage.stageHeight - 400) / 2);
		}

		private function init() : void {
			if (parent == stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			setInstance();
			setArray();
			setResize();
			setRandomText();
			setXML();

			initialize();
			intro();
			// setTest();
		}

		private function setInstance() : void {
			container = this.getChildByName("container_mc") as MovieClip;
			title = container.getChildByName("title_mc") as MovieClip;
			textBox = container.getChildByName("textBox_mc") as MovieClip;
			controller = container.getChildByName("controller_mc") as MovieClip;
			itemContainer = container.getChildByName("itemContainer_mc") as MovieClip;
		}

		private function setArray() : void {
			arrTf = [textBox["txt0"], textBox["txt1"], textBox["txt2"]];
			arrText = ["WHAT`S YOURS ", "FAVORITE", "SITE OF AMONG THESE?"];
			arrArrow = [controller["prev"], controller["next"]];
		}

		private function setResize() : void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function onResize(e : Event) : void {
			TweenMax.to(container, 1, {x:int((stage.stageWidth - 660) / 2), y:int((stage.stageHeight - container.height) / 2), ease:Quint.easeInOut});
		}

		private function setRandomText() : void {
			for (var i : int = 0; i < arrTf.length; i++) {
				randomText = new RandomText(arrTf[i], arrText[i], "en", 20);
				arrRandomText[i] = randomText;
			}
		}

		private function setXML() : void {
			if (Static.xml == null) {
				loadXML();
			} else {
				xml = new XML(Static.xml["favorite"]);
				setItem();
				setController();
			}
		}

		private function loadXML() : void {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeLoadXML);
			urlLoader.load(new URLRequest("xml/gleam.xml"));
		}

		private function completeLoadXML(e : Event) : void {
			urlLoader.removeEventListener(Event.COMPLETE, completeLoadXML);
			xml = new XML(XML(e.target["data"])["favorite"]);

			setItem();
			setController();
		}

		// --------- :: SET ITEM :: --------------------------------------------------------------------------------------------------------------
		private function setItem() : void {
			createItem();
			setItemTimer();
		}

		private function createItem() : void {
			var i : int;
			var j : int;
			for (i = 0; i < XMLList(xml["group"]).length(); i++) {
				arrItem[i] = [];
				for (j = 0; j < XMLList(xml["group"][i]["item"]).length(); j++) {
					item = new Item();
					arrItem[i][j] = item;
					Item(arrItem[i][j]).init(xml["group"][i]["item"][j], j);
				}
			}
		}

		private function removeItemListener() : void {
			var i : int;
			var j : int;
			for (i = 0; i < XMLList(xml["group"]).length(); i++) {
				for (j = 0; j < XMLList(xml["group"][i]["item"]).length(); j++) {
					Item(arrItem[i][j]).removeEventListener(MouseEvent.ROLL_OVER, itemMouseEvent);
					Item(arrItem[i][j]).removeEventListener(MouseEvent.ROLL_OUT, itemMouseEvent);
					Item(arrItem[i][j]).removeEventListener(MouseEvent.CLICK, itemMouseEvent);
				}
			}
			controller.removeEventListener(MouseEvent.CLICK, clickController);
		}

		private function addItemListener() : void {
			var i : int;
			var j : int;
			for (i = 0; i < XMLList(xml["group"]).length(); i++) {
				for (j = 0; j < XMLList(xml["group"][i]["item"]).length(); j++) {
					Item(arrItem[i][j]).addEventListener(MouseEvent.ROLL_OVER, itemMouseEvent);
					Item(arrItem[i][j]).addEventListener(MouseEvent.ROLL_OUT, itemMouseEvent);
					Item(arrItem[i][j]).addEventListener(MouseEvent.CLICK, itemMouseEvent);
				}
			}
			controller.addEventListener(MouseEvent.CLICK, clickController);
		}

		private function itemMouseEvent(e : MouseEvent) : void {
			var item : Item = e.currentTarget as Item;
			var chkNum : int = item.index;
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					itemContainer.addChild(item);
					item.popOn();
					itemOn(chkNum);
					itemTimer.stop();
					break;
				case MouseEvent.ROLL_OUT:
					item.popOff();
					itemTimer.start();
					break;
				case MouseEvent.CLICK:
					itemIndex = chkNum;
					break;
			}
		}

		private function setItemTimer() : void {
			itemTimer = new Timer(300, 1);
			itemTimer.addEventListener(TimerEvent.TIMER, itemTimerFunc);
		}

		private function itemTimerFunc(e : TimerEvent) : void {
			itemOn(itemIndex);
		}

		private function itemOn($chkNum : int) : void {
			var i : int;
			for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
				if (i == $chkNum) {
					Item(arrItem[chkIndex][i]).itemOn();
				} else {
					Item(arrItem[chkIndex][i]).itemOff();
				}
			}
		}

		// :: SET CONTROLLER :: --------------------------------------------------------------------------------------------------------------------
		private function setController() : void {
			controller.y = itemContainer.y + itemContainer.height + 20;
			controller.buttonMode = true;
			controller.addEventListener(MouseEvent.CLICK, clickController);
		}

		private function clickController(e : MouseEvent) : void {
			itemIndex = 0;
			itemOn(1000);
			removeItemListener();
			TweenMax.to(controller, 0.3, {alpha:0, ease:Expo.easeOut, onComplete:completeFunc});
			function completeFunc() : void {
				controller.visible = false;
				changeItem(e.target["name"]);
			}
		}

		// :: CHANGE ITEM :: ------------------------------------------------------------------------------------------------------------------------
		private function changeItem($type : String) : void {
			comeOutItem(chkIndex);

			TweenMax.to(this, 2.2, {alpha:1, onComplete:completeFunc});
			function completeFunc() : void {
				if ($type == "prev") {
					chkIndex--;
				} else if ($type == "next") {
					chkIndex++;
				}

				comeInItem(chkIndex);
				changeController();
				stage.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		// :: CHANGE CONTROLLER :: ---------------------------------------------------------------------------------------------------------------
		private function changeController() : void {
			if (XMLList(xml["group"]).length() == 1) {
				controller["alhpa"] = 0;
				controller.visible = false;
			} else {
				if (chkIndex == 0) {
					controller.gotoAndStop(1);
				} else if (chkIndex == XMLList(xml["group"]).length() - 1) {
					controller.gotoAndStop(3);
				} else {
					controller.gotoAndStop(2);
				}
				controller.y = itemContainer.y + itemContainer.height + 20;
				controller.visible = true;
				TweenMax.to(controller, 1, {alpha:1, ease:Expo.easeInOut, delay:1});
			}
		}

		// :: INTRO :: ------------------------------------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			TweenMax.to(title["msk0"], 0.8, {width:0, ease:Expo.easeInOut, delay:0.9});
			TweenMax.to(title["msk0"], 0.8, {x:3, ease:Expo.easeInOut, onComplete:completeFunc1});
			TweenMax.to(title["msk1"], 1, {x:3, ease:Expo.easeOut, delay:0.6});
			function completeFunc1() : void {
				RandomText(arrRandomText[0]).start();
				TweenMax.to(title, 0.38, {scaleX:1, onComplete:completeFunc2});
			}
			function completeFunc2() : void {
				comeInItem(chkIndex);

				RandomText(arrRandomText[1]).start();
				TweenMax.to(title, 0.28, {scaleX:1, onComplete:completeFunc3});
			}
			function completeFunc3() : void {
				changeController();
				RandomText(arrRandomText[2]).start();
			}
		}

		private function comeInItem($chkIndex : int) : void {
			var i : int;
			for (i = 0; i < arrItem[$chkIndex]["length"]; i++) {
				itemContainer.addChild(arrItem[$chkIndex][i]);
				Item(arrItem[$chkIndex][i]).initialize();
				arrItem[$chkIndex][i]["x"] = 131 * (i - int(i / itemNum) * itemNum);
				arrItem[$chkIndex][i]["y"] = 83 * int(i / itemNum);
			}
			for (i = 0; i < arrItem[$chkIndex]["length"]; i++) {
				TweenMax.to(arrItem[$chkIndex][i], 0, {alpha:1, delay:0.03 * i, onComplete:completeFunc1, onCompleteParams:[i]});
			}
			function completeFunc1($i : int) : void {
				Item(arrItem[$chkIndex][$i]).panelOn();
				TweenMax.to(arrItem[$chkIndex][$i], 0.3, {alpha:1, delay:0.03, onComplete:completeFunc2, onCompleteParams:[$i]});
			}
			function completeFunc2($i : int) : void {
				Item(arrItem[$chkIndex][$i]).lineOn();
				TweenMax.to(arrItem[$chkIndex][$i], 0.2, {alpha:1, delay:0.03, onComplete:completeFunc3, onCompleteParams:[$i]});
			}
			function completeFunc3($i : int) : void {
				Item(arrItem[$chkIndex][$i]).loadImg();
				Item(arrItem[$chkIndex][arrItem[$chkIndex]["length"] - 1]).addEventListener("COMPLETE_ITEM_ON", completeLoadImg);
			}
		}

		private function completeLoadImg(e : Event) : void {
			Static.isMenu = false;
			addItemListener();
		}

		// :: OUTRO :: ------------------------------------------------------------------------------------------------------------------------------------------
		public function outro() : void {
			TweenMax.killAll();
			TweenMax.to(controller, 0.5, {alpha:0, ease:Expo.easeInOut});
			TweenMax.to(title["msk0"], 0.8, {width:95, ease:Expo.easeInOut, onComplete:completeFunc});
			TweenMax.to(title["msk0"], 0.8, {x:98, ease:Expo.easeInOut, delay:0.7});
			TweenMax.to(title["msk1"], 0.8, {x:98, ease:Expo.easeInOut, delay:0.7});

			itemOn(1000);
			removeItemListener();
			comeOutItem(chkIndex);

			function completeFunc() : void {
				TweenMax.to(this, 0.6, {alpha:1, onComplete:completeFunc1});
				RandomText(arrRandomText[2]).start("backward");
				function completeFunc1() : void {
					TweenMax.to(this, 0.2, {alpha:1, onComplete:completeFunc2});
					RandomText(arrRandomText[1]).start("backward");
				}
				function completeFunc2() : void {
					RandomText(arrRandomText[0]).addEventListener("COMPLETE_RANDOM_TEXT", completeRandomText);
					RandomText(arrRandomText[0]).start("backward");
				}
			}
		}

		private function completeRandomText(e : Event) : void {
			RandomText(arrRandomText[0]).removeEventListener("COMPLETE_RANDOM_TEXT", completeRandomText);

			removeListener();
			Static.gleam.removeContent(index);
			if (Static.currentIndex == 100) {
				Static.gleam.intro();
			} else {
				Static.gleam.loadContent();
			}
		}

		private function comeOutItem($chkIndex : int) : void {
			var i : int;
			for (i = arrItem[$chkIndex]["length"] - 1; i >= 0; i--) {
				TweenMax.to(arrItem[$chkIndex][i], 0, {alpha:1, delay:0.6 - 0.03 * i, onComplete:completeFunc1, onCompleteParams:[i]});
			}
			function completeFunc1($i : int) : void {
				Item(arrItem[$chkIndex][$i]).imgOut();
				TweenMax.to(arrItem[$chkIndex][$i], 0, {alpha:1, delay:0.2 - 0.01 * i, onComplete:completeFunc2, onCompleteParams:[$i]});
			}
			function completeFunc2($i : int) : void {
				Item(arrItem[$chkIndex][$i]).lineOff();
				TweenMax.to(arrItem[$chkIndex][$i], 0, {alpha:1, delay:0.5 - 0.03 * i, onComplete:completeFunc3, onCompleteParams:[$i]});
			}
			function completeFunc3($i : int) : void {
				Item(arrItem[$chkIndex][$i]).panelOff();
				Item(arrItem[$chkIndex][0]).addEventListener("COMPLETE_PANEL_OFF", completePanelOff);
			}
			function completePanelOff(e : Event) : void {
				Item(arrItem[$chkIndex][0]).removeEventListener("COMPLETE_PANEL_OFF", completePanelOff);
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					itemContainer.removeChild(arrItem[$chkIndex][i]);
				}
			}
		}

		// :: REMOVE LISTENER :: -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function removeListener() : void {
			stage.removeEventListener(Event.RESIZE, onResize);
			itemTimer.removeEventListener(TimerEvent.TIMER, itemTimerFunc);
			itemTimer.stop();
		}

		private var isTest : Boolean = true;

		public function setTest() : void {
			stage.addEventListener(MouseEvent.CLICK, onClick);
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

		static public function get itemIndex() : int {
			return _itemIndex;
		}

		static public function set itemIndex(value : int) : void {
			_itemIndex = value;
		}
	}
}
