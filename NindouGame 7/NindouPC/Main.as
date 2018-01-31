package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class Main extends MovieClip
	{
		private var _model:Model;
		private var _controller:Controller;
		private var _view:View;
		
		public function Main()
		{
			_model = new Model();
			_controller = new Controller(_model);
			_view = new View(_model, _controller);
			addChild(_view);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			_model.update();
		}
	}
}
