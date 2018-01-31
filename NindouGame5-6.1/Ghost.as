package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Ghost extends MovieClip
	{
		var timer = new Timer(1000);
		
		public function Ghost()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			timer.start();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (MovieClip(parent) != null && this.visible)
			{
				//make the eyes move like crazy (loop it) but not the mouth (yet)
				if (this.currentFrame == 10)
				{
					this.gotoAndPlay(1);
				}
				
				//make the blood amount seem like the hp bar width
				hp.width = MovieClip(parent).ghostLife * 2.5;
				
				//kill this if it is dead
				if (MovieClip(parent).ghostLife <= 1)
				{
					killThis();
				}
			}
			else
			{
				killThis();
			}
		}
		
		private function onTimer(event:TimerEvent):void
		{
			//teleport to a new spot every 5 seconds
			if (timer.currentCount % 5 == 0)
			{
				this.x = Math.floor(Math.random()* 550);
			}
			
			//create 2 new enemy3 every 4 seconds
			if (timer.currentCount % 4 == 0)
			{
				this.gotoAndPlay(11);
				MovieClip(parent).createEnemy3();
				MovieClip(parent).createEnemy3();
			}
			
			//make the world go black!!!
			if (timer.currentCount == 60)
			{
				this.gotoAndPlay(11);
				MovieClip(parent).backGround.gotoAndPlay(2);
			}
		}
		
		private function killThis()
		{
			timer.stop();
			this.visible = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			if (MovieClip(parent) != null)
			{
				MovieClip(parent).killChild(this);
			}
		}
	}
}