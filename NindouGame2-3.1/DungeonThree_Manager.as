package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DungeonThree_Manager extends MovieClip
	{
		public var _yoyo = new Yoyo();
		public var flute = new Flute();
		public var ougi = new Ougi();
		public var enemyOugi = new EnemyOugi();
		public var dungeonThreeWon:Boolean;
		public var hitByOugiTwo:Boolean;
		public var riceBallExists:Boolean;
		public var boss = new Boss();
		public var riceBall = new RiceBall();
		private var timer:Timer;
		
		public function DungeonThree_Manager()
		{
			//Initialize class when stuff are added to stage
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			timer = new Timer(1000, 300);
			
			//event listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			timer.addEventListener(TimerEvent.TIMER, dropRiceBall);
			
			timer.start();
			
			addChild(ougi);
			ougi.stop();
			ougi.visible = false;
			
			riceBallExists = false;
			
			addChild(enemyOugi);
			enemyOugi.stop();
			enemyOugi.visible = false;
			
			addChild(flute);
			flute.rotation = 90;
			flute.gotoAndStop(1);
			flute.x = boss.x;
			flute.y = boss.y;
			
			addChild(boss);
			boss.x = 502;
			boss.y = 347;
			
			_yoyo.stop();
			addChild(_yoyo);
			_yoyo.isArmed = true;
			hitByOugiTwo = false;
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
			
			if (player != null && _yoyo.isArmed)
			{
				_yoyo.x = player.x - 10;
				_yoyo.y = player.y + 10;
			}
			if (boss != null)
			{
				flute.x = boss.x;
				flute.y = boss.y;
			}
			
			//put rats on board if ougiThree is used by the boss
			if (boss != null && player != null)
			{
				if (flute.currentFrame == 92)
				{
					var rat1 = new Rat();
					var rat2 = new Rat();
					var rat3 = new Rat();
					
						addChild(rat1);
						rat1.x = 25;
						rat1.y = 25;
						rat1.gotoAndStop(1);
						addChild(rat2);
						rat2.x = 525;
						rat2.y = 25;
						rat2.gotoAndStop(1);
						addChild(rat3);
						rat3.x = 275;
						rat3.y = 300;
						rat3.gotoAndStop(1);
				}
			}
			//1. let the player have the _yoyo if he lost it due to ougiTwo
			if (player != null && ! _yoyo.isArmed)
			{
				if (player.hitTestObject(_yoyo))
				{
					_yoyo.isArmed = true;
					_yoyo.x = player.x - 10;
					_yoyo.y = player.y + 10;
				}
			}
			
			//2. Check to see if player is hit by ougiTwo
			if (player != null && _yoyo.isArmed)
			{
				if (hitByOugiTwo)
				{
					_yoyo.isArmed = false;
					
					_yoyo.x = 275;
					_yoyo.y = 200;
					MovieClip(parent).spBar.meter.width = 0;
					MovieClip(parent).spBar.spText.text = "";
					
					hitByOugiTwo = false;
					if (_yoyo.subObject != null)
					{
						_yoyo.subObject.gotoAndStop(1);
					}
				}
			}
			
			//3. Check to see if boss exists and if player is touching him
			if (boss != null)
			{
				if (player.hitTestObject(boss))
				{
					if (_yoyo.invinsible == false)
					{
						MovieClip(parent).health.meter.width -= 0.4;
						MovieClip(parent).spBar.meter.width += 0.5;
						MovieClip(parent).enemyBar.meter.width += 0.2;
					}
				}
			}
			
			//4.If the player's dead
			if (MovieClip(parent).health.meter.width < 1)
			{
				MovieClip(parent).checkDungeonThreeLost(this);
				
				removeChild(_yoyo);
				removeChild(player);
				player = null;
				_yoyo = null
			}
			
			//7. If player killed the boss, the game is won.
			if (player != null)
			{
			if (boss == null)
			{
				removeChild(_yoyo);
				removeChild(player);
				player = null;
				_yoyo = null;
				MovieClip(parent).checkDungeonThreeWon(this);
			}
			}
			
			//kill boss
			if (boss != null)
			{
				if (boss.subObject.meter.width < 1)
				{
					boss.subObject.meter.width = 0;
					removeChild(boss);
					boss = null;
				}
			}
		}
		
		//drop rice balls for the player to eat
		private function dropRiceBall(event:TimerEvent):void
		{
			output.text = String(15 - timer.currentCount + " seconds left for rice ball.")
			
			if (timer.currentCount == 15)
			{
				if (! riceBallExists)
				{
					addChild(riceBall);
					riceBall.x = 275;
					riceBall.y = 200;
					riceBallExists = true;
				}
				
				timer.reset();
				timer.start();
			}
		}
	}
}