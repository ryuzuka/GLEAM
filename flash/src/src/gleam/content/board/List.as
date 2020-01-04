package src.gleam.content.board {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import src.gleam.content.Board;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class List extends MovieClip {
		private var urlLoader : URLLoader = new URLLoader();
		private var urlVar : URLVariables = new URLVariables();
		private var urq : URLRequest = new URLRequest("/board/board_hit.php");
		private var txtBox0 : MovieClip;
		private var txtBox1 : MovieClip;
		private var txtBox2 : MovieClip;
		private var txtBox3 : MovieClip;
		private var txtBox4 : MovieClip;
		private var bg0 : MovieClip;
		private var bg1 : MovieClip;
		private var bg2 : MovieClip;
		private var bg3 : MovieClip;
		private var bg4 : MovieClip;
		private var scope : MovieClip;
		private var line : MovieClip;
		private var arrListData : Array = [];
		private var arrTextBox : Array = [];
		private var arrBg : Array = [];
		private var listData : URLVariables;
		private var index : int;
		private var lineFull : Number;

		public function List($listData : URLVariables, $index : int) {
			listData = $listData;
			index = $index;

			init();
		}

		private function intialize() : void {
			for (var i : int = 0; i < arrBg.length; i++) {
				arrBg[i]["scaleY"] = 0;
				arrTextBox[i]["alpha"] = 0;
			}
		}

		public function init() : void {
			setInstance();
			setArray();
			setText();
			setAlign();
			setLine();

			intialize();
		}

		private function setInstance() : void {
			bg0 = this.getChildByName("bg0_mc") as MovieClip;
			bg1 = this.getChildByName("bg1_mc") as MovieClip;
			bg2 = this.getChildByName("bg2_mc") as MovieClip;
			bg3 = this.getChildByName("bg3_mc") as MovieClip;
			bg4 = this.getChildByName("bg4_mc") as MovieClip;

			txtBox0 = this.getChildByName("txtBox0_mc") as MovieClip;
			txtBox1 = this.getChildByName("txtBox1_mc") as MovieClip;
			txtBox2 = this.getChildByName("txtBox2_mc") as MovieClip;
			txtBox3 = this.getChildByName("txtBox3_mc") as MovieClip;
			txtBox4 = this.getChildByName("txtBox4_mc") as MovieClip;

			scope = this.getChildByName("scope_mc") as MovieClip;
			line = this.getChildByName("line_mc") as MovieClip;
		}

		private function setArray() : void {
			arrListData = [String(listData["no" + index]), String(listData["subject" + index]), String(listData["name" + index]), String(listData["w_date" + index]), String(listData["hit" + index]), String(listData["uid" + index]), String(listData["depth" + index])];
			arrBg = [bg0, bg1, bg2, bg3, bg4];
			arrTextBox = [txtBox0, txtBox1, txtBox2, txtBox3, txtBox4];
		}

		private function setText() : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.bold = true;
			TextField(arrTextBox[2]["txt_tf"]).defaultTextFormat = textFormat;

			var i : int;
			arrTextBox[1]["gotoAndStop"](int(listData["depth" + index]) + 1);
			for (i = 0; i < arrTextBox.length; i++) {
				TextField(arrTextBox[i]["txt_tf"]).autoSize = TextFieldAutoSize.LEFT;
				arrTextBox[i]["txt_tf"]["text"] = arrListData[i];
			}
		}

		private function setAlign() : void {
			var i : int;
			for (i = 0; i < arrTextBox.length; i++) {
				arrBg[i]["width"] = int(arrTextBox[i]["width"] + 6);
			}
			for (i = 1; i < arrTextBox.length; i++) {
				arrTextBox[i]["x"] = int(arrTextBox[i - 1]["x"] + arrTextBox[i - 1]["width"] + 7);
			}
			for (i = 0; i < arrTextBox.length; i++) {
				arrBg[i]["x"] = int(arrTextBox[i]["x"] - 3);
			}
			scope.width = int(arrBg[4]["x"] + arrBg[4]["width"]);
		}

		private function setLine() : void {
			line.width = arrTextBox[4]["x"] + arrTextBox[4]["width"] - arrTextBox[0]["x"];
			line.x = (arrTextBox[4]["x"] + arrTextBox[4]["width"] - arrTextBox[0]["x"]) / 2 + 3;
			lineFull = line.width;
			line.width = 0;
		}

		// :: SET MOUSEVENT :: -------------------------------------------------------------------------------------------------
		private function addListener() : void {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.ROLL_OVER, listMouseEvent);
			this.addEventListener(MouseEvent.ROLL_OUT, listMouseEvent);
			this.addEventListener(MouseEvent.CLICK, listMouseEvent);
		}

		public function removeListener() : void {
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.ROLL_OVER, listMouseEvent);
			this.removeEventListener(MouseEvent.ROLL_OUT, listMouseEvent);
			this.removeEventListener(MouseEvent.CLICK, listMouseEvent);
		}

		private function listMouseEvent(e : MouseEvent) : void {
			var i : int;
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					for (i = 0; i < arrBg.length; i++) {
						TweenMax.to(arrBg[i], 0.1, {tint:0xbd0000});
					}
					TweenMax.to(line, 0.5, {width:lineFull, ease:Quint.easeOut});
					break;
				case MouseEvent.ROLL_OUT:
					for (i = 0; i < arrBg.length; i++) {
						TweenMax.to(arrBg[i], 0.4, {tint:null, ease:Cubic.easeInOut});
					}
					TweenMax.to(line, 0.5, {width:0, ease:Expo.easeInOut});
					break;
				case MouseEvent.CLICK:
					Board.listIndex = index;
					Board.board.listView.outro("read");
					updateHit();
					break;
			}
		}

		// :: UPDATE HIT :: ------------------------------------------------------------------------------------------
		private function updateHit() : void {
			urlVar["no"] = listData["no" + index];
			urq.data = urlVar;
			urq.url = "/board/board_hit.php";
			Board.board.startLoading();
			urlLoader.addEventListener(Event.COMPLETE, completeUpdate);
			urlLoader.load(urq);
		}

		private function completeUpdate(e : Event) : void {
			Board.board.stopLoading();
		}

		// :: INTRO :: -------------------------------------------------------------------------------------------------
		public function intro() : void {
			var i : int;
			for (i = 0; i < arrBg.length; i++) {
				TweenMax.to(arrBg[i], 0.5, {scaleY:1, ease:Expo.easeInOut});
			}
			TweenMax.to(this, 0.2, {onComplete:function() : void {
				for (i = 0; i < arrTextBox.length; i++) {
					TweenMax.to(arrTextBox[i], 0.5, {alpha:1, ease:Quad.easeInOut, delay:0.07 * i});
				}
			}});
			TweenMax.to(this, 0.3, {onComplete:function() : void {
				for (i = 0; i < arrTextBox.length; i++) {
					TweenMax.to(line, 0.6, {width:lineFull, ease:Quint.easeOut});
				}
			}});
			TweenMax.to(this, 0.8, {onComplete:function() : void {
				for (i = 0; i < arrTextBox.length; i++) {
					TweenMax.to(line, 0.7, {width:0, ease:Quint.easeInOut});
				}
			}});
			TweenMax.to(this, 2, {onComplete:function() : void {
			}});
			addListener();
		}

		// :: OUTRO :: -------------------------------------------------------------------------------------------------
		public function outro($type : String = null) : void {
			var i : int;
			TweenMax.to(line, 0.5, {width:0, ease:Expo.easeInOut});
			for (i = 0; i < arrTextBox.length; i++) {
				TweenMax.to(arrTextBox[i], 0.5, {alpha:0, ease:Quad.easeInOut, delay:0.07 * i});
			}
			for (i = 0; i < arrBg.length; i++) {
				if (i == 4 && index == 1) {
					TweenMax.to(arrBg[i], 1, {scaleY:0, ease:Expo.easeInOut, delay:0.07, onComplete:function() : void {
						Board.board.listView.removeList();

						if ($type == "listView") {
							Board.board.listView.loadPHP(Board.pageIndex);
						}
						if ($type == "read") {
							Board.board.onBoard(1);
						}
						if ($type == "write") {
							Board.board.onBoard(2);
						}
					}});
				} else {
					TweenMax.to(arrBg[i], 1, {scaleY:0, ease:Expo.easeInOut, delay:0.3});
				}
			}
		}
	}
}