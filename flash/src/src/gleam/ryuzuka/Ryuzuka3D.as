package src.gleam.ryuzuka {
	import src.gleam.Ryuzuka;

	import away3d.materials.MovieMaterial;
	import away3d.primitives.Plane;

	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import ryuzuka.utils.Away3DTemplate;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Ryuzuka3D extends Away3DTemplate {
		private var plane : Plane;
		private var ax : Number;
		private var bx : Number;
		private var cx : Number;
		private var dx : Number;
		private var ay : Number;
		private var by : Number;
		private var cy : Number;
		private var dy : Number;

		public function Ryuzuka3D() {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addToStage);
				function addToStage(e : Event) : void {
					removeEventListener(Event.ADDED_TO_STAGE, addToStage);
					init();
				}
			}
		}

		public override function init() : void {
			super.init();
			setPlane();
			addMouseEvent();
			intro();
		}

		private function setPlane() : void {
			var ryuzuka : Ryuzuka = new Ryuzuka();
			plane = new Plane({yUp:false, segmentsW:10, segmentsH:12, width:348, height:438});
			plane.material = new MovieMaterial(ryuzuka, {smooth:true});
			scene.addChild(plane);
		}

		private function intro() : void {
			plane.scaleX = 0.1;
			plane.scaleY = 0.1;
			TweenMax.to(plane, 2, {scaleX:1, scaleY:1, onStart:renderStart, onUpdate:renderStart, ease:Elastic.easeOut});
		}

		private function addMouseEvent() : void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}

		private function onMove(e : MouseEvent) : void {
			ax = -stage.stageWidth / 2;
			bx = stage.stageWidth / 2;
			cx = 25;
			dx = -25;
			var rY : int = Math.round((dx - cx) / (bx - ax) * (mouseX - ax) + cx);

			ay = -stage.stageHeight / 2;
			by = stage.stageHeight / 2;
			cy = -25;
			dy = 25;
			var rX : int = Math.round((dy - cy) / (by - ay) * (mouseY - ay) + cy);

			TweenMax.to(plane, 0.9, {rotationY:rY, rotationX:rX, ease:Quad.easeOut, onStart:renderStart, onUpdate:renderStart, onComplete:renderStop});
		}

		private function onDown(e : MouseEvent = null) : void {
			TweenMax.to(plane, 1, {scaleX:0.9, scaleY:0.9, onStart:renderStart, onUpdate:renderStart});
		}

		private function onUp(e : MouseEvent = null) : void {
			TweenMax.to(plane, 1, {scaleX:1, scaleY:1, onStart:renderStart, onUpdate:renderStart, onComplete:renderStop});
		}

		public function renderStart() : void {
			super.startRender();
		}

		public function renderStop() : void {
			view.render();
			super.stopRender();
		}

		public function defaultRotation() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			TweenMax.to(plane, 1, {rotationY:0, rotationX:0, ease:Expo.easeInOut, onStart:renderStart, onUpdate:renderStart, onComplete:completeDefaultRotation});
		}

		private function completeDefaultRotation() : void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
	}
}

