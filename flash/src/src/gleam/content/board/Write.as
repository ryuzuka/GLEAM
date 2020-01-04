package src.gleam.content.board {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import src.gleam.content.Board;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Write extends MovieClip {
		private var box0 : MovieClip;
		private var box1 : MovieClip;
		private var box2 : MovieClip;
		private var box3 : MovieClip;
		private var box4 : MovieClip;
		private var box5 : MovieClip;
		private var box6 : MovieClip;
		private var box7 : MovieClip;
		private var box8 : MovieClip;
		private var box9 : MovieClip;
		private var box10 : MovieClip;
		private var arrBox : Array = [];
		private var arrBoxPos0 : Array = [[-210, 50], [-89, 32], [-90, 69], [150, 69], [-150, 106], [-89, 70], [0, 197], [-150, 306], [-328, 288], [89, 307], [90, 289]];
		private var arrBoxPos1 : Array = [[-150, 50], [-89, 50], [-150, 69], [-89, 69], [-150, 88], [-89, 88], [0, 197], [-150, 288], [-89, 288], [29, 307], [90, 307]];
		private var arrData : Array = [];
		private var arrName : Array = [];
		private var arrNameText : Array = [];
		private var arrRandomText : Array = [];
		private var arrMenu : Array = [];
		private var randomText : RandomText;
		private var urlLoader : URLLoader = new URLLoader();
		private var urlVar : URLVariables = new URLVariables();
		private var urq : URLRequest = new URLRequest("/board/board_write.php");

		public function Write() {
			init();
		}

		public function initialize() : void {
			var i : int;
			MovieClip(arrBox[6]).scaleX = 0;
			MovieClip(arrBox[6]).scaleY = 0;
			for (i = 0; i < arrBox.length; i++) {
				MovieClip(arrBox[i]).x = arrBoxPos0[i][0];
				MovieClip(arrBox[i]).y = arrBoxPos0[i][1];
			}
			for (i = 0; i < arrData.length; i++) {
				arrData[i]["text"] = "";
				arrData[i]["alpha"] = 1;
			}
		}

		public function init() : void {
			setInstance();
			setArray();
			setRandomText();
			setFocusTextField();

			initialize();
		}

		private function setInstance() : void {
			box0 = this.getChildByName("box0_mc") as MovieClip;
			box1 = this.getChildByName("box1_mc") as MovieClip;
			box2 = this.getChildByName("box2_mc") as MovieClip;
			box3 = this.getChildByName("box3_mc") as MovieClip;
			box4 = this.getChildByName("box4_mc") as MovieClip;
			box5 = this.getChildByName("box5_mc") as MovieClip;
			box6 = this.getChildByName("box6_mc") as MovieClip;
			box7 = this.getChildByName("box7_mc") as MovieClip;
			box8 = this.getChildByName("box8_mc") as MovieClip;
			box9 = this.getChildByName("box9_mc") as MovieClip;
			box10 = this.getChildByName("box10_mc") as MovieClip;

			TextField(box8["txt"]).displayAsPassword = true;
		}

		private function setArray() : void {
			arrBox = [box0, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10];
			arrData = [box1["txt"], box3["txt"], box5["txt"], box6["txt"], box8["txt"]];
			arrName = [box0["txt"], box2["txt"], box4["txt"], box7["txt"], box9["txt"], box10["txt"]];
			arrNameText = ["name", "e - mail", "subject", "password", "write", "cancel"];
			arrMenu = [box9, box10];
		}

		private function setRandomText() : void {
			for (var i : int = 0; i < arrName.length; i++) {
				TextField(arrName[i]).autoSize = TextFieldAutoSize.LEFT;
				randomText = new RandomText(arrName[i], arrNameText[i], "en", 50);
				arrRandomText[i] = randomText;
			}
		}

		private function addListener() : void {
			for (var i : int = 0; i < arrMenu.length; i++) {
				arrMenu[i]["index"] = i;
				MovieClip(arrMenu[i]).buttonMode = true;
				MovieClip(arrMenu[i]).addEventListener(MouseEvent.ROLL_OVER, menuMouseEvent);
				MovieClip(arrMenu[i]).addEventListener(MouseEvent.ROLL_OUT, menuMouseEvent);
				MovieClip(arrMenu[i]).addEventListener(MouseEvent.CLICK, menuMouseEvent);
			}
		}

		private function removeListener() : void {
			for (var i : int = 0; i < arrMenu.length; i++) {
				MovieClip(arrMenu[i]).removeEventListener(MouseEvent.ROLL_OVER, menuMouseEvent);
				MovieClip(arrMenu[i]).removeEventListener(MouseEvent.ROLL_OUT, menuMouseEvent);
				MovieClip(arrMenu[i]).removeEventListener(MouseEvent.CLICK, menuMouseEvent);
			}
		}

		private function menuMouseEvent(e : MouseEvent) : void {
			var chkNum : int = e.currentTarget["index"];
			var type : String;
			var isChk : Boolean = true;
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					TweenMax.to(arrMenu[chkNum]["txt"], 0, {tint:0xbd0000});
					RandomText(arrRandomText[chkNum + 4]).start("all");
					e.currentTarget["bg"]["gotoAndStop"](2);
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(arrMenu[chkNum]["txt"], 0, {tint:null});
					RandomText(arrRandomText[chkNum + 4]).start("all");
					e.currentTarget["bg"]["gotoAndStop"](1);
					break;
				case MouseEvent.CLICK:
					TweenMax.to(arrMenu[chkNum]["txt"], 0, {tint:null});
					RandomText(arrRandomText[chkNum + 4]).start("all");
					e.currentTarget["bg"]["gotoAndStop"](1);
					if (chkNum == 0) {
						if (arrData[0]["text"] == "") {
							isChk = false;
							arrData[0]["parent"]["bg"]["gotoAndPlay"](2);
						}
						if (arrData[1]["text"] == "") {
							isChk = false;
							arrData[1]["parent"]["bg"]["gotoAndPlay"](2);
						}
						if (arrData[2]["text"] == "") {
							isChk = false;
							arrData[2]["parent"]["bg"]["gotoAndPlay"](2);
						}
						if (arrData[3]["text"] == "") {
							isChk = false;
							arrData[3]["parent"]["bg"]["gotoAndPlay"](2);
						}
						if (arrData[4]["text"] == "") {
							isChk = false;
							arrData[4]["parent"]["bg"]["gotoAndPlay"](2);
						}
						if (isChk == true) {
							type = "write";
							outro(type);
						}
					} else if (chkNum == 1) {
						type = "cancel";
						outro(type);
					}
					break;
			}
		}

		// :: SEND DATA ::-----------------------------------------------------------------------------------------------------------------------
		private function sendData() : void {
			urlVar["name"] = arrData[0]["text"];
			urlVar["email"] = arrData[1]["text"];
			urlVar["subject"] = arrData[2]["text"];
			urlVar["message"] = arrData[3]["text"];
			urlVar["pass"] = arrData[4]["text"];

			urq.data = urlVar;
			urlLoader.addEventListener(Event.COMPLETE, completeSendData);
			urlLoader.load(urq);
		}

		private function completeSendData(e : Event) : void {
			urlLoader.removeEventListener(Event.COMPLETE, completeSendData);
			Board.pageIndex = 1;
			Board.board.onBoard(0);
		}

		// :: SET FOCUS ::-----------------------------------------------------------------------------------------------------------------------
		private function setFocusTextField() : void {
			for (var i : int = 0; i < arrBox.length; i++) {
				arrBox[i]["index"] = i;
				if (i == 1 || i == 3 || i == 5 || i == 8) {
					TextField(arrBox[i]["txt"]).addEventListener(FocusEvent.FOCUS_IN, tfFocusEvent);
					TextField(arrBox[i]["txt"]).addEventListener(FocusEvent.FOCUS_OUT, tfFocusEvent);
				}
			}
		}

		private function tfFocusEvent(e : FocusEvent) : void {
			var chkNum : int = e.currentTarget["parent"]["index"];

			switch(e.type) {
				case FocusEvent.FOCUS_IN:
					focusIn("in", chkNum);
					break;
				case FocusEvent.FOCUS_OUT:
					focusIn("out", chkNum);
					break;
			}
		}

		private function focusIn($type : String, $chkNum : int) : void {
			if ($type == "in") {
				if ($chkNum == 1) {
					RandomText(arrRandomText[0]).start("all");
					TweenMax.to(arrBox[0]["txt"], 0.1, {tint:0xBD0000});
				}
				if ($chkNum == 3) {
					RandomText(arrRandomText[1]).start("all");
					TweenMax.to(arrBox[2]["txt"], 0.1, {tint:0xBD0000});
				}
				if ($chkNum == 5) {
					RandomText(arrRandomText[2]).start("all");
					TweenMax.to(arrBox[4]["txt"], 0.1, {tint:0xBD0000});
				}
				if ($chkNum == 8) {
					RandomText(arrRandomText[3]).start("all");
					TweenMax.to(arrBox[7]["txt"], 0.1, {tint:0xBD0000});
				}
			} else if ($type == "out") {
				if ($chkNum == 1) TweenMax.to(arrBox[0]["txt"], 0.1, {tint:null});
				if ($chkNum == 3) TweenMax.to(arrBox[2]["txt"], 0.1, {tint:null});
				if ($chkNum == 5) TweenMax.to(arrBox[4]["txt"], 0.1, {tint:null});
				if ($chkNum == 8) TweenMax.to(arrBox[7]["txt"], 0.1, {tint:null});
			}
		}

		// :: INTRO ::-----------------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			var i : int;

			Board.board.dispatchResize();

			TweenMax.to(arrBox[6], 1, {scaleX:1, scaleY:1, ease:Cubic.easeInOut});
			for (i = 0; i < arrBox.length; i++) {
				TweenMax.to(arrBox[i], 1, {x:arrBoxPos1[i][0], y:arrBoxPos1[i][1], ease:Cubic.easeInOut, delay:0.05 * i});
			}
			TweenMax.to(this, 0.8 + 0.05 * (arrBox.length - 1), {onComplete:function() : void {
				addListener();
				for (i = 0; i < arrRandomText.length; i++) {
					RandomText(arrRandomText[i]).start();
				}
			}});
		}

		// :: OUTRO ::-----------------------------------------------------------------------------------------------------------------------
		public function outro($type : String = null) : void {
			removeListener();
			var i : int;
			for (i = 0; i < arrRandomText.length; i++) {
				RandomText(arrRandomText[i]).start("backward");
			}
			for (i = 0; i < arrData.length; i++) {
				TweenMax.to(arrData[i], 0.6, {alpha:0, ease:Cubic.easeInOut});
			}
			for (i = 0; i < arrBox.length; i++) {
				TweenMax.to(arrBox[i], 1, {x:arrBoxPos0[i][0], y:arrBoxPos0[i][1], ease:Cubic.easeInOut, delay:0.3 + 0.01 * i});
			}
			TweenMax.to(arrBox[6], 1, {scaleX:0, scaleY:0, ease:Cubic.easeInOut, delay:0.4, onComplete:completeOutro, onCompleteParams:[$type]});
		}

		private function completeOutro($type : String) : void {
			if ($type == "cancel") {
				Board.pageIndex = 1;
				Board.board.onBoard(0);
			} else if ($type == "write") {
				sendData();
			}
		}
	}
}