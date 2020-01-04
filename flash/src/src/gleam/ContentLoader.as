package src.gleam {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	import src.Static;

	/**
	 * ...
	 * @author ...
	 */
	public class ContentLoader extends MovieClip {
		private var arrPath : Array = ["about.swf", "work.swf", "favorite.swf", "board.swf", "contact.swf"];
		private var loader : Loader;
		private var urq : URLRequest = new URLRequest();
		private var contentIndex : int;

		public function ContentLoader() {
		}

		public function loadContent($contentIndex : int) : void {
			contentIndex = $contentIndex;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadContent);
			urq.url = arrPath[$contentIndex];
			loader.load(urq);
			Static.gleam.startLoading();
		}

		private function completeLoadContent(e : Event) : void {
			Static.gleam.arrContent[contentIndex] = e.currentTarget["content"] as MovieClip;
			Static.gleam.stopLoading();
			loader = null;
		}
	}
}