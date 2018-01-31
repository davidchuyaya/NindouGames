package
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class Enemy2 extends MovieClip
	{
		public function Enemy2()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (MovieClip(parent) != null && this.visible)
			{
				//make the enemy look like its scarf is moving but not blinking
				if (this.currentFrame == 5)
				{
					this.gotoAndPlay(1);
				}
				//blink randomly
				if (Math.floor(Math.random()*51) == 10)
				{
					this.gotoAndPlay(6);
				}
				
				if (this != null && this.visible && ! MovieClip(parent).gameDone)
				{
					//enemy shoots randomly 1/100 chance
					if (Math.floor(Math.random()*101) == 10)
					{
						MovieClip(parent).enemy2Shoot(this);
					}
				
					//enemy moves forward randomly
					if (Math.floor(Math.random()*25) == 10)
					{
						this.y += 10;
					}
				
					//check to see if this already exceeded the border of the game
					if (this.y >= 385)
					{
						MovieClip(parent).LoseGame();
					}
				}
				
				//see if it has been left out, then kill itself
				if (MovieClip(parent).enemySuicide)
				{
					killThis();
				}
			}
			//kill this if the bullet hit the enemy and was processed in Main()
			else
			{
				killThis();
			}
		}
		
		private function killThis()
		{
			this.visible = false;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (MovieClip(parent) != null)
			{
				MovieClip(parent).killChild(this);
			}
		}
	}
}