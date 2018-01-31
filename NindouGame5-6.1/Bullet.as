package
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class Bullet extends MovieClip
	{
		private var vy:int;
		
		public function Bullet()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			vy = -7;
			
			//put bullet where the player is
			this.x = MovieClip(parent).player.x;
			this.y = MovieClip(parent).player.y;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (this != null && MovieClip(parent) != null)
			{
				//add the bullet's velocity
				this.y += vy;
				//let this rotate
				this.rotation += 25;
			
				//bullet self destructs once it goes off screen
				if (this.y <= 0)
				{
					removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					//let the bullet turn null normally
					MovieClip(parent).bulletFired = false;
					MovieClip(parent).killChild(this);
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				
				//bullet checks to see if it hit an enemy
				for (var i:uint = 1; i <= 10; i++)
				{
					//kill enemy1
					if (MovieClip(parent) != null && MovieClip(parent).enemy1Array.length > 1 && MovieClip(parent).enemy1Array[i] != null && MovieClip(parent).enemy1Array[i].visible && this.hitTestObject(MovieClip(parent).enemy1Array[i].body) && ! MovieClip(parent).enemySuicide)
					{
						removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
						
						//change this bullet's name to i:uint so that it can kill the enemy with that name
						this.name = "" + i;
						MovieClip(parent).bulletFired = false;
						MovieClip(parent).killEnemy1(this);
						removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
					//kill enemy2
					if (MovieClip(parent) != null && MovieClip(parent).enemy2Array.length > 1 && MovieClip(parent).enemy2Array[i] != null && MovieClip(parent).enemy2Array[i].visible && this.hitTestObject(MovieClip(parent).enemy2Array[i].body) && ! MovieClip(parent).enemySuicide)
					{
						removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
						
						//change this bullet's name to i:uint so that it can kill the enemy with that name
						this.name = "" + i;
						MovieClip(parent).bulletFired = false;
						MovieClip(parent).killEnemy2(this);
						removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
					//kill enemy3
					if (MovieClip(parent) != null && MovieClip(parent).enemy3Array.length > 1 && MovieClip(parent).enemy3Array[i] != null && MovieClip(parent).enemy3Array[i].visible && this.hitTestObject(MovieClip(parent).enemy3Array[i].body) && ! MovieClip(parent).enemySuicide)
					{
						removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
						
						//change this bullet's name to i:uint so that it can kill the enemy with that name
						this.name = "" + i;
						MovieClip(parent).bulletFired = false;
						MovieClip(parent).killEnemy3(this);
						removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
				}
				
				//see if the bullet hit a tank
				if (MovieClip(parent) != null && MovieClip(parent).tank != null && MovieClip(parent).tank.visible && this.hitTestObject(MovieClip(parent).tank.tankBody))
				{
					removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					MovieClip(parent).bulletFired = false;
					
					MovieClip(parent).score += 5;
					MovieClip(parent).tankLife--;
					MovieClip(parent).killChild(this);
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				
				//see if the bullet hit the ghost
				if (MovieClip(parent) != null && MovieClip(parent).ghost != null && MovieClip(parent).ghost.visible && this.hitTestObject(MovieClip(parent).ghost.body))
				{
					removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					MovieClip(parent).bulletFired = false;
					
					MovieClip(parent).score += 5;
					MovieClip(parent).ghostLife--;
					MovieClip(parent).killChild(this);
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
	}
}