package src.gleam.content.board {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	import src.gleam.content.Board;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class ListView extends MovieClip {
		private var urlLoader : URLLoader;
		private var urq : URLRequest;
		private var urlVar : URLVariables;
		private var listData : URLVariables;
		private var listContainer : MovieClip;
		private var controller : MovieClip;
		private var write : MovieClip;
		private var list : List;
		private var writeRandomText : RandomText;
		private var loop : int;
		private var pageIndex : int = 1;
		private var pageNum : int;
		private var listNum : int = 8;
		private var arrList : Array = [];
		private var arrController : Array = [];

		public function ListView() {
			init();
		}

		public function initialize() : void {
			controller.alpha = 0;
			controller.visible = false;
			write.alpha = 0;
			write.visible = false;
		}

		private function init() : void {
			setInstance();
			setController();
			setWrite();
			initialize();
		}

		public function setInstance() : void {
			listContainer = this.getChildByName("listContainer_mc") as MovieClip;
			controller = this.getChildByName("controller_mc") as MovieClip;
			write = this.getChildByName("write_mc") as MovieClip;

			arrController = [controller["prev"], controller["next"]];
		}

		// :: LOAD PHP :: -------------------------------------------------------------------------------------------------
		public function loadPHP($pageIndex : int) : void {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorEvent);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEvent);

			urq = new URLRequest("/board/board_list.php");
			urlVar = new URLVariables();
			pageIndex = $pageIndex;
			urlVar["pageIndex"] = $pageIndex;
			urlVar["listNum"] = listNum;
			urq.data = urlVar;
			urlLoader.load(urq);

			Board.board.startLoading();
		}

		private function errorEvent(e : Event) : void {
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorEvent);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEvent);
			switch(e.type) {
				case IOErrorEvent.IO_ERROR:
					if(ExternalInterface.available)	ExternalInterface.call("alert", "IOErrorEvent : /board/board_list.php");
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					if(ExternalInterface.available)	ExternalInterface.call("alert", "SecurityErrorEvent : /board/board_list.php");
					break;
			}
		}

		private function loadComplete(e : Event) : void {
			Board.board.stopLoading();
			listData = new URLVariables(urlLoader.data);
			Board.listData = listData;
			loop = int(listData["loop"]);
			pageNum = int(listData["pageNum"]);

			setList();
			changeController();
			intro();

			Board.board.dispatchResize();
		}

		// :: SET LIST :: -------------------------------------------------------------------------------------------------
		private function setList() : void {
			var i : int;
			for (i = 0; i < loop; i++) {
				list = new List(listData, i + 1);
				arrList[i] = list;
				listContainer.addChild(list);
				list.x = -1 * list.width / 2;
				list.y = (list.height + 1) * i;
			}
			write.y = listContainer.y + listContainer.height + 1;
		}

		// :: SET CONTROLLER :: -------------------------------------------------------------------------------------------------
		private function setController() : void {
			for (var i : int = 0; i < arrController.length; i++) {
				MovieClip(arrController[i])["index"] = i;
				MovieClip(arrController[i]).buttonMode = true;
				MovieClip(arrController[i]).addEventListener(MouseEvent.CLICK, controllerMouseEvent);
				MovieClip(arrController[i]).addEventListener(MouseEvent.ROLL_OVER, controllerMouseEvent);
				MovieClip(arrController[i]).addEventListener(MouseEvent.ROLL_OUT, controllerMouseEvent);
			}
		}

		private function controllerMouseEvent(e : MouseEvent) : void {
			var chkNum : int = e.currentTarget["index"];
			switch(e.type) {
				case MouseEvent.CLICK:
					if (chkNum == 0) {
						pageIndex--;
						if (pageIndex < 1) pageIndex = 1;
					} else if (chkNum == 1) {
						pageIndex++;
						if (pageIndex > pageNum) pageIndex = pageNum;
					}
					Board.pageIndex = pageIndex;
					clearList();
					break;
				case MouseEvent.ROLL_OVER:
					MovieClip(arrController[chkNum]).gotoAndStop(2);
					break;
				case MouseEvent.ROLL_OUT:
					MovieClip(arrController[chkNum]).gotoAndStop(1);
					break;
			}
		}

		// :: CHANGE CONTROLLER :: -------------------------------------------------------------------------------------------------
		private function changeController() : void {
			if (pageIndex == 1) {
				controller.gotoAndStop(1);
			} else if (pageIndex == pageNum) {
				controller.gotoAndStop(3);
			} else {
				controller.gotoAndStop(2);
			}

			TweenMax.to(controller, 0, {y:int(listContainer.y + listContainer.height + 40), ease:Expo.easeInOut});
		}

		public function removeList() : void {
			for (var i : int = 0; i < loop; i++) {
				listContainer.removeChild(arrList[i]);
			}
		}

		private function clearList() : void {
			outro("listView");
		}

		// :: SET WRITE :: -------------------------------------------------------------------------------------------------
		private function setWrite() : void {
			writeRandomText = new RandomText(write["txt"], "write", "en", 50);

			write.buttonMode = true;
			write.addEventListener(MouseEvent.ROLL_OVER, writeMouseEvent);
			write.addEventListener(MouseEvent.ROLL_OUT, writeMouseEvent);
			write.addEventListener(MouseEvent.CLICK, writeMouseEvent);
		}

		private function writeMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					writeRandomText.start("all");
					TweenMax.to(write["txt"], 0, {tint:0xbd0000});
					e.currentTarget["bg"]["gotoAndStop"](2);
					break;
				case MouseEvent.ROLL_OUT:
					writeRandomText.start("all");
					TweenMax.to(write["txt"], 0, {tint:null});
					e.currentTarget["bg"]["gotoAndStop"](1);
					break;
				case MouseEvent.CLICK:
					writeRandomText.start("all");
					TweenMax.to(write["txt"], 0, {tint:null});
					e.currentTarget["bg"]["gotoAndStop"](1);
					outro("write");
					break;
			}
		}

		// :: INTRO :: -------------------------------------------------------------------------------------------------
		public function intro() : void {
			var i : int;
			for (i = 0; i < loop; i++) {
				TweenMax.to(this, 0, {delay:0.07 * i, onComplete:completeFunc, onCompleteParams:[i]});
			}
			function completeFunc($i : int) : void {
				List(arrList[$i]).intro();
			}
			write.visible = true;
			writeRandomText.start();
			TweenMax.to(write, 0.9, {alpha:1, ease:Expo.easeInOut, delay:0.6});
			if (pageNum == 0 || pageNum == 1) {
				return;
			}
			controller.visible = true;
			TweenMax.to(controller, 0.9, {alpha:1, ease:Expo.easeInOut, delay:0.7});
		}

		// :: OUTRO :: -------------------------------------------------------------------------------------------------
		public function outro($type : String = null) : void {
			var i : int;

			TweenMax.killAll();
			TweenMax.to(controller, 0.7, {alpha:0, ease:Cubic.easeOut, onComplete:function() : void {
				controller.visible = false;
			}});
			TweenMax.to(write, 0.7, {delay:0.2, alpha:0, ease:Cubic.easeOut, onComplete:function() : void {
				controller.visible = false;
			}});

			if (loop == 0 && $type == "write") {
				TweenMax.to(this, 0.8, {onComplete:function() : void {
					Board.board.onBoard(2);
				}});
			} else {
				for (i = loop - 1; i >= 0; i--) {
					TweenMax.to(this, 0, {delay:(loop * 0.07) - (0.07 * i), onCompleteParams:[i], onComplete:function($i : int) : void {
						List(arrList[$i]).removeListener();
						List(arrList[$i]).outro($type);
					}});
				}
			}
		}
	}
}