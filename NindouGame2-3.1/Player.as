package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Player extends MovieClip
	{
		private var _vx:int;
		private var _vy:int;
		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;
		public var shining = new Shining();
		public var hitByOugiOne:Boolean;
		private var _timerStarted:Boolean;
		public var timer:Timer;

		public function Player()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			_vx = 0;
			_vy = 0;
			_playerHalfWidth = width / 2;
			_playerHalfHeight = height / 2;
			hitByOugiOne = false;
			_timerStarted = false;
			stop();
			
			//get a timer to show when ougiOne's effects should stop
			timer = new Timer(1000);
			
			//Add stage event listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			timer.addEventListener(TimerEvent.TIMER, stopOugiOneEffects);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT)
			{
				_vx = -5;
				gotoAndStop(4);
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				_vx = 5;
				gotoAndStop(3);
			}
			else if (event.keyCode == Keyboard.UP)
			{
				_vy = -5;
				gotoAndStop(2);
			}
			else if (event.keyCode == Keyboard.DOWN)
			{
				_vy = 5;
				gotoAndStop(1);
			}
		}
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				_vx = 0;
			}
			else if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP)
			{
				_vy = 0;
			}
		}
		public function onEnterFrame(event:Event):void
		{
			//eat rice ball if it exists
			if (MovieClip(parent).riceBallExists)
			{
				MovieClip(parent.parent).eatRiceBall(this);
			}
			
			//no moving during ougi
			if (MovieClip(parent)._yoyo.currentFrame >= 2 && MovieClip(parent)._yoyo.currentFrame <= 31)
			{
				_vx = 0;
				_vy = 0;
			}
			if (MovieClip(parent)._yoyo.currentFrame >= 43 && MovieClip(parent)._yoyo.currentFrame <= 87)
			{
				_vx = 0;
				_vy = 0;
			}
			if (MovieClip(parent)._yoyo.currentFrame >= 89 && MovieClip(parent)._yoyo.currentFrame <= 165)
			{
				_vx = 0;
				_vy = 0;
			}
			
			//half the speed if it is hit by ougiOne
			if (hitByOugiOne)
			{
				_vx /= 1.5;
				_vy /= 1.5;
				
				if (! _timerStarted)
				{
					timer.start();
					_timerStarted = true;
				}
			}
			//Move the player
			x += _vx;
			y += _vy;
			
			//ougi signal
			if (parent != null)
			{
				if (MovieClip(parent)._yoyo.ougiSignal)
				{
					if (MovieClip(parent).ougi.visible)
					{
						if (MovieClip(parent).ougi.currentFrame == 7)
						{
							MovieClip(parent)._yoyo.ougiSignal = false;
							MovieClip(parent).ougi.gotoAndStop(1);
							MovieClip(parent).ougi.visible = false;
						}
					}
					else
					{
						MovieClip(parent).ougi.visible = true;
						MovieClip(parent).ougi.gotoAndPlay(1);
						MovieClip(parent).ougi.x = x;
						MovieClip(parent).ougi.y = y;
					}
				}
				
				//show ougi 1
				if (MovieClip(parent)._yoyo.currentFrame == 30)
				{
					MovieClip(parent).ougi.visible = true;
					MovieClip(parent).ougi.gotoAndPlay(8);
				}
				//stop the ougi words
				if (MovieClip(parent).ougi.currentFrame == 21 || MovieClip(parent).ougi.currentFrame == 35 || MovieClip(parent).ougi.currentFrame == 51)
				{
					MovieClip(parent).ougi.gotoAndStop(1);
					MovieClip(parent).ougi.visible = false;
				}
				//show ougi 2
				if (MovieClip(parent)._yoyo.currentFrame == 86)
				{
					MovieClip(parent).ougi.visible = true;
					MovieClip(parent).ougi.gotoAndPlay(22);
				}
				//show ougi 3
				if (MovieClip(parent)._yoyo.currentFrame == 164)
				{
					MovieClip(parent).ougi.visible = true;
					MovieClip(parent).ougi.gotoAndPlay(36);
				}
			}
			
			if (parent != null)
			{
				if (MovieClip(parent)._yoyo.invinsible)
				{
					parent.addChild(shining);
					shining.visible = true;
					shining.x = x;
					shining.y = y;
				}
				else
				{
					shining.visible = false;
				}
			}

			//Stop player at the stage edges
			if (x + _playerHalfWidth > stage.stageWidth)
			{
				x = stage.stageWidth - _playerHalfWidth;
			}
			else if (x - _playerHalfWidth < 0)
			{
				x = 0 + _playerHalfWidth;
			}
			if (y - _playerHalfHeight < 0)
			{
				y = 0 + _playerHalfHeight;
			}
			else if (y + _playerHalfHeight > stage.stageHeight)
			{
				y = stage.stageHeight - _playerHalfHeight;
			}
		}
		private function stopOugiOneEffects(event:TimerEvent):void
		{
			if(timer.currentCount == 10)
			{
				timer.reset();
				hitByOugiOne = false;
				_timerStarted = false;
			}
		}
	}
}