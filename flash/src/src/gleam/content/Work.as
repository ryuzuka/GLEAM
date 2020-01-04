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

	import src.gleam.content.work.Info;
	import src.gleam.content.work.Item;
	import src.Static;

	import ryuzuka.utils.RandomText;

	public class Work extends MovieClip {
		private var index : int = 1;
		private var chkIndex : int;
		static private var _categoryIndex : int = 0;
		static private var _groupIndex : int = 100;
		static private var _itemIndex : int = 100;
		static private var _arrArrow : Array = [];
		private var arrCategory : Array = [];
		private var arrItem : Array = [];
		private var arrItemY : Array = [];
		private var arrTitle : Array = [];
		private var arrRandomText : Array = [];
		private var arrCategoryRandomText : Array = [];
		private var arrCategoryString : Array = [];
		private var arrColor : Array = [];
		private var info : Info;
		private var item : Item;
		private var randomText : RandomText;
		private var categoryTimer : Timer;
		private var black : MovieClip;
		private var container : MovieClip;
		private var itemContainer : MovieClip;
		private var title : MovieClip;
		private var arrow0 : MovieClip;
		private var arrow1 : MovieClip;
		private var category0 : MovieClip;
		private var category1 : MovieClip;
		private var category2 : MovieClip;
		private var urlLoader : URLLoader;
		private var xml : XML;
		private var isBlackOff : Boolean = true;
		static private var _isBlack : Boolean;
		static private var _isMoving : Boolean;
		static private var _isInfo : Boolean;
		private var chkDirection : String = "down";
		static private var _work : Work;

		public function Work() {
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

		public function initialize() : void {
			black.alpha = 0;
			black.visible = false;
			info.alpha = 0;
			info.visible = false;

			MovieClip(arrArrow[0]).visible = false;
			MovieClip(arrArrow[1]).visible = false;

			MovieClip(arrCategory[0]).x = 119;
			MovieClip(arrCategory[1]).x = 119;
			MovieClip(arrCategory[2]).x = 119;

			MovieClip(title["mouse"]).y = 60;
			MovieClip(title["mouse"]).alpha = 0;
			TweenMax.to(title, 0, {x:int(stage.stageWidth - 141) / 2, y:int(stage.stageHeight - 51) / 2});
		}

		private function init() : void {
			setStage();
			setInstance();
			setArray();
			setRandomText();
			setXML();

			initialize();
		}

		private function setStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function setInstance() : void {
			work = this;

			title = this.getChildByName("title_mc") as MovieClip;
			info = this.getChildByName("info_mc") as Info;
			black = this.getChildByName("black_mc") as MovieClip;
			container = this.getChildByName("container_mc") as MovieClip;
			itemContainer = container.getChildByName("itemContainer_mc") as MovieClip;
			arrow0 = container.getChildByName("arrow0_mc") as MovieClip;
			arrow1 = container.getChildByName("arrow1_mc") as MovieClip;
			category0 = container.getChildByName("category0_mc") as MovieClip;
			category1 = container.getChildByName("category1_mc") as MovieClip;
			category2 = container.getChildByName("category2_mc") as MovieClip;
		}

		private function setArray() : void {
			arrTitle = ["THESE ARE MY WORKS.", "IT`S ONLY MADE IN", "RYUZUKA.", "- MOUSE WHEEL -"];
			arrItemY = [0, 63, 126, 189, 252, 315];
			arrArrow = [arrow0, arrow1];
			arrCategory = [category0, category1, category2];
			arrColor = ["0x4850DD", "0xBD0000", "0x629000"];
			arrCategoryString = ["PROJECT : FLASH", "PROPOSAL : FLASH", "JAVASCRIPT / HTML"];
		}

		private function setResize() : void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function onResize(e : Event) : void {
			var titleX : int = (stage.stageWidth - 141) / 2;
			var titleY : int = (stage.stageHeight - 51) / 2;
			TweenMax.to(title, 1, {x:titleX, y:titleY, ease:Quint.easeInOut});

			container.x = stage.stageWidth - 245;
			TweenMax.to(container, 1, {y:int((stage.stageHeight - XMLList(xml["category"][categoryIndex]["group"][chkIndex]["item"]).length() * 63 + 20) / 2), ease:Quint.easeInOut});
			MovieClip(arrArrow[1]).y = XMLList(xml["category"][categoryIndex]["group"][chkIndex]["item"]).length() * 63 + 40;

			black.width = stage.stageWidth;
			black.height = stage.stageHeight;
			var infoX : int = int(stage.stageWidth / 2);
			var infoY : int = int(stage.stageHeight / 2);
			TweenMax.to(info, 1, {x:infoX, y:infoY, ease:Quint.easeInOut});
		}

		private function setRandomText() : void {
			for (var i : int = 0; i < arrTitle.length; i++) {
				randomText = new RandomText(title["txt" + i], arrTitle[i], "en", 30);
				arrRandomText[i] = randomText;
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		private function setXML() : void {
			if (Static.xml == null) {
				loadXML();
			} else {
				xml = new XML(Static.xml["work"]);
				setResize();
				setItem();
				setInfo();
				setArrow();
				setWheel();
				setCategory();

				intro();
			}
		}

		private function loadXML() : void {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeLoadXML);
			urlLoader.load(new URLRequest("xml/gleam.xml"));
		}

		private function completeLoadXML(e : Event) : void {
			stage.dispatchEvent(new Event(Event.RESIZE));
			urlLoader.removeEventListener(Event.COMPLETE, completeLoadXML);
			xml = new XML(XML(e.target["data"])["work"]);

			setResize();
			setItem();
			setInfo();
			setArrow();
			setWheel();
			setCategory();

			intro();
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		 private function setItem() : void {
			var i : int;
			var j : int;

			for (i = 0; i < XMLList(xml["category"][categoryIndex]["group"]).length(); i++) {
				arrItem[i] = [];
				for (j = 0; j < XMLList(xml["category"][categoryIndex]["group"][i]["item"]).length(); j++) {
					item = new Item();
					arrItem[i][j] = item;
					Item(arrItem[i][j]).init(xml["category"][categoryIndex]["group"][i]["item"][j]);
					Item(arrItem[i][j]).groupIndex = i;
					Item(arrItem[i][j]).itemIndex = j;
					Item(arrItem[i][j]).btn["groupIndex"] = i;
					Item(arrItem[i][j]).btn["itemIndex"] = j;
					Item(arrItem[i][j]).btn.addEventListener(MouseEvent.CLICK, clickItem);
				}
			}
		}

		private function clickItem(e : MouseEvent) : void {
			var btn : MovieClip = e.currentTarget as MovieClip;
			if (btn["itemIndex"] != itemIndex) {
				if (info.isChanging == false) {
					if (isBlackOff == true) {
						info.isChanging = true;
						groupIndex = btn["groupIndex"];
						itemIndex = btn["itemIndex"];
						selectItem(groupIndex, itemIndex);
						removeWheelListener();
					}
				}
			}
		}

		private function selectItem($groupIndex : int, $itemIndex : int) : void {
			if (Work.isBlack) {
				info.resetData($groupIndex, $itemIndex);
			} else {
				infoOn();
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		private function setInfo() : void {
			info.init(xml["category"][categoryIndex]);
			info.closeBtn.buttonMode = true;

			info.closeBtn.addEventListener(MouseEvent.ROLL_OVER, infoCloseMouseEvent);
			info.closeBtn.addEventListener(MouseEvent.ROLL_OUT, infoCloseMouseEvent);
			info.closeBtn.addEventListener(MouseEvent.CLICK, infoCloseMouseEvent);

			black.addEventListener(MouseEvent.ROLL_OVER, infoCloseMouseEvent);
			black.addEventListener(MouseEvent.ROLL_OUT, infoCloseMouseEvent);
			black.addEventListener(MouseEvent.CLICK, infoCloseMouseEvent);
		}

		private function infoCloseMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					info.close.gotoAndPlay(2);
					TweenMax.to(info.close, 0.3, {tint:0xbd0000});
					break;
				case MouseEvent.ROLL_OUT:
					info.close.gotoAndPlay(21);
					TweenMax.to(info.close, 0.3, {tint:null});
					break;
				case MouseEvent.CLICK:
					if (isBlack) {
						if (info.isChanging == false) {
							info.close.gotoAndPlay(21);
							infoOff();
						}
					}
					break;
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		private function infoOn() : void {
			removeCategoryListener();
			blackOn();
			Work.isInfo = true;
			info.visible = true;
			TweenMax.to(info, 0.5, {alpha:1, ease:Expo.easeInOut, delay:0.2, onComplete:completeFunc});
			function completeFunc() : void {
				info.infoOn(groupIndex, itemIndex);
			}
		}

		private function blackOn() : void {
			Work.isBlack = true;
			black.visible = true;
			TweenMax.to(black, 0.6, {alpha:1, ease:Expo.easeInOut});
		}

		private function infoOff() : void {
			blackOff();
			TweenMax.to(info, 0.5, {alpha:0, ease:Expo.easeInOut});
		}

		private function blackOff() : void {
			info.removeArrowListener();
			isBlackOff = false;
			info.arrow0.gotoAndPlay(21);
			info.arrow1.gotoAndPlay(21);
			TweenMax.to(black, 0.5, {alpha:0, ease:Expo.easeInOut, onComplete:completeFunc, delay:0.2});
			function completeFunc() : void {
				itemIndex = 100;
				isBlackOff = true;
				Work.isBlack = false;
				Work.isInfo = false;
				isBlack = false;
				black.visible = false;
				info.visible = false;
				info.clear();
				addWheelListener();
				addCategoryListener();
			}
		}

		// :: SET_WHEEL :: -------------------------------------------------------------------------------------------------------------------------------------
		private function setWheel() : void {
			addWheelListener();
		}

		private function addWheelListener() : void {
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}

		private function removeWheelListener() : void {
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}

		private function onWheel(e : MouseEvent) : void {
			rollingRandomText();
			if (e.delta > 0) {
				MovieClip(arrArrow[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			} else {
				MovieClip(arrArrow[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		private function rollingRandomText() : void {
			for (var i : int = 0; i < arrRandomText.length; i++) {
				RandomText(arrRandomText[i]).start("all");
			}
		}

		// :: SET_ARROW :: -------------------------------------------------------------------------------------------------------------------------------------
		private function setArrow() : void {
			for (var i : int = 0; i < arrArrow.length; i++) {
				MovieClip(arrArrow[i])["index"] = i;
				MovieClip(arrArrow[i]).buttonMode = true;
				MovieClip(arrArrow[i]).addEventListener(MouseEvent.CLICK, clickArrow);
				MovieClip(arrArrow[i]).addEventListener(MouseEvent.ROLL_OVER, arrowMouseEvent);
				MovieClip(arrArrow[i]).addEventListener(MouseEvent.ROLL_OUT, arrowMouseEvent);
			}
		}

		private function arrowMouseEvent(e : MouseEvent) : void {
			var arrow : MovieClip = e.currentTarget as MovieClip;
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					TweenMax.to(arrow, 0.2, {scaleX:0.8, scaleY:0.8});
					TweenMax.to(arrow, 0.2, {tint:arrColor[categoryIndex]});
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(arrow, 0.3, {scaleX:1, scaleY:1});
					TweenMax.to(arrow, 0.3, {tint:null});
					break;
			}
		}

		private function clickArrow(e : MouseEvent) : void {
			var chkNum : int = e.currentTarget["index"];
			if (XMLList(xml["category"][categoryIndex]["group"]).length() != 1) {
				if (isMoving == false) {
					isMoving = true;
					if (chkNum == 0) {
						chkDirection = "up";
						leaveItem(chkNum);
						chkIndex--;
						if (chkIndex < 0) {
							chkIndex = XMLList(xml["category"][categoryIndex]["group"]).length() - 1;
						}
						enterItem(chkNum);
					} else if (chkNum == 1) {
						chkDirection = "down";
						leaveItem(chkNum);
						chkIndex++;
						if (chkIndex > XMLList(xml["category"][categoryIndex]["group"]).length() - 1) {
							chkIndex = 0;
						}
						enterItem(chkNum);
					}
				}
			}
		}

		private function arrowOn($type : String) : void {
			var i : int;
			if ($type == "on") {
				for (i = 0; i < 2; i++) {
					MovieClip(arrArrow[i]).visible = true;
					MovieClip(arrArrow[i]).gotoAndPlay(2);
					TweenMax.to(arrArrow[i], 0.3, {alpha:1, ease:Expo.easeInOut});
				}
				TweenMax.to(this, 1, {onComplete:function() : void {
					trace("isMoving : " + isMoving);
					isMoving = false;
				}});
			} else if ($type == "off") {
				for (i = 0; i < 2; i++) {
					MovieClip(arrArrow[i]).gotoAndPlay(21);
					TweenMax.to(arrArrow[i], 0.3, {alpha:0, ease:Expo.easeInOut});
				}
				TweenMax.to(this, 0.3, {ease:Expo.easeInOut, onComplete:function() : void {
					MovieClip(arrArrow[0]).visible = false;
					MovieClip(arrArrow[1]).visible = false;
				}});
			}
		}

		// :: SET_CATEGORY :: -------------------------------------------------------------------------------------------------------------------------------------
		private function setCategory() : void {
			var i : int;
			for (i = 0; i < arrCategory.length; i++) {
				arrCategoryRandomText[i] = new RandomText(arrCategory[i]["txt"], arrCategoryString[i], "en", 30);
				arrCategory[i]["index"] = i;
				arrCategory[i]["txt"]["text"] = arrCategoryString[i];
				arrCategory[i]["txt"]["mouseEnabled"] = false;
			}
			addCategoryListener();

			categoryTimer = new Timer(300, 1);
			categoryTimer.addEventListener(TimerEvent.TIMER, categoryTimerFunc);
		}

		private function addCategoryListener() : void {
			var i : int;
			for (i = 0; i < arrCategory.length; i++) {
				MovieClip(arrCategory[i]).buttonMode = true;
				MovieClip(arrCategory[i]).addEventListener(MouseEvent.ROLL_OVER, categoryMouseEvent);
				MovieClip(arrCategory[i]).addEventListener(MouseEvent.ROLL_OUT, categoryMouseEvent);
				MovieClip(arrCategory[i]).addEventListener(MouseEvent.CLICK, categoryMouseEvent);
			}
		}

		private function removeCategoryListener() : void {
			var i : int;
			for (i = 0; i < arrCategory.length; i++) {
				MovieClip(arrCategory[i]).buttonMode = false;
				// MovieClip(arrCategory[i]).removeEventListener(MouseEvent.ROLL_OVER, categoryMouseEvent);
				// MovieClip(arrCategory[i]).removeEventListener(MouseEvent.ROLL_OUT, categoryMouseEvent);
				// MovieClip(arrCategory[i]).removeEventListener(MouseEvent.CLICK, categoryMouseEvent);
			}
		}

		private function categoryTimerFunc(e : TimerEvent) : void {
			categoryOn(categoryIndex);
		}

		private function categoryMouseEvent(e : MouseEvent) : void {
			var chkNum : int = e.currentTarget["index"];
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					categoryTimer.stop();
					categoryOn(chkNum);
					break;
				case MouseEvent.ROLL_OUT:
					if (chkNum != categoryIndex) categoryTimer.start();
					break;
				case MouseEvent.CLICK:
					if (Work.isBlack == false) {
						if (chkNum != categoryIndex) {
							TweenMax.to(arrCategory[0], 0.6, {x:119, ease:Expo.easeInOut, delay:0.2});
							TweenMax.to(arrCategory[1], 0.6, {x:119, ease:Expo.easeInOut, delay:0.1});
							TweenMax.to(arrCategory[2], 0.6, {x:119, ease:Expo.easeInOut});

							categoryIndex = chkNum;
							RandomText(arrCategoryRandomText[chkNum]).start("all");
							categoryOn(categoryIndex);
							clearContainer(chkNum);
							TweenMax.to(this, 2.1, {onComplete:function() : void {
								TweenMax.to(arrCategory[0], 0.9, {x:-2, ease:Expo.easeInOut});
								TweenMax.to(arrCategory[1], 0.9, {x:-2, ease:Expo.easeInOut, delay:0.1});
								TweenMax.to(arrCategory[2], 0.9, {x:-2, ease:Expo.easeInOut, delay:0.2});
							}});
						}
					} else {
						black.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
					break;
			}
		}

		private function categoryOn($chkNum : int) : void {
			for (var i : int = 0; i < arrCategory.length; i++) {
				if (i == $chkNum) {
					RandomText(arrCategoryRandomText[i]).start("all");
					TweenMax.to(arrCategory[i]["txt"], 0.2, {tint:arrColor[i]});
					TweenMax.to(arrCategory[i]["bg"], 0.2, {tint:arrColor[i]});
				} else {
					TweenMax.to(arrCategory[i]["txt"], 0.3, {tint:null, ease:Expo.easeInOut});
					TweenMax.to(arrCategory[i]["bg"], 0.2, {tint:null, ease:Expo.easeInOut});
				}
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		private function leaveItem($chkNum : int = 1) : void {
			var i : int;
			arrowOn("off");

			if ($chkNum == 0) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					TweenMax.to(arrItem[chkIndex][i], 1, {y:stage.stageHeight + 50, ease:Expo.easeInOut, delay:0.25 - 0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			} else if ($chkNum == 1) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					TweenMax.to(arrItem[chkIndex][i], 1, {y:0 - container.y - 60 - 50, ease:Expo.easeInOut, delay:0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			}
			function completeFunc($item : Item) : void {
				$item.x = 300;
				Item($item).initialize();
			}
		}

		private function enterItem($chkNum : int = 1) : void {
			var i : int;

			if ($chkNum == 0) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					itemContainer.addChild(arrItem[chkIndex][i]);
					arrItem[chkIndex][i]["x"] = 0;
					arrItem[chkIndex][i]["y"] = 0 - container.y - 60 - 50;
					TweenMax.to(arrItem[chkIndex][i], 1, {y:arrItemY[i], ease:Expo.easeInOut, delay:0.1 + 0.25 - 0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			} else if ($chkNum == 1 || $chkNum == 2) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					itemContainer.addChild(arrItem[chkIndex][i]);
					arrItem[chkIndex][i]["x"] = 0;
					arrItem[chkIndex][i]["y"] = stage.stageHeight - container.y + 50;
					TweenMax.to(arrItem[chkIndex][i], 1, {y:arrItemY[i], ease:Expo.easeInOut, delay:0.05 + 0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			}
			function completeFunc($item : Item) : void {
				if (chkDirection == "down") {
					if ($item.itemIndex == arrItem[chkIndex]["length"] - 1) {
						arrowOn("on");
						stage.dispatchEvent(new Event(Event.RESIZE));
					}
				}
				if (chkDirection == "up") {
					if ($item.itemIndex == 0) {
						arrowOn("on");
						stage.dispatchEvent(new Event(Event.RESIZE));
					}
				}
				Item($item).getData();
			}
		}

		private function clearContainer($chkNum : int) : void {
			var i : int;

			arrowOn("off");
			if ($chkNum == 0) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					TweenMax.to(arrItem[chkIndex][i], 1, {y:stage.stageHeight + 50, ease:Expo.easeInOut, delay:0.25 - 0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			} else if ($chkNum == 1) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					TweenMax.to(arrItem[chkIndex][i], 1, {y:0 - container.y - 60 - 50, ease:Expo.easeInOut, delay:0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			} else if ($chkNum == 2) {
				for (i = 0; i < arrItem[chkIndex]["length"]; i++) {
					TweenMax.to(arrItem[chkIndex][i], 1, {y:0 - container.y - 60 - 50, ease:Expo.easeInOut, delay:0.05 * i, onComplete:completeFunc, onCompleteParams:[arrItem[chkIndex][i]]});
				}
			}
			function completeFunc($item : Item) : void {
				$item.x = 300;
				Item($item).initialize();

				if ($chkNum == 0) {
					if ($item.itemIndex == 0) {
						clearItem();
						clearInfo();
						chkIndex = 0;
						setItem();
						enterItem($chkNum);
					}
				}
				if ($chkNum == 1 || $chkNum == 2) {
					if ($item.itemIndex == arrItem[chkIndex]["length"] - 1) {
						clearItem();
						clearInfo();
						chkIndex = 0;
						setItem();
						enterItem($chkNum);
					}
				}
			}
		}

		private function clearItem() : void {
			var i : int;
			var j : int;
			for (i = 0; i < arrItem.length; i++) {
				for (j = 0; j < arrItem[i]["length"]; j++) {
					Item(arrItem[i][j]).initialize();
					arrItem[i][j] = null;
				}
			}
			arrItem = [];
		}

		private function clearInfo() : void {
			info.initialize();
			info.xml = xml["category"][categoryIndex];
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			titleIntro();
			function titleIntro() : void {
				TweenMax.to(title["msk1"], 1, {x:12, ease:Expo.easeOut, delay:0.6});
				TweenMax.to(title["msk0"], 0.8, {x:12, ease:Expo.easeInOut, onComplete:completeFunc});
				TweenMax.to(title["msk0"], 0.8, {width:0, ease:Expo.easeInOut, delay:1});
				function completeFunc() : void {
					containerIntro();
					RandomText(arrRandomText[0]).start();
					TweenMax.to(this, 0.3, {sclaeX:1, onComplete:innerCompleteFunc1});
					function innerCompleteFunc1() : void {
						RandomText(arrRandomText[1]).start();
						TweenMax.to(this, 0.3, {scaleX:1, onComplete:innerCompleteFunc2});
						TweenMax.to(title["mouse"], 0.6, {alpha:1, y:75, delay:0.3, ease:Strong.easeOut});
					}
					function innerCompleteFunc2() : void {
						RandomText(arrRandomText[2]).start();
						TweenMax.to(this, 0.1, {scaleX:1, onComplete:innerCompleteFunc3});
					}
					function innerCompleteFunc3() : void {
						RandomText(arrRandomText[3]).start();
					}
				}
			}
			function containerIntro() : void {
				Static.isMenu = false;
				enterItem();

				TweenMax.to(arrCategory[0], 0.9, {x:-2, ease:Expo.easeInOut, delay:1});
				TweenMax.to(arrCategory[1], 0.9, {x:-2, ease:Expo.easeInOut, delay:1.1});
				TweenMax.to(arrCategory[2], 0.9, {x:-2, ease:Expo.easeInOut, delay:1.2, onComplete:function() : void {
					categoryOn(categoryIndex);
					// RandomText(arrCategoryRandomText[0]).start();
					// RandomText(arrCategoryRandomText[1]).start();
					// RandomText(arrCategoryRandomText[2]).start();
				}});
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------------------
		public function outro() : void {
			TweenMax.killAll();
			TweenMax.to(arrCategory[0], 0.9, {x:119, ease:Expo.easeInOut, delay:0.2});
			TweenMax.to(arrCategory[1], 0.9, {x:119, ease:Expo.easeInOut, delay:0.1});
			TweenMax.to(arrCategory[2], 0.9, {x:119, ease:Expo.easeInOut, onComplete:function() : void {
				leaveItem();
			}});

			TweenMax.to(title["msk0"], 0.8, {width:117, ease:Expo.easeInOut});
			TweenMax.to(title["msk0"], 0.8, {x:129, ease:Expo.easeInOut, delay:0.7});
			TweenMax.to(title["msk1"], 0.8, {x:129, ease:Expo.easeInOut, delay:0.7, onComplete:completeOutro});
			RandomText(arrRandomText[3]).start("backward");
			TweenMax.to(title["mouse"], 0.7, {alpha:0, y:80, delay:0.2, ease:Strong.easeOut});
			TweenMax.to(this, 0.3, {scaleX:1, onComplete:completeFunc1});
			function completeFunc1() : void {
				RandomText(arrRandomText[2]).start("backward");
				TweenMax.to(this, 0.1, {scaleX:1, onComplete:completeFunc2});
			}
			function completeFunc2() : void {
				RandomText(arrRandomText[1]).start("backward");
				TweenMax.to(this, 0.1, {scaleX:1, onComplete:completeFunc3});
			}
			function completeFunc3() : void {
				RandomText(arrRandomText[2]).start("backward");
				TweenMax.to(this, 0.1, {scaleX:1, onComplete:completeFunc4});
			}
			function completeFunc4() : void {
				RandomText(arrRandomText[0]).start("backward");
			}
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

		// -------------------------------------------------------------------------------------------------------------------------------------
		static public function get itemIndex() : int {
			return _itemIndex;
		}

		static public function set itemIndex(value : int) : void {
			_itemIndex = value;
		}

		static public function get groupIndex() : int {
			return _groupIndex;
		}

		static public function set groupIndex(value : int) : void {
			_groupIndex = value;
		}

		static public function get categoryIndex() : int {
			return _categoryIndex;
		}

		static public function set categoryIndex(value : int) : void {
			_categoryIndex = value;
		}

		static public function get work() : Work {
			return _work;
		}

		static public function set work(value : Work) : void {
			_work = value;
		}

		static public function get arrArrow() : Array {
			return _arrArrow;
		}

		static public function set arrArrow(value : Array) : void {
			_arrArrow = value;
		}

		static public function get isBlack() : Boolean {
			return _isBlack;
		}

		static public function set isBlack(value : Boolean) : void {
			_isBlack = value;
		}

		static public function get isMoving() : Boolean {
			return _isMoving;
		}

		static public function set isMoving(value : Boolean) : void {
			_isMoving = value;
		}

		static public function get isInfo() : Boolean {
			return _isInfo;
		}

		static public function set isInfo(value : Boolean) : void {
			_isInfo = value;
		}
	}
}






