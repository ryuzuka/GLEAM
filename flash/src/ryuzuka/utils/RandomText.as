package ryuzuka.utils
{

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.text.TextField;

	public class RandomText extends EventDispatcher
	{
		private var txtNum:int;
		private var txtField:TextField;
		private var txt:String;
		private var rightTxt:String = "";
		private var fakeTxt:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		private var timer:Timer;
		private var type:String;
		
		public function RandomText($txtField:TextField, $txt:String, $lang:String = "en", $time:uint = 50):void
		{
			txtField = $txtField;
			txt = $txt;
			
			if ($lang == "en")
			{
				fakeTxt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			}
			else if ($lang == "kr")
			{
				fakeTxt = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ";
			}
			else if ($lang == "num")
			{
				fakeTxt = "0123456789";
			}
			timer = new Timer($time, 0);
		}
		public function start($type:String = "forward"):void
		{
			type = $type;
			if (type == "all")
			{
				txtNum = 0;
				rightTxt = "";
			}
			txtField.addEventListener(Event.ENTER_FRAME, rollEnter);
			timer.addEventListener(TimerEvent.TIMER, rollTimer);
			timer.start();
		}
		public function stop():void
		{
			txtField.removeEventListener(Event.ENTER_FRAME, rollEnter);
			timer.stop();
		}
		private function rollEnter(e:Event):void
		{
			var randomNum:int;
			
			txtField.text = rightTxt;
			if (type == "all")
			{
				for (var i:int = 0; i < txt.length - rightTxt.length; i++)
				{
					randomNum = Math.floor(Math.random()*fakeTxt.length);
					txtField.appendText(fakeTxt.charAt(randomNum));
				}
			}
			else
			{
				randomNum = Math.floor(Math.random() * fakeTxt.length);
				txtField.appendText(fakeTxt.charAt(randomNum));
			}
		}
		private function rollTimer(e:TimerEvent):void
		{
			if (type == "all")
			{
				if (txtNum != txt.length - 1)
				{
					rightTxt += txt.charAt(txtNum);
					txtNum ++;
				}
				else
				{
					timer.stop();
					txtField.text = txt;
					txtField.removeEventListener(Event.ENTER_FRAME, rollEnter);
					this.dispatchEvent(new Event("COMPLETE_RANDOM_TEXT"));
				}
			}
			else if (type == "forward")
			{
				if (txtNum != txt.length - 1)
				{
					rightTxt +=  txt.charAt(txtNum);
					txtNum++;
				}
				else
				{
					timer.stop();
					txtField.text = txt;
					txtField.removeEventListener(Event.ENTER_FRAME, rollEnter);
					this.dispatchEvent(new Event("COMPLETE_RANDOM_TEXT"));
				}
			}
			else if (type == "backward")
			{
				if (txtNum != 0)
				{
					txtNum--;
					rightTxt = txt.substr(0, txtNum);
				}
				else
				{
					timer.stop();
					txtField.text = "";
					txtField.removeEventListener(Event.ENTER_FRAME, rollEnter);
					this.dispatchEvent(new Event("COMPLETE_RANDOM_TEXT"));
				}
			}
		}
	}
}