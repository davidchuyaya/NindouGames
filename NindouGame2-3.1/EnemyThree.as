package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class EnemyThree extends MovieClip
	{
		private var _vx:Number;
		private var _vy:Number;
		private var timer:Timer;
		var removedHasRun:Boolean;
		
		public function EnemyThree()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onAddedToStage(event:Event):void
		{
			_vx = 0;
			_vy = 0;
			timer = new Timer(500);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, updateTimeHandler);
			removedHasRun = false;
		}
		private function onRemovedFromStage(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			timer.removeEventListener(TimerEvent.TIMER, updateTimeHandler);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.stop();
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removedHasRun = true;

		}
		public function updateTimeHandler(event:TimerEvent):void
		{
			if(timer.currentCount == 1)
			{
				timer.reset();
				var randomNumber:int = Math.ceil(Math.random()*2);
			}
			//number is 1
			if (! removedHasRun)
			{
				if (randomNumber == 1)
				{
					if(MovieClip(parent).player.x > x)
					{
						//right
						_vx = 4.5;
						_vy = 0;
					}
					if(MovieClip(parent).player.x < x)
					{
						//left
						_vx = -4.5;
						_vy = 0;
					}
				}
				//number is 2
				if (randomNumber == 2)
				{
					if(MovieClip(parent).player.y < y)
					{
						//up
						_vx = 0;
						_vy = -4.5;
					}
					if(MovieClip(parent).player.y > y)
					{
						//down
						_vx = 0;
						_vy = 4.5;
					}
				}
				timer.start();
			}
		}
			
		private function onEnterFrame(event:Event):void
		{
			//variables
			var enemyHalfWidth:uint = width / 2;
			var enemyHalfHeight:uint = height / 2;
			
			//Stop enemyThree at the stage edges
			if (x + enemyHalfWidth > stage.stageWidth)
			{
				x = stage.stageWidth - enemyHalfWidth;
				_vx *= -1;
			}
			else if (x - enemyHalfWidth < 0)
			{
				x = 0 + enemyHalfWidth;
				_vx *= -1;
			}
			if (y - enemyHalfHeight < 0)
			{
				y = 0 + enemyHalfHeight;
				_vy *= -1;
			}
			else if (y + enemyHalfHeight > stage.stageHeight)
			{
				y = stage.stageHeight - enemyHalfHeight;
				_vy *= -1;
			}
			//add moving
			x += _vx;
			y += _vy;
		}
	}
}