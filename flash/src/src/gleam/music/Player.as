package src.gleam.music {
	import com.greensock.easing.*;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * ...
	 * @author Ryuzuka
	 */
	public class Player extends MovieClip {
		public var equalizer : Equalizer;
		public var msk : MovieClip;
		public var playBtn : MovieClip;
		public var stopBtn : MovieClip;
		public var progress : MovieClip;
		public var volume : MovieClip;
		public var bg : MovieClip;
		private var progressBtn : MovieClip;
		private var progressBar : MovieClip;
		private var progressCurrentBar : MovieClip;
		private var volumeMute : MovieClip;
		private var volumeBtn : MovieClip;
		private var volumeBar : MovieClip;
		private var volumeCurrentBar : MovieClip;
		private var isPlay : Boolean;
		private var isDown : Boolean;
		private var isOver : Boolean;
		private var isVolume : Boolean = true;
		private var volumeRectangle : Rectangle;
		private var progressRectangle : Rectangle;
		private var sound : Sound;
		private var soundChannel : SoundChannel;
		private var soundTransForm : SoundTransform;
		private var soundPosition : Number = 0;
		private var prevVolume : Number = 0.5;

		public function Player() {
			if (stage) {
				init();
				startPlayer();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}

		private function addedToStage(e : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}

		private function init() : void {
			this.addEventListener("COMPLETE_MOVE_UP_FOOTER", startPlayer);

			equalizer = this.getChildByName("equalizer") as Equalizer;
			msk = this.getChildByName("msk") as MovieClip;
			playBtn = this.getChildByName("playBtn") as MovieClip;
			stopBtn = this.getChildByName("stopBtn") as MovieClip;
			bg = this.getChildByName("bg") as MovieClip;
			progress = this.getChildByName("progress") as MovieClip;
			volume = this.getChildByName("volume") as MovieClip;
			progressBtn = progress.getChildByName("progressBtn") as MovieClip;
			progressBar = progress.getChildByName("progressBar") as MovieClip;
			progressCurrentBar = progress.getChildByName("progressCurrentBar") as MovieClip;
			volumeBtn = volume.getChildByName("volumeBtn") as MovieClip;
			volumeBar = volume.getChildByName("volumeBar") as MovieClip;
			volumeCurrentBar = volume.getChildByName("volumeCurrentBar") as MovieClip;
			volumeMute = volume.getChildByName("volumeMute") as MovieClip;

			initSound();();
			initVolume();
			initTogglePlayer();
		}

		private function startPlayer(e : Event = null) : void {
			playBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		// setSound -------------------------------------------------------------------
		private function initSound() : void {
			var mp3 : String;
			//mp3 = "music/Camper (feat  Jason Rene) (Radio Mix)_Albert Kick_Camper.mp3";
			mp3 = "music/Camper.mp3";
			
			
			//mp3 = "music/Afrojack - Rock The House (Marko S. & Vonikk Remix).mp3";
			//mp3 = "music/Can't Stop Me (R3hab & Dyro Remix).mp3";
			//mp3 = "music/David Guetta feat. Rosie Rogers - Whit Out You (Nikola Jay Bootleg Remix 2k12).mp3";
			//mp3 = "music/DJ Markeer 30 minutes Perfect Mix VOL.2.mp3";
			//mp3 = "music/Gianni Coletti - Gimme Fantasy 2K11 (Kee Jay Freak Extended Mix).mp3";
			//mp3 = "music/JISON MIX VOL.16.mp3";
			initControl
			//mp3 = "music/L'Arc-en-Ciel - C'est la Vie.mp3";
			//mp3 = "music/L'Arc-en-Ciel - Driver's High.mp3";
			//mp3 = "music/Massive Ditto-Cinderella(ClubMix).mp3";
			//mp3 = "music/MiXNiT - Revolution (Original Mix).mp3";
			//mp3 = "music/Nuelle - DJ Boy (Alex DB & Kee Jay Freak Extended Remix).mp3";
			//mp3 = "music/Revenge Of The Synth(Original Mix).mp3";
			//mp3 = "music/Tew Heaven - Club Mixset Vol.25.mp3";

			sound = new Sound(new URLRequest(mp3));
			soundTransForm = new SoundTransform(prevVolume);
			soundChannel = new SoundChannel();
			soundChannel.soundTransform = soundTransForm;
		}

		// control -------------------------------------------------------------------------------------------------------------------------------------------
		private function playMusic() : void {
			isPlay = true;
			playBtn.gotoAndStop(2);
			soundChannel = sound.play(soundPosition, 0, soundTransForm);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			equalizer.toggleEqualizer(isPlay);
			toggleProgressEnter(isPlay);
		}

		private function soundComplete(e : Event) : void {
			if (isPlay == true) {
				stopMusic();
				TweenMax.delayedCall(1, playMusic);
			}
		}

		private function pauseMusic() : void {
			isPlay = false;
			playBtn.gotoAndStop(1);
			soundPosition = soundChannel.position;
			soundChannel.stop();
			equalizer.toggleEqualizer(isPlay);
			toggleProgressEnter(isPlay);
		}

		private function stopMusic() : void {
			isPlay = false;
			playBtn.gotoAndStop(1);
			soundPosition = 0;
			soundChannel.stop();
			TweenMax.to(progressBtn, 0.3, {x:0, ease:Expo.easeInOut});
			TweenMax.to(progressCurrentBar, 0.3, {width:0, ease:Expo.easeInOut});
			equalizer.toggleEqualizer(isPlay);
			toggleProgressEnter(isPlay);
		}

		// setControl -----------------------------------------------------------------------------------------------------------------------------------
		private function initControl() : void {
			progressRectangle = new Rectangle(progressBar.x, progressBtn.y, progressBar.width, 0);

			progressCurrentBar.mouseEnabled = false;
			playBtn.buttonMode = true;
			stopBtn.buttonMode = true;
			progressBtn.buttonMode = true;
			stopBtn.addEventListener(MouseEvent.CLICK, clickPlay);
			playBtn.addEventListener(MouseEvent.CLICK, clickPlay);
			progressBar.addEventListener(MouseEvent.CLICK, progressControl);
			progressBtn.addEventListener(MouseEvent.MOUSE_DOWN, progressControl);
		}

		private function clickPlay(e : MouseEvent) : void {
			var control : MovieClip = e.currentTarget as MovieClip;
			if (control.name == "playBtn") {
				if (isPlay == false) playMusic();
				else pauseMusic();
			}
			if (control.name == "stopBtn") {
				stopMusic();
			}
		}

		private function progressControl(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.CLICK:
					progressBtn.x = int(MovieClip(progress).mouseX);
					progressCurrentBar.width = progressBtn.x;
					soundPosition = progressBtn.x / progressBar.width * sound.length;
					soundChannel.stop();
					if (isPlay) playMusic();
					break;
				case MouseEvent.MOUSE_DOWN:
					this.removeEventListener(MouseEvent.ROLL_OUT, togglePlayerMouseEvent);
					stage.addEventListener(MouseEvent.MOUSE_UP, progressControl);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, progressControl);
					toggleProgressEnter(false);
					progressBtn.startDrag(false, progressRectangle);
					break;
				case MouseEvent.MOUSE_UP:
					this.addEventListener(MouseEvent.ROLL_OUT, togglePlayerMouseEvent);
					stage.removeEventListener(MouseEvent.MOUSE_UP, progressControl);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, progressControl);
					progressBtn.stopDrag();
					soundPosition = int(progressBtn.x / progressBar.width * sound.length);
					soundChannel.stop();
					if (isPlay) {
						playMusic();
						toggleProgressEnter(true);
					}
					break;
				case MouseEvent.MOUSE_MOVE:
					progressCurrentBar.width = int(progressBtn.x);
					break;
			}
		}

		private function toggleProgressEnter($isPlay : Boolean) : void {
			if ($isPlay) progress.addEventListener(Event.ENTER_FRAME, progressEnter);
			else progress.removeEventListener(Event.ENTER_FRAME, progressEnter);
		}

		private function progressEnter(e : Event) : void {
			progressBtn.x = soundChannel.position / sound.length * (progressBar.width);
			progressCurrentBar.width = progressBtn.x;
		}

		// setVolume ------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function initVolume() : void {
			setControlVolume();
			setToggleVolume();
		}

		private function setControlVolume() : void {
			volumeRectangle = new Rectangle(volumeBar.x, volumeBtn.y, volumeBar.width, 0);

			volumeCurrentBar.mouseEnabled = false;
			volumeBtn.buttonMode = true;
			volumeBtn.addEventListener(MouseEvent.MOUSE_DOWN, downVolumeControl);
			volumeBar.addEventListener(MouseEvent.CLICK, clickVolumeControl);

			controlVolumeX(soundTransForm.volume);
		}

		private function clickVolumeControl(e : MouseEvent) : void {
			var volume : Number = 0.1 * Math.floor(10 * ((MovieClip(volume).mouseX - volumeBar.x) / (volumeBar.width - 1)));
			controlVolume(volume);
			controlVolumeX(volume);
		}

		private function downVolumeControl(e : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, upVolumeContol);
			volume.addEventListener(Event.ENTER_FRAME, volumeEnter);
			volumeBtn.startDrag(false, volumeRectangle);
			isDown = true;
		}

		private function upVolumeContol(e : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, upVolumeContol);
			volume.removeEventListener(Event.ENTER_FRAME, volumeEnter);
			volumeBtn.stopDrag();
			isDown = false;
			if (isOver == false) this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
		}

		private function volumeEnter(e : Event) : void {
			volumeCurrentBar.width = volumeBtn.x;
			var volume : Number = 0.1 * Math.floor(10 * ((volumeBtn.x - volumeBar.x) / (volumeBar.width)));
			controlVolume(volume);
		}

		private function setToggleVolume() : void {
			volumeMute.buttonMode = true;
			volumeMute.addEventListener(MouseEvent.CLICK, clickVolumeToggleBtn);
			function clickVolumeToggleBtn(e : MouseEvent) : void {
				if (isVolume == false) {
					isVolume = true;
					volumeMute.gotoAndStop(1);
					soundTransForm.volume = prevVolume;
				} else {
					isVolume = false;
					volumeMute.gotoAndStop(2);
					prevVolume = soundTransForm.volume;
					soundTransForm.volume = 0;
				}
				soundChannel.soundTransform = soundTransForm;
				controlVolumeX(Number(soundTransForm.volume));
			}
		}

		private function controlVolume($volume : Number) : void {
			soundTransForm.volume = $volume;
			soundChannel.soundTransform = soundTransForm;
		}

		private function controlVolumeX($volume : Number) : void {
			var volumeBtnX : int = volumeBar.x + $volume * volumeBar.width;
			if (volumeBtnX == 0) volumeBtnX = int(1);
			TweenMax.to(volumeBtn, 0.3, {x:volumeBtnX, ease:Expo.easeInOut});
			TweenMax.to(volumeCurrentBar, 0.3, {width:volumeBtnX, ease:Expo.easeInOut});
		}

		// setTogglePlayer -----------------------------------------------------------------------------------------------------------------------------
		private function initTogglePlayer() : void {
			this.addEventListener(MouseEvent.ROLL_OVER, togglePlayerMouseEvent);
			this.addEventListener(MouseEvent.ROLL_OUT, togglePlayerMouseEvent);
		}

		private function togglePlayerMouseEvent(e : MouseEvent) : void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					isOver = true;
					TweenMax.to(bg, 0.3, {width:188, ease:Cubic.easeOut, delay:0.1});
					TweenMax.to(msk, 0.3, {width:189, ease:Cubic.easeOut, delay:0.1});
					break;
				case MouseEvent.ROLL_OUT:
					isOver = false;
					if (isDown == false) {
						TweenMax.killTweensOf(bg);
						TweenMax.killTweensOf(msk);
						TweenMax.to(bg, 0.5, {width:143, ease:Expo.easeInOut});
						TweenMax.to(msk, 0.5, {width:144, ease:Expo.easeInOut});
					}
					break;
			}
		}
	}
}





