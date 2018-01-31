package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DungeonTwo_Manager extends MovieClip
	{
		public var enemyThree = new EnemyThree();
		public var enemyFour = new EnemyThree();
		public var _yoyo = new Yoyo();
		public var ougi = new Ougi();
		public var riceBallExists:Boolean;
		
		public function DungeonTwo_Manager()
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
			
			_yoyo.stop();
			//add enemies
			this.addChild(enemyThree);
			enemyThree.x = 419;
			enemyThree.y = 232;
			this.addChild(enemyFour);
			enemyFour.x = 184;
			enemyFour.y = 132;
			this.addChild(_yoyo);
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
			//weapons
			_yoyo.isArmed = true;
			_yoyo.x = player.x - 10;
			_yoyo.y = player.y + 10;
			
			//Time running out
			time.timeMeter.width -= 0.25;
			
			
			//2. Check to see if the enemy is dead, then open the door
			if (enemyThree == null && enemyFour == null)
			{
				if (!door.isOpen)
				{
					door.isOpen = true;
				}
			}
			else
			{
				Collision.block(player, door);
				if (enemyThree != null)
				{
					Collision.block(enemyThree, door);
				}
				if (enemyFour != null)
				{
					Collision.block(enemyFour, door);
				}
			}
			
			//3. Check to see if enemy exists and if player is touching him
			if (enemyThree != null)
			{
				if (player.hitTestObject(enemyThree))
				{
					if (_yoyo.invinsible == false)
					{
						MovieClip(parent).health.meter.width -= 0.5;
						MovieClip(parent).spBar.meter.width += 0.5;
					}
				}
			}
			if (enemyFour != null)
			{
				if (player.hitTestObject(enemyFour))
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
				_yoyo = null
				parent.addChild(gameOverLost);
				parent.removeChild(this);
			}
			
			//7. If player is at exit, the game is won.
			if (player != null)
			{
			if (player.hitTestPoint(exit.x, exit.y, true))
			{
				removeChild(_yoyo);
				removeChild(player);
				player = null;
				_yoyo = null;
				MovieClip(parent).checkDungeonTwoWon(this);
			}
			}
			
			//kill enemies
			if (enemyThree != null)
			{
				if (enemyThree.subObject.meter.width < 1)
				{
					enemyThree.subObject.meter.width = 0;
					removeChild(enemyThree);
					enemyThree = null;
				}
			}
			if (enemyFour != null)
			{
				if (enemyFour.subObject.meter.width < 1)
				{
					enemyFour.subObject.meter.width = 0;
					removeChild(enemyFour);
					enemyFour = null;
				}
			}
		}
	}
}