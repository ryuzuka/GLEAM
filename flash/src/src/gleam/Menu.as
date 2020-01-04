package src.gleam {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import src.Static;

	import ryuzuka.utils.RandomText;

	/**
	 * ...
	 * @author ...
	 */
	public class Menu extends MovieClip {
		private var arrName : Array = [];
		public var arrMenu : Array = [];
		private var arrMenuY : Array = [];
		private var arrMenuTxt : Array = [];
		private var arrRandomText : Array = [];
		private var line : MovieClip;
		private var name0 : MovieClip;
		private var name1 : MovieClip;
		private var name2 : MovieClip;
		private var name3 : MovieClip;
		private var name4 : MovieClip;
		private var menu0 : MovieClip;
		private var menu1 : MovieClip;
		private var menu2 : MovieClip;
		private var menu3 : MovieClip;
		private var menu4 : MovieClip;
		public var currentIndex : int;
		private var menuNum : int = 5;

		public function Menu() {
			init();
		}

		private function initialize() : void {
			line.height = 0;
			for (var i : int = 0; i < menuNum; i++) {
				MovieClip(arrMenu[i]).y = 10 * i;
				MovieClip(arrName[i]).x = -130;
			}
		}

		private function init() : void {
			setInstance();
			setArray();
			setRadomText();
			initialize();
		}

		private function setInstance() : void {
			currentIndex = Static.currentIndex;

			line = this.getChildByName("line_mc") as MovieClip;

			name0 = this.getChildByName("name0_mc") as MovieClip;
			name1 = this.getChildByName("name1_mc") as MovieClip;
			name2 = this.getChildByName("name2_mc") as MovieClip;
			name3 = this.getChildByName("name3_mc") as MovieClip;
			name4 = this.getChildByName("name4_mc") as MovieClip;

			menu0 = this.getChildByName("menu0_mc") as MovieClip;
			menu1 = this.getChildByName("menu1_mc") as MovieClip;
			menu2 = this.getChildByName("menu2_mc") as MovieClip;
			menu3 = this.getChildByName("menu3_mc") as MovieClip;
			menu4 = this.getChildByName("menu4_mc") as MovieClip;
		}

		private function setArray() : void {
			arrName = [name0, name1, name2, name3, name4];
			arrMenu = [menu0, menu1, menu2, menu3, menu4];
			arrMenuY = [[0, 20, 30, 40, 50], [0, 10, 30, 40, 50], [0, 10, 20, 40, 50], [0, 10, 20, 30, 50], [0, 10, 20, 30, 40]];
			arrMenuTxt = ["ABOUT", "PORTFOLIO", "FAVORITE", "BOARD", "CONTACT"];
		}

		private function setRadomText() : void {
			var i : int;
			for (i = 0; i < menuNum; i++) {
				var randomText : RandomText = new RandomText(arrMenu[i]["txt"], arrMenuTxt[i], "en", 80);
				arrRandomText[i] = randomText;
			}
		}

		private function setMenu() : void {
			for (var i : int = 0; i < arrMenu.length; i++) {
				arrMenu[i]["index"] = i;
				MovieClip(arrMenu[i]["btn"]).buttonMode = true;
				MovieClip(arrMenu[i]).addEventListener(MouseEvent.ROLL_OVER, menuMouseEvent);
				MovieClip(arrMenu[i]).addEventListener(MouseEvent.ROLL_OUT, menuMouseEvent);
				MovieClip(arrMenu[i]).addEventListener(MouseEvent.CLICK, menuMouseEvent);
			}
		}

		private function menuMouseEvent(e : MouseEvent) : void {
			var menu : MovieClip = e.currentTarget as MovieClip;
			var chkNum : int = menu["index"];
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					menuOn(chkNum);
					RandomText(arrRandomText[chkNum]).start("all");
					break;
				case MouseEvent.ROLL_OUT:
					menuOn(currentIndex);
					RandomText(arrRandomText[chkNum]).start("all");
					break;
				case MouseEvent.CLICK:
					clickMenu(chkNum);
					Static.gleam.title.jumpTitle();
					break;
			}
		}

		private function clickMenu($chkNum : int) : void {
			if (currentIndex != $chkNum) {
				if (Static.isMenu == false) {
					// Static.isMenu = true;//<-----------------------------------------------------
					RandomText(arrRandomText[$chkNum]).start("all");
					if (currentIndex == 100) {
						Static.gleam.outro();
						Static.currentIndex = currentIndex = $chkNum;
						transformMenu($chkNum);
						menuOn($chkNum);
					} else {
						menuOn(currentIndex);
						Static.gleam.arrContent[currentIndex]["outro"]();
						transformMenu($chkNum);
						Static.currentIndex = currentIndex = $chkNum;
					}
				}
			}
		}

		private function menuOn($chkNum : int) : void {
			var i : int;
			for (i = 0; i < arrMenu.length; i++) {
				if (i == $chkNum) {
					TweenMax.to(arrMenu[i], 0.3, {tint:0x4850DD});
				} else {
					TweenMax.to(arrMenu[i], 0.3, {tint:null, ease:Quad.easeInOut});
				}
			}
		}

		private function transformMenu($chkNum : int) : void {
			var i : int;

			if (currentIndex - $chkNum > 0) {
				TweenMax.to(line, 0.6, {y:10 * $chkNum, height:(currentIndex - $chkNum) * 10 + 20, ease:Expo.easeInOut});
				TweenMax.to(line, 0.5, {y:10 * $chkNum, height:20, ease:Expo.easeOut, delay:0.5});
			} else {
				TweenMax.to(line, 0.6, {height:20 + ($chkNum - currentIndex) * 10, ease:Expo.easeInOut});
				TweenMax.to(line, 0.5, {y:10 * $chkNum, height:20, ease:Expo.easeOut, delay:0.5});
			}

			for (i = 0; i < menuNum; i++) {
				TweenMax.to(arrMenu[i], 0.6, {y:arrMenuY[$chkNum][i], ease:Expo.easeInOut});
				if (i == $chkNum) {
					TweenMax.to(arrName[i], 0.6, {x:66, ease:Expo.easeInOut, delay:0.6});
				} else {
					TweenMax.to(arrName[i], 0.6, {x:-130, ease:Expo.easeOut});
				}
			}
		}

		public function initializeMenu() : void {
			var i : int;
			currentIndex = 100;

			TweenMax.to(line, 0.6, {y:0, height:50, ease:Expo.easeInOut});
			for (i = 0; i < arrMenu.length; i++) {
				TweenMax.to(arrMenu[i], 0.3, {tint:null, ease:Quad.easeInOut});
				TweenMax.to(arrMenu[i], 0.6, {y:10 * i, ease:Expo.easeInOut});
				TweenMax.to(arrName[i], 0.6, {x:-130, ease:Expo.easeInOut, delay:0.4});
			}
		}

		public function intro() : void {
			TweenMax.to(line, 1, {height:50, ease:Expo.easeInOut, onComplete:completeIntro});
			TweenMax.to(line, 0.3, {alpha:1, onComplete:completeFunc});
			function completeFunc() : void {
				var i : int;
				for (i = 0; i < arrMenu.length; i++) {
					TweenMax.to(arrMenu[i], 0, {scaleX:1, delay:0.1 * i, onComplete:startRandomText, onCompleteParams:[i]});
				}
			}
			function startRandomText($i : int) : void {
				RandomText(arrRandomText[$i]).start();
			}
		}

		private function completeIntro() : void {
			var i : int;
			for (i = 0; i < arrMenu.length; i++) {
				TweenMax.to(arrMenu[i], 0, {scaleX:1, delay:0.1 * i, onComplete:startRandomText});
			}
			function startRandomText() : void {
				setMenu();
				for (i = 0; i < arrRandomText.length; i++) {
					RandomText(arrRandomText[i]).start("all");
				}
			}
		}
	}
}