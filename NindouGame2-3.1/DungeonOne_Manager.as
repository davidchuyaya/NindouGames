package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DungeonOne_Manager extends MovieClip
	{
		public var ougi = new Ougi();
		public var riceBallExists:Boolean;
		
		public function DungeonOne_Manager()
		{
			//Initialize class when stuff are added to stage
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			//event listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			riceBallExists = false;
			
			addChild(ougi);
			ougi.stop();
			ougi.visible = false;
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			//Remove EVERYTHING!!!
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onEnterFrame(event:Event):void
		{
			
			//Time running out
			time.timeMeter.width -= 0.15;
			
			//1. let the player have the _yoyo
			if (player.hitTestObject(_yoyo))
			{
				_yoyo.isArmed = true;
				_yoyo.x = player.x - 10;
				_yoyo.y = player.y + 10;
			}
			
			//2. Check to see if the enemy is dead, then open the door
			if (enemyOne == null)
			{
				if (!doorOne.isOpen)
				{
					doorOne.isOpen = true;
				}
			}
			else
			{
				Collision.block(player, doorOne);
			}
			
			//3. Check to see if enemy exists and if player is touching him
			if (enemyOne != null)
			{
				if (player.hitTestObject(enemyOne))
				{
					if (_yoyo.invinsible == false)
					{
						MovieClip(parent).health.meter.width -= 0.5;
						MovieClip(parent).spBar.meter.width += 0.5;
					}
				}
			}
			if (enemyTwo != null)
			{
				if (player.hitTestObject(enemyTwo))
				{
					if (_yoyo.invinsible == false)
					{
						MovieClip(parent).health.meter.width -= 0.5;
						MovieClip(parent).spBar.meter.width += 0.5;
					}
				}
			}
			
			//4.If the player's dead
			if (MovieClip(parent).health.meter.width < 1 || time.timeMeter.width < 0.1)
			{
				var gameOverLost:GameOver = new GameOver();
				var copyright:Copyright = new Copyright();
				gameOverLost.messageDisplay.text = "GAME" + "\n" + "OVER";
				removeChild(_yoyo);
				removeChild(player);
				player = null;
				_yoyo = null;
				parent.addChild(gameOverLost);
				parent.removeChild(this);
			}
			
			//6. If enemies are dead, open the second door
			if (player != null)
			{
			if (enemyOne == null && enemyTwo == null)
			{
				if (!doorTwo.isOpen)
				{
					doorTwo.isOpen = true;
				}
			}
			else
			{
				Collision.block(player, doorTwo);
			}
			}
			
			//7. If player is at exit, the level is won.
			if (player != null)
			{
			if (player.hitTestPoint(exit.x, exit.y, true))
			{
				removeChild(_yoyo);
				removeChild(player);
				player = null;
				_yoyo = null;
				MovieClip(parent).checkDungeonOneWon(this);
			}
			}
			
			//kill enemies
			if (enemyOne != null)
			{
				if (enemyOne.subObject.meter.width < 1)
				{
					enemyOne.subObject.meter.width = 0;
					removeChild(enemyOne);
					enemyOne = null;
				}
			}
			if (enemyTwo != null)
				{
				if (enemyTwo.subObject.meter.width < 1)
				{
					enemyTwo.subObject.meter.width = 0;
					removeChild(enemyTwo);
					enemyTwo = null;
				}
			}
		}
	}
}