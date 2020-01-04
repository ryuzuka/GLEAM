package src {
	import src.GLEAM;

	/**
	 * ...
	 * @author ryuzuka
	 */
	public class Static {
		static private var _gleam : GLEAM;
		static private var _currentIndex : int = 100;
		static private var _xml : XML;
		static private var _isMenu : Boolean;
		static private var _boardIndex : int = 1;

		public function Static() {
		}

		static public function get gleam() : GLEAM {
			return _gleam;
		}

		static public function set gleam(value : GLEAM) : void {
			_gleam = value;
		}

		static public function get currentIndex() : int {
			return _currentIndex;
		}

		static public function set currentIndex(value : int) : void {
			_currentIndex = value;
		}

		static public function get xml() : XML {
			return _xml;
		}

		static public function set xml(value : XML) : void {
			_xml = value;
		}

		static public function get isMenu() : Boolean {
			return _isMenu;
		}

		static public function set isMenu(value : Boolean) : void {
			_isMenu = value;
		}

		static public function get boardIndex() : int {
			return _boardIndex;
		}

		static public function set boardIndex(value : int) : void {
			_boardIndex = value;
		}
	}
}