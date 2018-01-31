package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	//android stuff
	import flash.display.Screen;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;

	public class View extends MovieClip
	{
		private var _model:Object;
		private var _controller:Object;
		private var _infiniteModeView:InfiniteModeView;
		private var _intro = new Intro  ;
		//everything on the main screen
		private var _mainScreen = new MainScreen  ;
		private var _aboutButton = new AboutButton  ;
		private var _settingsButton = new SettingsButton  ;
		private var _shopButton = new ShopButton  ;
		private var _weaponryButton = new WeaponryButton  ;
		private var _hellModeMenuButton = new HellModeMenuButton  ;
		private var _infiniteModeButton = new InfiniteModeButton  ;
		//stuff on all screens
		private var _backButton = new BackButton  ;
		private var _sparkArray:MovieClip = new MovieClip  ;
		//other screens
		private var _aboutScreen;
		private var _settingsScreen;
		private var _endScreen = new EndScreen;
		private var _replayButton = new ReplayButton;

		public function View(model:Object, controller:Object):void
		{
			_model = model;
			_controller = controller;
			//instantiate all the views
			_infiniteModeView = new InfiniteModeView(_model,_controller);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addChild(_intro);
			_intro.play();
			_model.currentStage = "IntroScreen";
			_model.addEventListener(Event.CHANGE, onChange);
			//listener to see if any android buttons were clicked
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onAndroidButtonClick);
			//stop phone from fading to black;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			//change the inputmode to TouchPoint - like a MouseEvent
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		//starts the game after the intro plays
		private function startGame():void
		{
			//creating the background
			var bg:Shape = new Shape  ;
			bg.graphics.beginFill(0xFFF2DF, 1);
			bg.graphics.drawRect(0, 0, 480, 800);
			addChild(bg);
			bg.cacheAsBitmap = true;
			//start the game~~
			addChild(_sparkArray);
			initialize();
		}
		private function onChange(event:Event):void
		{
			//stop the intro once it's done
			if (_intro != null)
			{
				if (_intro.currentFrame == 110)
				{
					_intro.stop();
					removeChild(_intro);
					_intro = null;
					startGame();
				}
			}
			//add sparks in background
			if (_model.currentStage != "PauseScreen")
			{
				if (Math.random() * 25 < 10)
				{
					var spark:Shape = new Shape  ;
					var size:int = int(Math.random() * 7) + 1;
					spark.graphics.beginFill(0xFF461F, 1);
					spark.graphics.drawRect(size, size, size/2, size);
					spark.x = int(Math.random() * 480);
					spark.y = 810;
					_sparkArray.addChild(spark);
					spark.cacheAsBitmap = true;
				}
				var theSpark:DisplayObject;
				for (var i:int = 0; i < _sparkArray.numChildren; i++)
				{
					theSpark = _sparkArray.getChildAt(i);
					theSpark.y -=  10;
					if (theSpark.y < 0)
					{
						_sparkArray.removeChild(theSpark);
						theSpark = null;
					}
				}
			}
			//go to screens
			switch (_model.gotoStage)
			{
				case "MainScreen":
					initialize();
					_model.gotoStage = "";
					break;
				case "SettingsScreen":
					initializeSettingsWithoutEvent();
					_model.gotoStage = "";
					break;
				case "EndScreen":
					initializeEnd();
					_model.gotoStage = "";
					break;
			}
		}
		/*
		*THE INITIALIZING FUNCTIONS!!!
		*/
		private function initialize():void
		{
			//changing "screens"
			removeEverything();
			_model.currentStage = "MainScreen";
			//gives you the main screen, with everything there
			addMovieClipWithAxis(_mainScreen, 240, 400);
			addButtonWithAxis(_aboutButton, 380, 730);
			addButtonWithAxis(_settingsButton, 115, 730);
			addButtonWithAxis(_shopButton, 380, 610);
			addButtonWithAxis(_weaponryButton, 115, 610);
			addButtonWithAxis(_hellModeMenuButton, 110, 52);
			addButtonWithAxis(_infiniteModeButton, 360, 60);
			_weaponryButton.addEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
			_shopButton.addEventListener(TouchEvent.TOUCH_TAP, initializeShop);
			_settingsButton.addEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
			_aboutButton.addEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
			_infiniteModeButton.addEventListener(TouchEvent.TOUCH_TAP, initializeInfiniteMode);
			_hellModeMenuButton.addEventListener(TouchEvent.TOUCH_TAP, initializeHellModeMenu);
		}
		/*
		*THE BUTTON INITIALIZING FUNCTIONS!!!
		*/
		private function initializeWeaponry(event:TouchEvent):void
		{
			//changing "screens"
			removeEverything();
			_model.currentStage = "WeaponryScreen";
			//actual stuff
			addButtonWithAxis(_backButton, 25, 775);
			addButtonWithAxis(_shopButton, 175, 750);
			addButtonWithAxis(_settingsButton, 300, 750);
			addButtonWithAxis(_aboutButton, 425, 750);
			_backButton.addEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
			_shopButton.addEventListener(TouchEvent.TOUCH_TAP, initializeShop);
			_settingsButton.addEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
			_aboutButton.addEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
		}
		private function initializeShop(event:TouchEvent):void
		{
			//changing "screens"
			removeEverything();
			_model.currentStage = "ShopScreen";
			//actual stuff
			addButtonWithAxis(_backButton, 25, 775);
			addButtonWithAxis(_weaponryButton, 175, 750);
			addButtonWithAxis(_settingsButton, 300, 750);
			addButtonWithAxis(_aboutButton, 425, 750);
			_backButton.addEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
			_weaponryButton.addEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
			_settingsButton.addEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
			_aboutButton.addEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
		}
		//special because i need someway to get here without having to process event parameters;
		private function initializeSettingsWithoutEvent():void
		{
			_settingsScreen = new PageMVC(_model, _controller);
			//changing "screens"
			removeEverything();
			_model.currentStage = "SettingsScreen";
			//actual stuff
			addChild(_settingsScreen);
			addButtonWithAxis(_backButton, 25, 775);
			addButtonWithAxis(_weaponryButton, 175, 750);
			addButtonWithAxis(_shopButton, 300, 750);
			addButtonWithAxis(_aboutButton, 425, 750);
			_backButton.addEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
			_weaponryButton.addEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
			_shopButton.addEventListener(TouchEvent.TOUCH_TAP, initializeShop);
			_aboutButton.addEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
		}
		private function initializeAbout(event:TouchEvent):void
		{
			_aboutScreen = new PageMVC(_model,_controller);
			//changing "screens"
			removeEverything();
			_model.currentStage = "AboutScreen";
			//actual stuff
			addChild(_aboutScreen);
			addButtonWithAxis(_backButton, 25, 775);
			addButtonWithAxis(_weaponryButton, 425, 750);
			addButtonWithAxis(_shopButton, 175, 750);
			addButtonWithAxis(_settingsButton, 300, 750);
			_backButton.addEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
			_weaponryButton.addEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
			_shopButton.addEventListener(TouchEvent.TOUCH_TAP, initializeShop);
			_settingsButton.addEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
		}
		private function initializeInfiniteMode(event:TouchEvent):void
		{
			//changing "screens"
			//the infiniteModeView will recognize itself that it has begun
			removeEverything();
			addChild(_infiniteModeView);
			_model.currentStage = "InfiniteModeScreen";
		}
		private function initializeHellModeMenu(event:TouchEvent):void
		{
			//changing "screens"
			removeEverything();
			//note this goes to HellMode MENU Screen, not HellModeScreen
			_model.currentStage = "HellModeMenuScreen";
		}
		//ending the game from infinite mode
		private function initializeEnd():void
		{
			//changing "screens"
			removeEverything();
			addMovieClipWithAxis(_endScreen, 240, 400);
			addButtonWithAxis(_replayButton, 380, 780);
			_model.currentStage = "EndScreen";
			//actual stuff
			_endScreen.score.text = String(_model.score);
			_endScreen.money.text = String(_model.money);
			_endScreen.traveledLength.text = String(_model.traveledLength);
			addButtonWithAxis(_backButton, 25, 775);
			_backButton.addEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
			_replayButton.addEventListener(TouchEvent.TOUCH_TAP, initializeInfiniteMode);
		}
		/*
		* INDIRECT WAYS TO GET SOMEWHERE BECAUSE OF ACTIONSCRIPT'S ANNOYING EVENT PARAMETERS RULE
		*/
		private function backButtonClick(event:TouchEvent):void
		{
			initialize();
		}
		private function initializeSettings(event:TouchEvent):void
		{
			initializeSettingsWithoutEvent();
		}
		/*
		*IMPORTANT COMMONLY REUSED METHODS (FUNCTIONS)
		*/
		private function addMovieClipWithAxis(movieClip:MovieClip, xValue:int, yValue:int):void
		{
			addChild(movieClip);
			movieClip.x = xValue;
			movieClip.y = yValue;
		}
		private function addButtonWithAxis(button:SimpleButton, xValue:uint, yValue:uint):void
		{
			addChild(button);
			button.x = xValue;
			button.y = yValue;
		}
		//remove everything currently on the stage
		private function removeEverything():void
		{
			//if the currentStage is MainScreen, then remove all these, etc.
			switch (_model.currentStage)
			{
				case "MainScreen" :
					_weaponryButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
					_shopButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeShop);
					_settingsButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
					_aboutButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
					_infiniteModeButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeInfiniteMode);
					_hellModeMenuButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeHellModeMenu);
					removeChild(_mainScreen);
					removeChild(_aboutButton);
					removeChild(_settingsButton);
					removeChild(_shopButton);
					removeChild(_weaponryButton);
					removeChild(_hellModeMenuButton);
					removeChild(_infiniteModeButton);
					break;
				case "WeaponryScreen" :
					_backButton.removeEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
					_shopButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeShop);
					_settingsButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
					_aboutButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
					removeChild(_backButton);
					removeChild(_shopButton);
					removeChild(_settingsButton);
					removeChild(_aboutButton);
					break;
				case "ShopScreen" :
					_backButton.removeEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
					_weaponryButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
					_settingsButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
					_aboutButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
					removeChild(_backButton);
					removeChild(_weaponryButton);
					removeChild(_settingsButton);
					removeChild(_aboutButton);
					break;
				case "SettingsScreen" :
					_backButton.removeEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
					_weaponryButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
					_shopButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeShop);
					_aboutButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeAbout);
					removeChild(_settingsScreen);
					_settingsScreen = null;
					removeChild(_backButton);
					removeChild(_weaponryButton);
					removeChild(_shopButton);
					removeChild(_aboutButton);
					break;
				case "AboutScreen" :
					_backButton.removeEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
					_weaponryButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeWeaponry);
					_shopButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeShop);
					_settingsButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeSettings);
					removeChild(_aboutScreen);
					_aboutScreen = null;
					removeChild(_backButton);
					removeChild(_weaponryButton);
					removeChild(_shopButton);
					removeChild(_settingsButton);
					break;
				case "InfiniteModeScreen" :
					removeChild(_infiniteModeView);
					break;
				case "EndScreen":
					_backButton.removeEventListener(TouchEvent.TOUCH_TAP, backButtonClick);
					_replayButton.removeEventListener(TouchEvent.TOUCH_TAP, initializeInfiniteMode);
					removeChild(_endScreen);
					removeChild(_backButton);
					removeChild(_replayButton);
					_controller.resetValues();
					break;
				default :
					trace("Program starting");
					break;
			}
		}
		/*
		* ANDROID STUFF FUNCTIONS
		*/
		//control what happens when the buttons are pressed
		private function onAndroidButtonClick(event:KeyboardEvent):void
		{
			_controller.processAndroidButtonClick(event);
		}
	}
}