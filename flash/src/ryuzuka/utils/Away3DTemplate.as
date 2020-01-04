package ryuzuka.utils
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.events.Event;
	
	public class Away3DTemplate extends MovieClip
	{
		protected var scene:Scene3D;
		protected var camera:Camera3D;
		protected var view:View3D;
		
		protected var timer:Timer;
		
		public function Away3DTemplate()
		{
			
		}
		
		protected function initEngine():void
		{
			view = new View3D();
			addChild(view);
			camera = view.camera;
			scene = view.scene;
		}
		protected function startRender():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		protected function stopRender():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnter);
		}
		protected function onEnter(e:Event):void
		{
			view.render();
		}
		
		protected function initialTimer():void
		{
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			function onTimer(e:Event):void
			{
				stopRender();
			}
		}
		
		public function init():void
		{
			initEngine();
			startRender();
		}
		
		
		
	}
}