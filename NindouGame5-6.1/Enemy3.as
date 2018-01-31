package
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Enemy3 extends MovieClip
	{
		//use this timer to stop enemy3 from firing multiple ghost fires!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		var timer = new Timer(30);
		var isShooting = new Boolean;
		var fire1Deadly = new Boolean;
		var fire2Deadly = new Boolean;
		var fire3Deadly = new Boolean;
		
		public function Enemy3()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			isShooting = false;
			fire1Deadly = true;
			fire2Deadly = true;
			fire3Deadly = true;
		}
		
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (MovieClip(parent) != null && this.visible)
			{
				//don't have enemy3 look like it's on fire unless it attacks
				if (this.currentFrame == 5)
				{
					this.gotoAndPlay(1);
				}
				//let it have the ability to shoot after it is done shooting
				else if (this.currentFrame == 50)
				{
					isShooting = false;
					this.gotoAndPlay(1);
				}
				
				//see if it can harm the player
				if (this.currentFrame > 23 && fire1 != null && fire2 != null && fire3 != null && isShooting)
				{
					if (fire1.hitTestObject(MovieClip(parent).player) && fire1Deadly)
					{
						fire1Deadly = false;
						
						if (! MovieClip(parent).shieldOn)
						{
							MovieClip(parent).cutLives();
						}
					}
					else if (fire2.hitTestObject(MovieClip(parent).player) && fire2Deadly)
					{
						fire2Deadly = false;
						
						if (! MovieClip(parent).shieldOn)
						{
							MovieClip(parent).cutLives();
						}
					}
					else if (fire3.hitTestObject(MovieClip(parent).player) && fire3Deadly)
					{
						fire3Deadly = false;
						
						if (! MovieClip(parent).shieldOn)
						{
							MovieClip(parent).cutLives();
						}
					}
				}
				
				if (this != null && this.visible && ! MovieClip(parent).gameDone)
				{
					//enemy shoots randomly 1/150 chance (aka 1 every 4 seconds approximately)
					if (Math.floor(Math.random()*151) == 10 && ! isShooting)
					{
						isShooting = true;
						this.gotoAndPlay(6);
						fire1Deadly = true;
						fire2Deadly = true;
						fire3Deadly = true;
					}
				
					//enemy moves forward randomly
					if (Math.floor(Math.random()*25) == 10)
					{
						this.y += 15;
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