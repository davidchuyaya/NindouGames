package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Door extends MovieClip
	{
		private var _isOpen:Boolean;
		
		public function Door()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_isOpen = false;
			visible = true;
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		//getters and setters (whatever they are)
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		public function set isOpen(doorState:Boolean)
		{
			_isOpen = doorState;
			if (_isOpen)
			{
				visible = false;
			}
			else
			{
				visible = true;
			}
		}
	}
}