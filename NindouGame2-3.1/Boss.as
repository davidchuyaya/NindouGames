package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Boss extends MovieClip
	{
		private var _vx:Number;
		private var _vy:Number;
		private var timer:Timer;
		public var shining = new Shining();
		var removedHasRun:Boolean;
		var bossAfraid:Boolean;
		
		public function Boss()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onAddedToStage(event:Event):void
		{
			bossAfraid = false;
			subObject.gotoAndStop(1);
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
			if (MovieClip(parent.parent).story.visible == false)
			{
				if (MovieClip(parent).player != null)
				{
					_vx = Math.abs(MovieClip(parent).player.x - x);
					_vy = Math.abs(MovieClip(parent).player.y - y);
				}
			}
			
			if (! removedHasRun && ! bossAfraid)
			{
				//if player is closer on the x axis
				if (_vx > _vy)
				{
					if(MovieClip(parent).player.x > x)
					{
						//right
						_vx = 3;
						_vy = 0;
					}
					if(MovieClip(parent).player.x < x)
					{
						//left
						_vx = -3;
						_vy = 0;
					}
				}
				//if player is closer on the y axis
				else
				{
					if(MovieClip(parent).player.y < y)
					{
						//up
						subObject.gotoAndStop(2);
						_vx = 0;
						_vy = -3;
					}
					if(MovieClip(parent).player.y > y)
					{
						//down
						subObject.gotoAndStop(1);
						_vx = 0;
						_vy = 3;
					}
				}
			}
			//run away if ougi or invinsible
			else if (! removedHasRun && bossAfraid)
			{
				//if player is closer on the x axis
				if (_vx > _vy)
				{
					if(MovieClip(parent).player.x > x)
					{
						//left
						_vx = -5.2;
						_vy = 0;
					}
					if(MovieClip(parent).player.x < x)
					{
						//right
						_vx = 5.2;
						_vy = 0;
					}
				}
				//if player is closer on the y axis
				else
				{
					if(MovieClip(parent).player.y < y)
					{
						//down
						subObject.gotoAndStop(1);
						_vx = 0;
						_vy = 5.2;
					}
					if(MovieClip(parent).player.y > y)
					{
						//up
						subObject.gotoAndStop(2);
						_vx = 0;
						_vy = -5.2;
					}
				}
			}
			timer.start();
		}
			
		private function onEnterFrame(event:Event):void
		{
			//ougi signal stuff
			if (parent != null)
			{
				if (MovieClip(parent).flute.ougiSignal)
				{
					if (MovieClip(parent).enemyOugi.visible)
					{
						if (MovieClip(parent).enemyOugi.currentFrame == 7)
						{
							MovieClip(parent).flute.ougiSignal = false;
							MovieClip(parent).enemyOugi.gotoAndStop(1);
							MovieClip(parent).enemyOugi.visible = false;
						}
					}
					else
					{
						MovieClip(parent).enemyOugi.visible = true;
						MovieClip(parent).enemyOugi.gotoAndPlay(1);
						MovieClip(parent).enemyOugi.x = x;
						MovieClip(parent).enemyOugi.y = y;
					}
				}
				
				//show ougi 1
				if (MovieClip(parent).flute.currentFrame == 21)
				{
					MovieClip(parent).enemyOugi.visible = true;
					MovieClip(parent).enemyOugi.gotoAndPlay(8);
				}
				//stop the ougi words
				if (MovieClip(parent).enemyOugi.currentFrame == 20 || MovieClip(parent).enemyOugi.currentFrame == 34 || MovieClip(parent).enemyOugi.currentFrame == 51)
				{
					MovieClip(parent).enemyOugi.gotoAndStop(1);
					MovieClip(parent).enemyOugi.visible = false;
				}
				//show ougi 2
				if (MovieClip(parent).flute.currentFrame == 42)
				{
					MovieClip(parent).enemyOugi.visible = true;
					MovieClip(parent).enemyOugi.gotoAndPlay(22);
				}
				//show ougi 3
				if (MovieClip(parent).flute.currentFrame == 91)
				{
					MovieClip(parent).enemyOugi.visible = true;
					MovieClip(parent).enemyOugi.gotoAndPlay(36);
				}
				
				//invinsible
				if (MovieClip(parent).flute.invinsible)
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
			
			if (MovieClip(parent)._yoyo.ougiSignal)
			{
				bossAfraid = true;
			}
			else if (! MovieClip(parent)._yoyo.ougiSignal)
			{
				bossAfraid = false;
			}
			
			//variables
			var enemyHalfWidth:uint = width / 2;
			var enemyHalfHeight:uint = height / 2;
			
			if (MovieClip(parent).player != null && this != null && ! MovieClip(parent)._yoyo.invinsible)
			{
				if (_vy == 3)
				{
					if ((! MovieClip(parent).flute.attackUP) && (! MovieClip(parent).flute.attackLEFT) && (! MovieClip(parent).flute.attackRIGHT) && (! MovieClip(parent).flute.attackDOWN))
					{
						MovieClip(parent).flute.attackDOWN = true;
					}
				}
				if (_vy == -3)
				{
					if ((! MovieClip(parent).flute.attackDOWN) && (! MovieClip(parent).flute.attackLEFT) && (! MovieClip(parent).flute.attackRIGHT) && (! MovieClip(parent).flute.attackUP))
					{
						MovieClip(parent).flute.attackUP = true;
					}
				}
				if (_vx == 3)
				{
					if ((! MovieClip(parent).flute.attackDOWN) && (! MovieClip(parent).flute.attackLEFT) && (! MovieClip(parent).flute.attackUP) && (! MovieClip(parent).flute.attackRIGHT))
					{
						MovieClip(parent).flute.attackRIGHT = true;
					}
				}
				if (_vx == -3)
				{
					if ((! MovieClip(parent).flute.attackDOWN) && (! MovieClip(parent).flute.attackUP) && (! MovieClip(parent).flute.attackRIGHT) && (! MovieClip(parent).flute.attackLEFT))
					{
						MovieClip(parent).flute.attackLEFT = true;
					}
				}
			}
			
			//Let boss attack you if it's not afraid at stage edges
			if (! bossAfraid)
			{
				//hit stage right side
				if (x + enemyHalfWidth > stage.stageWidth)
				{
					x = stage.stageWidth - enemyHalfWidth;
					_vx = 0;
					_vy = 0;
					
					//if player is higher
					if(MovieClip(parent).player.y < y)
					{
						//up
						subObject.gotoAndStop(2);
						_vx = 0;
						_vy = -3;
					}
					//if player is lower
					if(MovieClip(parent).player.y > y)
					{
						//down
						subObject.gotoAndStop(1);
						_vx = 0;
						_vy = 3;
					}
				}
				//hit stage left side
				else if (x - enemyHalfWidth < 0)
				{
					x = 0 + enemyHalfWidth;
					_vx = 0;
					_vy = 0;
					
					//if player is higher
					if(MovieClip(parent).player.y < y)
					{
						//up
						subObject.gotoAndStop(2);
						_vx = 0;
						_vy = -3;
					}
					//if player is lower
					if(MovieClip(parent).player.y > y)
					{
						//down
						subObject.gotoAndStop(1);
						_vx = 0;
						_vy = 3;
					}
				}
				//hit stage upper side
				if (y - enemyHalfHeight < 0)
				{
					y = 0 + enemyHalfHeight;
					_vy = 0;
					_vx = 0;
					
					//if player is on the right side
					if(MovieClip(parent).player.x > x)
					{
						//right
						_vx = 3;
						_vy = 0;
					}
					//if player is on the left side
					if(MovieClip(parent).player.x < x)
					{
						//left
						_vx = -3;
						_vy = 0;
					}
				}
				//hit stage lower side
				else if (y + enemyHalfHeight > stage.stageHeight)
				{
					y = stage.stageHeight - enemyHalfHeight;
					_vy = 0;
					_vx = 0;
					
					//if player is on the right side
					if(MovieClip(parent).player.x > x)
					{
						//right
						_vx = 3;
						_vy = 0;
					}
					//if player is on the left side
					if(MovieClip(parent).player.x < x)
					{
						//left
						_vx = -3;
						_vy = 0;
					}
				}
			}
			
			//Let boss run in the opposite direction if it's afraid at stage edges
			else if (bossAfraid)
			{
				//hit stage right side
				if (x + enemyHalfWidth > stage.stageWidth)
				{
					x = stage.stageWidth - enemyHalfWidth;
					_vx = 0;
					_vy = 0;
					
					//if player is higher
					if(MovieClip(parent).player.y < y)
					{
						//down
						subObject.gotoAndStop(2);
						_vx = 0;
						_vy = 5.2;
					}
					//if player is lower
					if(MovieClip(parent).player.y > y)
					{
						//up
						subObject.gotoAndStop(1);
						_vx = 0;
						_vy = -5.2;
					}
				}
				//hit stage left side
				else if (x - enemyHalfWidth < 0)
				{
					x = 0 + enemyHalfWidth;
					_vx = 0;
					_vy = 0;
					
					//if player is higher
					if(MovieClip(parent).player.y < y)
					{
						//down
						subObject.gotoAndStop(2);
						_vx = 0;
						_vy = 5.2;
					}
					//if player is lower
					if(MovieClip(parent).player.y > y)
					{
						//up
						subObject.gotoAndStop(1);
						_vx = 0;
						_vy = -5.2;
					}
				}
				//hit stage upper side
				if (y - enemyHalfHeight < 0)
				{
					y = 0 + enemyHalfHeight;
					_vy = 0;
					_vx = 0;
					
					//if player is on the right side
					if(MovieClip(parent).player.x > x)
					{
						//left
						_vx = -5.2;
						_vy = 0;
					}
					//if player is on the left side
					if(MovieClip(parent).player.x < x)
					{
						//right
						_vx = 5.2;
						_vy = 0;
					}
				}
				//hit stage lower side
				else if (y + enemyHalfHeight > stage.stageHeight)
				{
					y = stage.stageHeight - enemyHalfHeight;
					_vy = 0;
					_vx = 0;
					
					//if player is on the right side
					if(MovieClip(parent).player.x > x)
					{
						//left
						_vx = -5.2;
						_vy = 0;
					}
					//if player is on the left side
					if(MovieClip(parent).player.x < x)
					{
						//right
						_vx = 5.2;
						_vy = 0;
					}
				}
			}
			
			//stop boss from moving while using ougi
			if (MovieClip(parent).flute.currentFrame > 10)
			{
				_vx = 0;
				_vy = 0;
			}
			
			//add moving
			x += _vx;
			y += _vy;
		}
	}
}