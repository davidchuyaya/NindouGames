package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	//url stuff
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	public class Controller
	{
		private var _model:Object;

		public function Controller(model:Object):void
		{
			_model = model;
		}
		/*
		* FROM THE PAGE MVCS
		*/
		public function processMyWebLinkClick():void
		{
			var _urlRequest:URLRequest = new URLRequest("http://davidchuyaya.blogspot.com/p/comments.html");
			navigateToURL(_urlRequest);
		}
		public function processOfficialSiteClick():void
		{
			var _urlRequest:URLRequest = new URLRequest("http://1001f.com/");
			navigateToURL(_urlRequest);
		}
		public function processNewBar(newNumber:uint, barName:String):void
		{
			//turn the newNumber into a usable value first
			//uses 200 because that's half of 400 and you want the max value to be double what you have now
			switch (barName)
			{
				case "scoochBar":
					_model.scooch = newNumber / 200 * _model.ORIGINAL_SCOOCH;
					break;
				default:
					trace("something terribly wrong with the processNewBar method in controller, the name was this: " + barName);
					break;
			}
		}
		/*
		* FROM INFINITE MODE
		*/
		public function processKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.LEFT :
					_model.goLeft(true);
					break;
				case Keyboard.RIGHT :
					_model.goLeft(false);
					break;
			}
		}
		public function processKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.LEFT)
			{
				_model.stopPlayer = true;
			}
		}
		public function processPauseClick():void
		{
			//when the pause button is clicked, turn the current stage to pauseScreen if it's not, and vice versa
			if (_model.currentStage == "InfiniteModeScreen")
			{
				_model.currentStage = "PauseScreen";
				//stop player from moving
				_model.resetPlayerPositionChange();
			}
			else
			{
				_model.gotoStage = "InfiniteModeScreen";
			}
		}
		public function processHitTest(theName:String):void
		{
			switch (theName)
			{
				case "rock":
					//purposeful flow-through (has the same result)
				case "explodingRock":
					_model.addToHealth(-20);
					_model.addToScore(5);
					_model.addToOugiFill(5);
					break;
				case "money1":
					//purposeful flow-through (has the same result)
				case "money2":
					_model.addToScore(10);
					_model.addToMoneyEarned(10);
					break;
				case "riceball":
					_model.addToScore(50);
					_model.addToHealth(10);
					break;
				case "soulOrb":
					_model.addToScore(50);
					_model.addToOugiFill(15);
					break;
				default:
					trace("name of processHitTest that didn't work: " + theName);
					break;
			}
			//check the health while you're at it
			if (_model.healthFill == 0)
			{
				endGamePlay("EndScreen");
			}
		}
		public function endGamePlay(goto:String):void
		{
			//change stuff that need to be saved first
			if (goto == "EndScreen")
			{
				_model.addMoney();
			}
			//change values to go to EndScreen
			_model.currentStage = "InfiniteModeScreen";
			_model.gotoStage = goto;
			//reset stuff that is OK first
			_model.resetPlayerPositionChange();
			_model.resetPlayerSpeed();
			_model.resetOugiFill();
			_model.resetHealthFill();
			_model.stopPlayer = false;
			//remove the following only if going to MainScreen
			if (goto == "MainScreen")
			{
				resetValues();
			}
		}
		public function resetValues():void
		{
			//reset values that EndScreen don't need no more
			_model.resetScore();
			_model.resetMoneyEarned();
			_model.resetTraveledLength();
			_model.resetPlayerPosition();
		}
	}
}