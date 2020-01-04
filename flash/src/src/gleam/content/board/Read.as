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

	import src.gleam.content.Board;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Read extends MovieClip {
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
		private var box11 : MovieClip;
		private var arrBox : Array = [];
		private var arrBoxPos0 : Array = [[-210, 50], [-89, 68], [90, 32], [-150, 87], [150, 69], [-210, 87], [-89, 70], [0, 197], [-153, 288], [-32, 270], [29, 306], [150, 288]];
		private var arrBoxPos1 : Array = [[-150, 50], [-89, 50], [90, 50], [-150, 69], [-89, 69], [-150, 88], [-89, 88], [0, 197], [-93, 288], [-32, 288], [29, 288], [90, 288]];
		private var arrData : Array = [];
		private var arrName : Array = [];
		private var arrNameText : Array = [];
		private var arrRandomText : Array = [];
		private var arrMenu : Array = [];
		private var randomText : RandomText;
		private var urlLoader : URLLoader = new URLLoader();
		private var urlVar : URLVariables = new URLVariables();
		private var urq : URLRequest = new URLRequest("/board/board_delete.php");
		private var listData : URLVariables;
		private var listIndex : int;

		public function Read() {
			init();
		}

		public function initialize() : void {
			var i : int;
			MovieClip(arrBox[7]).scaleX = 0;
			MovieClip(arrBox[7]).scaleY = 0;
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
			box11 = this.getChildByName("box11_mc") as MovieClip;
		}

		private function setArray() : void {
			arrBox = [box0, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11];
			arrData = [box1["txt"], box2["txt"], box4["txt"], box6["txt"], box7["txt"]];
			arrName = [box0["txt"], box3["txt"], box5["txt"], box8["txt"], box9["txt"], box10["txt"], box11["txt"]];
			arrNameText = ["name", "e - mail", "subject", "list", "modify", "delete", "reply"];
			arrMenu = [box8, box9, box10, box11];
		}

		private function setRandomText() : void {
			for (var i : int = 0; i < arrName.length; i++) {
				TextField(arrName[i]).autoSize = TextFieldAutoSize.LEFT;
				randomText = new RandomText(arrName[i], arrNameText[i], "en", 50);
				arrRandomText[i] = randomText;
			}
		}

		// :: SET LISTENER ::------------------------------------------------------------------------------------------------------------
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
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					TweenMax.to(arrMenu[chkNum]["txt"], 0, {tint:0xbd0000});
					RandomText(arrRandomText[chkNum + 3]).start("all");
					e.currentTarget["bg"]["gotoAndStop"](2);
					break;
				case MouseEvent.ROLL_OUT:
					TweenMax.to(arrMenu[chkNum]["txt"], 0, {tint:null});
					RandomText(arrRandomText[chkNum + 3]).start("all");
					e.currentTarget["bg"]["gotoAndStop"](1);
					break;
				case MouseEvent.CLICK:
					TweenMax.to(arrMenu[chkNum]["txt"], 0, {tint:null});
					RandomText(arrRandomText[chkNum + 3]).start("all");
					e.currentTarget["bg"]["gotoAndStop"](1);
					if (chkNum == 0) {
						type = "list";
						outro(type);
					}
					if (chkNum == 1) {
						type = "modify";
						Password(Board.board.password).type = type;
						Password(Board.board.password).tempPassword = listData["pass" + listIndex];
						Board.board.onPassWord("on");
					}
					if (chkNum == 2) {
						type = "delete";
						Password(Board.board.password).type = type;
						Password(Board.board.password).tempPassword = listData["pass" + listIndex];
						Board.board.onPassWord("on");
					}
					if (chkNum == 3) {
						type = "reply";
						outro(type);
					}
					break;
			}
		}

		// :: SET DELETE ::------------------------------------------------------------------------------------------------------------
		public function deleteData() : void {
			urlVar["no"] = listData["no" + listIndex];
			urlVar["pass"] = listData["pass" + listIndex];
			urq.data = urlVar;
			urlLoader.addEventListener(Event.COMPLETE, completeDeleteData);
			urlLoader.load(urq);
		}

		private function completeDeleteData(e : Event) : void {
			Board.board.onPassWord("off");
			outro("delete");
		}

		// :: SET MODIFY ::------------------------------------------------------------------------------------------------------------
		public function modifyData() : void {
			Board.board.onPassWord("off");
			outro("modify");
		}

		// :: INTRO ::-----------------------------------------------------------------------------------------------------------------------
		public function intro($listData : URLVariables, $listIndex : int) : void {
			listData = $listData;
			listIndex = $listIndex;
			var i : int;

			Board.board.dispatchResize();
			TweenMax.to(arrBox[7], 1, {scaleX:1, scaleY:1, ease:Cubic.easeInOut});
			for (i = 0; i < arrBox.length; i++) {
				TweenMax.to(arrBox[i], 1, {x:arrBoxPos1[i][0], y:arrBoxPos1[i][1], ease:Cubic.easeInOut, delay:0.05 * i});
			}
			TweenMax.to(this, 0.8 + 0.05 * (arrBox.length - 1), {onComplete:function() : void {
				for (i = 0; i < arrRandomText.length; i++) {
					RandomText(arrRandomText[i]).start();
				}
			}});
			TweenMax.to(this, 1.6, {onComplete:function() : void {
				addListener();
				fillData();
			}});
		}

		private function fillData() : void {
			var randomText0 : RandomText = new RandomText(arrData[0], listData["name" + listIndex], "en", 30);
			var randomText1 : RandomText = new RandomText(arrData[1], listData["w_date" + listIndex], "num", 30);
			var randomText2 : RandomText = new RandomText(arrData[2], listData["email" + listIndex], "kr", 30);
			var randomText3 : RandomText = new RandomText(arrData[3], listData["subject" + listIndex], "kr", 30);
			randomText0.start("forward");
			randomText1.start("forward");
			randomText2.start("forward");
			randomText3.start("forward");
			arrData[4]["text"] = listData["message" + listIndex];
			TweenMax.from(arrData[4], 0.5, {alpha:0, ease:Expo.easeInOut});
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
			TweenMax.to(arrBox[7], 1, {scaleX:0, scaleY:0, ease:Cubic.easeInOut, delay:0.4, onComplete:completeOutro, onCompleteParams:[$type]});
		}

		private function completeOutro($type : String) : void {
			if ($type == "list") {
				Board.board.onBoard(0);
			} else if ($type == "modify") {
				Board.board.onBoard(3);
			} else if ($type == "delete") {
				Board.board.onBoard(0);
			} else if ($type == "reply") {
				Board.board.onBoard(4);
			}
		}
	}
}