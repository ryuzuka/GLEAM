package src.gleam.content.board {
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import src.gleam.content.Board;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Password extends MovieClip {
		private var confirm : MovieClip;
		private var cancel : MovieClip;
		public var tf : TextField;
		private var tf0 : TextField;
		private var tf1 : TextField;
		private var tf2 : TextField;
		private var bg : MovieClip;
		private var bg0 : MovieClip;
		private var bg1 : MovieClip;
		private var arrBtn : Array = [];
		private var arrBg : Array = [];
		private var arrTf : Array = [];
		private var arrText : Array = [];
		private var arrRandomText : Array = [];
		public var tempPassword : String;
		public var type : String;

		public function Password() {
			init();
		}

		public function initialize() : void {
			tf.text = "";
		}

		private function init() : void {
			setInstance();
			setArray();
			setRandomText();
			setBtn();
			setTextField();
		}

		private function setInstance() : void {
			confirm = this.getChildByName("confirm_mc") as MovieClip;
			cancel = this.getChildByName("cancel_mc") as MovieClip;
			tf = this.getChildByName("txt_tf") as TextField;
			tf0 = this.getChildByName("txt0_tf") as TextField;
			tf1 = this.getChildByName("txt1_tf") as TextField;
			tf2 = this.getChildByName("txt2_tf") as TextField;
			bg = this.getChildByName("bg_mc") as MovieClip;
			bg0 = this.getChildByName("bg0_mc") as MovieClip;
			bg1 = this.getChildByName("bg1_mc") as MovieClip;
		}

		private function setArray() : void {
			arrBtn = [confirm, cancel];
			arrTf = [tf0, tf1, tf2];
			arrBg = [bg0, bg1];
			arrText = ["CONFIRM", "CANCLE", "PASSWORD"];
		}

		private function setRandomText() : void {
			for (var i : int = 0; i < arrTf.length; i++) {
				arrRandomText[i] = new RandomText(arrTf[i], arrText[i], "en", 50);
			}
		}

		private function setBtn() : void {
			for (var i : int = 0; i < arrBtn.length; i++) {
				MovieClip(arrBtn[i])["index"] = i;
				MovieClip(arrBtn[i]).buttonMode = true;
				MovieClip(arrBtn[i]).addEventListener(MouseEvent.ROLL_OVER, btnMouseEvent);
				MovieClip(arrBtn[i]).addEventListener(MouseEvent.ROLL_OUT, btnMouseEvent);
				MovieClip(arrBtn[i]).addEventListener(MouseEvent.CLICK, btnMouseEvent);
			}
		}

		private function btnMouseEvent(e : MouseEvent) : void {
			var chkNum : int = e.currentTarget["index"];
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					RandomText(arrRandomText[chkNum]).start("all");
					TweenMax.to(arrTf[chkNum], 0.1, {tint:0xbd0000});
					break;
				case MouseEvent.ROLL_OUT:
					RandomText(arrRandomText[chkNum]).start("all");
					TweenMax.to(arrTf[chkNum], 0.1, {tint:null});
					break;
				case MouseEvent.CLICK:
					if (chkNum == 0) {
						confirmPassword(tf.text);
					} else {
						Board.board.onPassWord("off");
					}
					break;
			}
		}

		private function setTextField() : void {
			tf.displayAsPassword = true;
			tf.addEventListener(FocusEvent.FOCUS_IN, tfFocusEvent);
			tf.addEventListener(FocusEvent.FOCUS_OUT, tfFocusEvent);
		}

		private function tfFocusEvent(e : FocusEvent) : void {
			switch(e.type) {
				case FocusEvent.FOCUS_IN:
					RandomText(arrRandomText[2]).start("all");
					break;
				case FocusEvent.FOCUS_OUT:
					RandomText(arrRandomText[2]).start("all");
					break;
			}
		}

		private function confirmPassword($password : String) : void {
			if ($password == tempPassword) {
				if (type == "delete") {
					Board.board.read.deleteData();
				} else if (type == "modify") {
					Board.board.read.modifyData();
				}
			} else {
				bg.gotoAndPlay(2);
				bg.addEventListener("COMPLETE_BG", completeBG);
				function completeBG(e : Event) : void {
					bg.removeEventListener("COMPLETE_BG", completeBG);
					tf.text = "";
				}
			}
		}
	}
}