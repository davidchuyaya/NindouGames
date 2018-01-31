  package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Tank extends MovieClip
	{
		private var vx:Number;
		private var shooting:Boolean;
		private var rayDeadly:Boolean;
		
		public function Tank()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			vx = 0;
			shooting = false;
			rayDeadly = true;
			
			gotoAndStop(1);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (MovieClip(parent) != null && this.visible)
			{
				//the tank sees if the player is within its proximity & if the shield is off
				if (Math.abs(this.x - MovieClip(parent).player.x) < 100 && ! shooting && ! MovieClip(parent).shieldOn)
				{
					//see if the tank WANTS to shoot
					if (Math.floor(Math.random()*51) == 10)
					{
						//choose which direction to shoot at
						if (Math.floor(Math.random()*5) >= 2)
						{
							gotoAndPlay(2);
							shooting = true;
						}
						else
						{
							gotoAndPlay(57);
							shooting = true;
						}
					}
					//OR if the player and the tank are at ABOUT the same exact spot
					else if (Math.abs(this.x - MovieClip(parent).player.x) <= 2)
					{
						//choose which direction to shoot at
						if (Math.floor(Math.random()*5) >= 2)
						{
							gotoAndPlay(2);
							shooting = true;
						}
						else
						{
							gotoAndPlay(57);
							shooting = true;
						}
					}
				}
				//chase the player if the shield is off
				if (! MovieClip(parent).shieldOn)
				{
					if (this.x - MovieClip(parent).player.x > 0)
					{
						vx = -2;
					}
					else
					{
						vx = 2;
					}
				}
				//if the shield is on....
				else
				{
					if (this.x - MovieClip(parent).player.x < 0)
					{
						vx = -2;
					}
					else
					{
						vx = 2;
					}
				}
				
				//the actual looping around the stage
				if (this.x > 500)
				{
					this.x = 50;
				}
				else if (this.x < 50)
				{
					this.x = 500;
				}
				
				//make the tank go back to its original position after firing the laser
				if (currentFrame == 56)
				{
					gotoAndStop(1);
					shooting = false;
					rayDeadly = true;
				}
				else if (currentFrame == 111)
				{
					gotoAndStop(1);
					shooting = false;
					rayDeadly = true;
				}
				
				//the tank is not allowed to move while firing the laser
				if (currentFrame != 1)
				{
					vx = 0;
				}
				
				//kill the tank when its life runs out
				if (MovieClip(parent).tankLife <= 1)
				{
					killThis();
				}
				
				//make it seem like the tank's blood is decreasing
				if (MovieClip(parent).tankLife < 30)
				{
					hp.width = MovieClip(parent).tankLife * 3;
				}
				
				//add vx
				this.x += vx;
				
				//check to see if the tank's rays hit the player
				if (this.rayField != null && MovieClip(parent).player != null && rayDeadly && currentFrame != 1 && ! MovieClip(parent).shieldOn)
				{
					if (this.rayField.hitTestObject(MovieClip(parent).player))
					{
						MovieClip(parent).cutLives();
						rayDeadly = false;
					}
				}
			}
			else
			{
				killThis();
			}
		}
		
		private function killThis()
		{
			vx = 0;
			gotoAndStop(1);
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