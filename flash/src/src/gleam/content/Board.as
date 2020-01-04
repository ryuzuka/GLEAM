package src.gleam.content {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;

	import src.gleam.content.board.ListView;
	import src.gleam.content.board.Modify;
	import src.gleam.content.board.Password;
	import src.gleam.content.board.Read;
	import src.gleam.content.board.Reply;
	import src.gleam.content.board.Write;
	import src.Static;

	import ryuzuka.utils.CMLoading;
	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Board extends MovieClip {
		private var loading : CMLoading = new CMLoading(11, 8, 2, 5, 0xBCBCBC, 0.8, false);
		private var randomText : RandomText;
		public var listView : ListView;
		public var read : Read;
		public var write : Write;
		public var modify : Modify;
		public var reply : Reply;
		private var boardContainer : MovieClip;
		private var title : MovieClip;
		private var textBox : MovieClip;
		public var password : MovieClip;
		private var black : MovieClip;
		private var arrBoard : Array = [];
		private var arrTitleTxt : Array = [];
		private var arrRandomText : Array = [];
		private var arrLongRandomText : Array = [];
		private var arrText : Array = [];
		private var index : int = 3;
		static private var _board : Board;
		static private var _listData : URLVariables;
		static private var _boardIndex : int = 0;
		static private var _pageIndex : int = 1;
		static private var _listIndex : int;

		// :: 0-listView   1-read    2-write    3-modify   4-reply :: //
		public function Board() {
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
			var i : int;

			black.visible = false;
			black.alpha = 0;
			password.visible = false;
			password.alpha = 0;
			for (i = 0; i < arrBoard.length; i++) {
				if (i != 0) {
					arrBoard[i]["visible"] = false;
				}
			}

			boardContainer.x = int(stage.stageWidth / 2);
			boardContainer.y = int((stage.stageHeight - arrBoard[boardIndex]["height"]) / 2);

			listData = null;
			boardIndex = 0;
			pageIndex = 1;
			listIndex = 0;
			index = 3;
		}

		public function init() : void {
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
			board = this;

			boardContainer = this.getChildByName("boardContainer_mc") as MovieClip;
			password = this.getChildByName("password_mc") as MovieClip;
			black = this.getChildByName("black_mc") as MovieClip;

			title = boardContainer.getChildByName("title_mc") as MovieClip;
			textBox = boardContainer.getChildByName("textBox_mc") as MovieClip;
			listView = boardContainer.getChildByName("listView_mc") as ListView;
			read = boardContainer.getChildByName("read_mc") as Read;
			write = boardContainer.getChildByName("write_mc") as Write;
			modify = boardContainer.getChildByName("modify_mc") as Modify;
			reply = boardContainer.getChildByName("reply_mc") as Reply;
		}

		private function setArray() : void {
			arrBoard = [listView, read, write, modify, reply];
			arrTitleTxt = [textBox["txt0"], textBox["txt1"], textBox["txt2"], textBox["txt3"], textBox["txt4"], textBox["txt5"], textBox["txt6"], textBox["txt7"]];
			arrText = ["PLEASE WRITE", "COMMENT", ",", "QUESTION", "AND YOUR", "THINK", "HERE", "."];
		}

		private function setResize() : void {
			stage.addEventListener(Event.RESIZE, onResize);
		}

		public function dispatchResize() : void {
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function onResize(e : Event) : void {
			var passwordX : int = int((stage.stageWidth - password.width) / 2);
			var passwordY : int = int((stage.stageHeight - password.height) / 2);
			TweenMax.to(password, 1, {x:passwordX, y:passwordY, ease:Quint.easeInOut});
			TweenMax.to(boardContainer, 1, {x:int(stage.stageWidth / 2), y:int((stage.stageHeight - arrBoard[boardIndex]["height"]) / 2), ease:Quint.easeInOut});
			black.width = stage.stageWidth;
			black.height = stage.stageHeight;
		}

		private function setRandomText() : void {
			var i : int;
			var time : int = 20;
			for (i = 0; i < arrTitleTxt.length; i++) {
				if (i == 2) time = 0;
				if (i == 7) time = 0;
				randomText = new RandomText(arrTitleTxt[i], arrText[i], "en", time);
				arrRandomText[i] = randomText;
			}
			arrLongRandomText = [new RandomText(arrTitleTxt[1], arrText[1], "en", 60), new RandomText(arrTitleTxt[3], arrText[3], "en", 120), new RandomText(arrTitleTxt[5], arrText[5], "en", 180), new RandomText(arrTitleTxt[6], arrText[6], "en", 240),];
		}

		// --------- :: ON BOARD :: --------------------------------------------------------------------------------------------------------------
		public function onBoard($chkNum : int) : void {
			boardIndex = $chkNum;

			for (var i : int = 0; i < arrBoard.length; i++) {
				if (i == $chkNum) {
					arrBoard[i]["visible"] = true;
					if (boardIndex == 0) {
						listView.loadPHP(Board.pageIndex);
					} else if (boardIndex == 1) {
						read.intro(Board.listData, Board.listIndex);
					} else if (boardIndex == 2) {
						write.intro();
					} else if (boardIndex == 3) {
						modify.intro(Board.listData, Board.listIndex);
					} else if (boardIndex == 4) {
						reply.intro(Board.listData, Board.listIndex);
					}
				} else {
					arrBoard[i]["initialize"]();
					arrBoard[i]["visible"] = false;
				}
			}
		}

		// --------- :: ON PASSWORD :: --------------------------------------------------------------------------------------------------------------
		public function onPassWord($type : String) : void {
			if ($type == "on") {
				black.visible = true;
				password.visible = true;
				TweenMax.to(black, 0.4, {alpha:1, ease:Expo.easeInOut});
				TweenMax.to(password, 0.4, {alpha:1, ease:Expo.easeInOut, onComplete:function() : void {
					stage.focus = Password(password).tf;
				}});
			} else {
				TweenMax.to(black, 0.4, {alpha:0, ease:Expo.easeInOut});
				TweenMax.to(password, 0.4, {alpha:0, ease:Expo.easeInOut, onComplete:function() : void {
					black.visible = password.visible = false;
					Password(password).initialize();
				}});
			}
		}

		// --------- :: LOADING :: --------------------------------------------------------------------------------------------------------------
		public function startLoading() : void {
			boardContainer.addChild(loading);
			loading.x = 0;
			loading.y = int(arrBoard[boardIndex]["height"] / 2);
			loading.start();
			TweenMax.to(loading, 1, {alpha:1, ease:Strong.easeOut});
		}

		public function stopLoading() : void {
			TweenMax.to(loading, 1, {alpha:0, ease:Strong.easeOut, onComplete:completeLoading, delay:0.5});
		}

		public function completeLoading() : void {
			loading.stop();
			boardContainer.removeChild(loading);
		}

		// --------- :: INTRO :: --------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			onBoard(boardIndex);

			TweenMax.to(title["msk0"], 0.8, {width:0, ease:Expo.easeInOut, delay:0.9});
			TweenMax.to(title["msk0"], 0.8, {x:3, ease:Expo.easeInOut});
			TweenMax.to(title["msk1"], 1, {x:3, ease:Expo.easeOut, delay:0.6});

			TweenMax.to(this, 0, {onComplete:function() : void {
				RandomText(arrRandomText[0]).start();
			}});
			TweenMax.to(this, 0.4, {onComplete:function() : void {
				RandomText(arrRandomText[1]).start();
			}});
			TweenMax.to(this, 0.65, {onComplete:function() : void {
				RandomText(arrRandomText[2]).start();
			}});
			TweenMax.to(this, 0.65, {onComplete:function() : void {
				RandomText(arrRandomText[3]).start();
			}});
			TweenMax.to(this, 0.8, {onComplete:function() : void {
				RandomText(arrRandomText[4]).start();
			}});
			TweenMax.to(this, 0.95, {onComplete:function() : void {
				RandomText(arrRandomText[5]).start();
			}});
			TweenMax.to(this, 1.05, {onComplete:function() : void {
				RandomText(arrRandomText[6]).start();
			}});
			TweenMax.to(this, 1.1, {onComplete:function() : void {
				RandomText(arrRandomText[7]).start();
			}});
			RandomText(arrRandomText[7]).addEventListener("COMPLETE_RANDOM_TEXT", completeRandomText);
			function completeRandomText(e : Event) : void {
				RandomText(arrRandomText[7]).removeEventListener("COMPLETE_RANDOM_TEXT", completeRandomText);
				for (var i : int = 0; i < arrLongRandomText.length; i++) {
					RandomText(arrLongRandomText[i]).start("all");
				}
			}
		}

		// :: OUTRO :: -------------------------------------------------------------------------------------------------
		public function outro() : void {
			TweenMax.killAll();

			if (boardIndex == 0) {
				listView.outro();
			} else if (boardIndex == 1) {
				read.outro();
			} else if (boardIndex == 2) {
				write.outro();
			} else if (boardIndex == 3) {
				modify.outro();
			} else if (_boardIndex == 4) {
				reply.outro();
			}

			TweenMax.to(title["msk0"], 0.8, {width:69, ease:Expo.easeInOut, delay:1});
			TweenMax.to(title["msk0"], 0.8, {x:72, ease:Expo.easeInOut, delay:1.7});
			TweenMax.to(title["msk1"], 0.8, {x:72, ease:Expo.easeInOut, delay:1.7, onComplete:completeOutro});

			TweenMax.to(this, 0.89, {onComplete:function() : void {
				RandomText(arrRandomText[7]).start("backward");
			}});
			TweenMax.to(this, 0.89, {onComplete:function() : void {
				RandomText(arrRandomText[6]).start("backward");
			}});
			TweenMax.to(this, 0.99, {onComplete:function() : void {
				RandomText(arrRandomText[5]).start("backward");
			}});
			TweenMax.to(this, 1.09, {onComplete:function() : void {
				RandomText(arrRandomText[4]).start("backward");
			}});
			TweenMax.to(this, 1.19, {onComplete:function() : void {
				RandomText(arrRandomText[3]).start("backward");
			}});
			TweenMax.to(this, 1.29, {onComplete:function() : void {
				RandomText(arrRandomText[2]).start("backward");
			}});
			TweenMax.to(this, 1.29, {onComplete:function() : void {
				RandomText(arrRandomText[1]).start("backward");
			}});
			TweenMax.to(this, 1.49, {onComplete:function() : void {
				RandomText(arrRandomText[0]).start("backward");
			}});
		}

		private function completeOutro() : void {
			initialize();
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

		// ::  :: -------------------------------------------------------------------------------------------------
		static public function get board() : Board {
			return _board;
		}

		static public function set board(value : Board) : void {
			_board = value;
		}

		static public function get boardIndex() : int {
			return _boardIndex;
		}

		static public function set boardIndex(value : int) : void {
			_boardIndex = value;
		}

		static public function get pageIndex() : int {
			return _pageIndex;
		}

		static public function set pageIndex(value : int) : void {
			_pageIndex = value;
		}

		static public function get listData() : URLVariables {
			return _listData;
		}

		static public function set listData(value : URLVariables) : void {
			_listData = value;
		}

		static public function get listIndex() : int {
			return _listIndex;
		}

		static public function set listIndex(value : int) : void {
			_listIndex = value;
		}

		public function outroTest() : void {
			title.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

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



