package
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class EnemyBullet extends MovieClip
	{
		private var vy:int;
		
		public function EnemyBullet()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			vy = 5;
			
			//make this appear where the enemy shooting it is
			this.x = MovieClip(parent).enemy2ShootingX;
			this.y = MovieClip(parent).enemy2ShootingY;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			//disappears if it flies off the screen or if enemy suicide has been activated
			if (this.y >= 400 || MovieClip(parent).enemySuicide)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				//let the bullet turn null normally
				MovieClip(parent).score++;
				MovieClip(parent).killChild(this);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			//cut the player's lives when it hits the player
			if (MovieClip(parent) != null && ! MovieClip(parent).shieldOn && this.hitTestObject(MovieClip(parent).player))
			{
				MovieClip(parent).cutLives();
				
				//let the bullet turn null normally
				MovieClip(parent).score -= 5;
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				MovieClip(parent).killChild(this);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			this.y += vy;
		}
	}
}