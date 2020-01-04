package src.gleam {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import src.gleam.ryuzuka.Ryuzuka3D;

	public class Ryuzuka extends MovieClip {
		private var ryuzuka3D : Ryuzuka3D;
		private var isCenter : Boolean = true;

		public function Ryuzuka() {
			if (stage) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}

		private function addedToStage(e : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}

		private function init() : void {
			setStage();
			setRyuzuka3D();
			setListener();
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function setStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onResize);
		}

		private function onResize(e : Event) : void {
			var posX : int = Math.round(stage.stageWidth / 2);
			var posY : int = Math.round(stage.stageHeight / 2);
			if (isCenter == true) {
				TweenMax.to(ryuzuka3D, 1, {x:posX, y:posY, ease:Quint.easeInOut, onStart:ryuzuka3D.renderStart, onUpdate:ryuzuka3D.renderStart, onComplete:ryuzuka3D.renderStop});
			} else {
				TweenMax.to(ryuzuka3D, 1, {x:stage.stageWidth / 2 - 80, y:posY, ease:Quint.easeInOut, onStart:ryuzuka3D.renderStart, onUpdate:ryuzuka3D.renderStart, onComplete:ryuzuka3D.renderStop});
			}
		}

		private function setRyuzuka3D() : void {
			ryuzuka3D = new Ryuzuka3D();
			addChild(ryuzuka3D);
			ryuzuka3D.x = (stage.stageWidth - ryuzuka3D.width) / 2;
			ryuzuka3D.y = (stage.stageHeight - ryuzuka3D.height) / 2;
			TweenMax.from(ryuzuka3D, 1, {alpha:0, ease:Quad.easeIn, onStart:ryuzuka3D.renderStart, onUpdate:ryuzuka3D.renderStart, onComplete:ryuzuka3D.renderStop});
		}

		private function setListener() : void {
			this.addEventListener("SWITCH_CENTER_POSITION", switchCenterPositioin);
			this.addEventListener("SWITCH_ABOUT_POSITION", switchAboutPosition);
		}

		private function switchCenterPositioin(e : Event) : void {
			isCenter = true;
			ryuzuka3D.defaultRotation();
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function switchAboutPosition(e : Event) : void {
			isCenter = false;
			ryuzuka3D.defaultRotation();
			stage.dispatchEvent(new Event(Event.RESIZE));
		}
	}
}