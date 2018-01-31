package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	//url stuff
	import flash.desktop.NativeApplication;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	//accelerometer stuff
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;

	public class Controller
	{
		private var _model:Object;

		public function Controller(model:Object):void
		{
			_model = model;
		}
		//a button is pressed on the android device
		public function processAndroidButtonClick(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.BACK :
					event.preventDefault();
					switch (_model.currentStage)
					{
						case "MainScreen" :
							NativeApplication.nativeApplication.exit();
							break;
							//purposely done fallout (all three have the same result)
						case "InfiniteModeScreen" :
						case "HellModeScreen" :
						case "PauseScreen" :
							processPauseClick();
							break;
							//anything else just goes to MainScreen (HellModeMenu, Shop, Weaponry, Settings, About)
						default :
							_model.gotoStage = "MainScreen";
							break;
					}
					break;
				case Keyboard.MENU :
					event.preventDefault();
					if (_model.currentStage == "MainScreen")
					{
						_model.gotoStage = "SettingsScreen";
					}
					break;
				default :
					trace("what the heck? A button that doesn't exist? Or just a computer?");
					break;
			}
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
				case "minScoochBar":
					_model.minScooch = newNumber / 200 * _model.ORIGINAL_MIN_SCOOCH;
					break;
				default:
					trace("something terribly wrong with the processNewBar method in controller, the name was this: " + barName);
					break;
			}
		}
		/*
		* FROM INFINITE MODE
		*/
		public function processAcceleration(event:AccelerometerEvent):void
		{
			var velocity:Number = - event.accelerationX * _model.scooch;
			if (velocity > _model.X_LIMIT)
			{
				//see if speed is above limit
				_model.playerPositionChange = _model.X_LIMIT;
			}
			else if (velocity < - _model.X_LIMIT)
			{
				//see if speed is below limit
				_model.playerPositionChange = -_model.X_LIMIT;
			}
			else
			{
				//see if speed is too small (aka unoticable and should stop)
				if (Math.abs(velocity) > _model.minScooch)
				{
					//only then add to playerPositionChange
					_model.playerPositionChange = velocity;
				}
				else
				{
					_model.resetPlayerPositionChange();
				}
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
			//remove the following only if going to MainScreen
			if (goto == "MainScreen")
			{
				resetValues();
			}
		}
		//done either when heading to mainScreen via pauseButton or done by the endScreen, because it needs access to those values
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