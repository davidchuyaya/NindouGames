package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ShieldToken extends MovieClip
	{
		var vy = int;
		
		public function ShieldToken()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			vy = 4;
		}
		private function onEnterFrame(evnet:Event):void
		{
			if (this.y >= 400)
			{
				this.visible = false;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				parent.removeChild(this);
			}
			
			if (MovieClip(parent) != null && this.hitTestObject(MovieClip(parent).player) && this.visible)
			{
				//turn the shield on!!!
				MovieClip(parent).shieldInitiate = true;
				
				this.visible = false;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				parent.removeChild(this);
			}
			
			this.y += vy;
		}
	}
}