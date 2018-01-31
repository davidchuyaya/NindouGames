package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Rat extends MovieClip
	{
		private var _vx:Number;
		private var _vy:Number;
		var removedHasRun:Boolean;
		public var startOugi:Boolean;
		private var stopMoving:Boolean;
		private var didEffects:Boolean;
		
		public function Rat()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			_vx = 0;
			_vy = 0;
			gotoAndStop(1);
			startOugi = false;
			stopMoving = false;
			didEffects = false;
			
			//event listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			removedHasRun = false;
		}
		private function onRemovedFromStage(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removedHasRun = true;
		}
		private function onEnterFrame(event:Event):void
		{
			//explode!!!
			if (startOugi && ! didEffects && currentFrame == 1)
			{
				gotoAndPlay(2);
				MovieClip(parent.parent).explodePlayer(this);
				startOugi = false;
				stopMoving = true;
				didEffects = true;
			}
			//remove the mouse if it has exploded
			if (currentFrame == 66 || MovieClip(parent).boss == null || parent == null || MovieClip(parent).player == null)
			{
				gotoAndStop(1);
				parent.removeChild(this);
			}
			if (MovieClip(parent) != null && ! didEffects && currentFrame == 1)
			{
				MovieClip(parent.parent).checkOugi(this);
			}
			//if player is closer on the x axis
			if (! removedHasRun)
			{
				if (_vx > _vy)
				{
					if(MovieClip(parent).player.x > x)
					{
						//right
						_vx = 6;
						_vy = 0;
					}
					if(MovieClip(parent).player.x < x)
					{
						//left
						_vx = -6;
						_vy = 0;
					}
				}
				//if player is closer on the y axis
				else
				{
					if(MovieClip(parent).player.y < y)
					{
						//up
						_vx = 0;
						_vy = -6;
					}
					if(MovieClip(parent).player.y > y)
					{
						//down
						_vx = 0;
						_vy = 6;
					}
				}
			}
			
			//variables
			var enemyHalfWidth:uint = width / 2;
			var enemyHalfHeight:uint = height / 2;
			
			if (! removedHasRun)
			{
			//Stop rat at the stage edges
			if (x + enemyHalfWidth > stage.stageWidth)
			{
				x = stage.stageWidth - enemyHalfWidth;
			}
			else if (x - enemyHalfWidth < 0)
			{
				x = 0 + enemyHalfWidth;
			}
			if (y - enemyHalfHeight < 0)
			{
				y = 0 + enemyHalfHeight;
			}
			else if (y + enemyHalfHeight > stage.stageHeight)
			{
				y = stage.stageHeight - enemyHalfHeight;
			}
			
			if (! stopMoving)
			{
				//add moving
				x += _vx;
				y += _vy;
			}
			}
		}
	}
}