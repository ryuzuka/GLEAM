package src.gleam.content.contact {
	import flash.text.TextField;

	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class MailBox extends MovieClip {
		private var arrBtn : Array = [];
		private var arrBox : Array = [];
		private var arrBoxPos0 : Array = [[-60, 0], [61, 18], [0, 1], [300, 19], [60, 38], [61, 20], [150, 147], [179, 257], [300, 238]];
		private var arrBoxPos1 : Array = [[0, 0], [61, 0], [0, 19], [61, 19], [0, 38], [61, 38], [150, 147], [179, 238], [240, 238]];
		private var arrName : Array = [];
		private var arrNameText : Array = [];
		private var arrRandomText : Array = [];
		private var box0 : MovieClip;
		private var box1 : MovieClip;
		private var box2 : MovieClip;
		private var box3 : MovieClip;
		private var box4 : MovieClip;
		private var box5 : MovieClip;
		private var box6 : MovieClip;
		private var box7 : MovieClip;
		private var box8 : MovieClip;
		private var reset : MovieClip;
		private var send : MovieClip;
		private var randomText : RandomText;
		private var urlLoader : URLLoader;
		private var urq : URLRequest;
		private var urlVar : URLVariables = new URLVariables();

		public function MailBox() {
			init();
		}

		private function initialize() : void {
			var i : int;
			MovieClip(arrBox[6]).scaleX = 0;
			MovieClip(arrBox[6]).scaleY = 0;
			for (i = 0; i < arrBox.length; i++) {
				MovieClip(arrBox[i]).x = arrBoxPos0[i][0];
				MovieClip(arrBox[i]).y = arrBoxPos0[i][1];
			}
		}

		private function init() : void {
			setInstance();
			setArray();
			setRandomText();
			setButtonEvent();
			setFocusTextField();
			setReset();
			setSend();

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

			send = box7;
			reset = box8;
		}

		private function setArray() : void {
			arrBtn = [reset, send];
			arrBox = [box0, box1, box2, box3, box4, box5, box6, box7, box8];
			arrName = [box0["txt"], box2["txt"], box4["txt"], box7["txt"], box8["txt"]];
			arrNameText = ["name", "e - mail", "subject", "send", "reset"];
		}

		// ------------------------------------------------------------------------------------------------------------------------
		private function setRandomText() : void {
			for (var i : int = 0; i < arrName.length; i++) {
				randomText = new RandomText(arrName[i], arrNameText[i], "en", 50);
				arrRandomText[i] = randomText;
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------
		private function setButtonEvent() : void {
			for (var i : int = 0; i < arrBtn.length; i++) {
				MovieClip(arrBtn[i])["index"] = i;
				MovieClip(arrBtn[i]).buttonMode = true;
				MovieClip(arrBtn[i])["txt"]["mouseEnabled"] = false;
				MovieClip(arrBtn[i]).addEventListener(MouseEvent.ROLL_OVER, buttonMouseEvent);
				MovieClip(arrBtn[i]).addEventListener(MouseEvent.ROLL_OUT, buttonMouseEvent);
			}
		}

		private function buttonMouseEvent(e : MouseEvent) : void {
			var button : MovieClip = e.currentTarget as MovieClip;
			var chkNum : int = e.currentTarget["index"];
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					RandomText(arrRandomText[chkNum - 4]).start("all");
					TweenMax.to(button["bg"], 0.2, {tint:0xBD0000, ease:Expo.easeInOut});
					TweenMax.to(button["txt"], 0.2, {tint:0xBD0000, ease:Expo.easeInOut});
					break;
				case MouseEvent.ROLL_OUT:
					RandomText(arrRandomText[chkNum - 4]).start("all");
					TweenMax.to(button["bg"], 0.2, {tint:null, ease:Expo.easeInOut});
					TweenMax.to(button["txt"], 0.2, {tint:null, ease:Expo.easeInOut});
					break;
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------
		private function setFocusTextField() : void {
			for (var i : int = 0; i < arrBox.length; i++) {
				arrBox[i]["index"] = i;
				if (i == 1 || i == 3 || i == 5 || i == 6) {
					TextField(arrBox[i]["txt"]).addEventListener(FocusEvent.FOCUS_IN, boxFocusEvent);
					TextField(arrBox[i]["txt"]).addEventListener(FocusEvent.FOCUS_OUT, boxFocusEvent);
				}
			}
		}

		private function boxFocusEvent(e : FocusEvent) : void {
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
			} else if ($type == "out") {
				if ($chkNum == 1) TweenMax.to(arrBox[0]["txt"], 0.1, {tint:null});
				if ($chkNum == 3) TweenMax.to(arrBox[2]["txt"], 0.1, {tint:null});
				if ($chkNum == 5) TweenMax.to(arrBox[4]["txt"], 0.1, {tint:null});
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------
		private function setSend() : void {
			send.addEventListener(MouseEvent.CLICK, clickSend);
		}

		private function clickSend(e : MouseEvent) : void {
			var isChk : Boolean = true;
			if (arrBox[1]["txt"]["text"] == "") {
				isChk = false;
				MovieClip(arrBox[1]["bg"]).gotoAndPlay(2);
			}
			if (arrBox[3]["txt"]["text"] == "") {
				isChk = false;
				MovieClip(arrBox[3]["bg"]).gotoAndPlay(2);
			}
			if (arrBox[5]["txt"]["text"] == "") {
				isChk = false;
				MovieClip(arrBox[5]["bg"]).gotoAndPlay(2);
			}
			if (arrBox[6]["txt"]["text"] == "") {
				isChk = false;
				MovieClip(arrBox[6]["bg"]).gotoAndPlay(2);
			}
			if (isChk == true) {
				resetTextField();
				sendMail();
			}
			RandomText(arrRandomText[4]).start("all");
		}

		private function sendMail() : void {
			urlLoader = new URLLoader();
			urq = new URLRequest("/contact/formmail.php");

			urlVar["name"] = String(arrBox[1]["txt"]["text"]);
			urlVar["from"] = String(arrBox[3]["txt"]["text"]);
			urlVar["subject"] = String(arrBox[5]["txt"]["text"]);
			urlVar["massage"] = String(arrBox[6]["txt"]["text"]);

			urq.data = urlVar;
			urq.method = URLRequestMethod.POST;
			urlLoader.load(urq);

			RandomText(arrRandomText[3]).start("all");
			resetTextField();
			outro("send");
		}

		// ------------------------------------------------------------------------------------------------------------------------
		private function setReset() : void {
			reset.addEventListener(MouseEvent.CLICK, clickReset);
		}

		private function clickReset(e : MouseEvent = null) : void {
			RandomText(arrRandomText[3]).start("all");
			resetTextField();
			outro("reset");
		}

		public function resetTextField() : void {
			var i : int;
			for (i = 0; i < arrBox.length; i++) {
				if (i == 1 || i == 3 || i == 5 || i == 6) {
					TweenMax.to(arrBox[i]["txt"], 0.5, {alpha:0, ease:Expo.easeInOut, onComplete:completeFunc});
				}
			}
			function completeFunc() : void {
				for (i = 0; i < arrBox.length; i++) {
					if (i == 1 || i == 3 || i == 5 || i == 6) {
						arrBox[i]["txt"]["text"] = "";
						arrBox[i]["txt"]["alpha"] = 1;
					}
				}
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------
		public function intro() : void {
			var i : int;
			TweenMax.to(arrBox[6], 1, {scaleX:1, scaleY:1, ease:Cubic.easeInOut});
			for (i = 0; i < arrBox.length; i++) {
				if (i == 1) {
					TweenMax.to(arrBox[i], 1, {x:arrBoxPos1[i][0], y:arrBoxPos1[i][1], ease:Cubic.easeInOut, delay:0.05 * i, onComplete:completeFunc});
				} else {
					TweenMax.to(arrBox[i], 1, {x:arrBoxPos1[i][0], y:arrBoxPos1[i][1], ease:Cubic.easeInOut, delay:0.05 * i});
				}
			}
			function completeFunc() : void {
				for (i = 0; i < arrRandomText.length; i++) {
					RandomText(arrRandomText[i]).start();
				}
			}
		}

		// ------------------------------------------------------------------------------------------------------------------------
		public function outro($type : String = null) : void {
			var i : int;
			for (i = 0; i < arrRandomText.length; i++) {
				RandomText(arrRandomText[i]).start("backward");
			}
			for (i = 0; i < arrBox.length; i++) {
				TweenMax.to(arrBox[i], 1, {x:arrBoxPos0[i][0], y:arrBoxPos0[i][1], ease:Cubic.easeInOut, delay:0.3});
			}
			TweenMax.to(arrBox[6], 1, {scaleX:0, scaleY:0, ease:Cubic.easeInOut, delay:0.5, onComplete:completeBox6});

			function completeBox6() : void {
				if ($type == null) {
					RandomText(arrRandomText[3]).start("all");
					resetTextField();
				} else if ($type == "reset") {
					intro();
				} else if ($type == "send") {
					intro();
					ExternalInterface.call("alert", "메일이 전송되었습니다");
				}
			}
		}
	}
}