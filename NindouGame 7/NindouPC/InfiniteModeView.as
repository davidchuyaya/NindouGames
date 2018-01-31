package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;

	public class InfiniteModeView extends MovieClip
	{
		private var _model:Object;
		private var _controller:Object;
		//buttons
		private var _pauseButton = new PauseButton  ;
		private var _backButton = new BackButton  ;
		//movieclips
		private var _player = new Player  ;
		private var _explodingRockArray:Vector.<MovieClip >  = new Vector.<MovieClip >   ;
		private var _rockArray:Vector.<MovieClip >  = new Vector.<MovieClip >   ;
		private var _money1Array:Vector.<MovieClip >  = new Vector.<MovieClip >   ;
		private var _money2Array:Vector.<MovieClip >  = new Vector.<MovieClip >   ;
		private var _riceballArray:Vector.<MovieClip >  = new Vector.<MovieClip >   ;
		private var _soulOrbArray:Vector.<MovieClip >  = new Vector.<MovieClip >   ;
		private var _statusBar = new StatusBar  ;
		private var _ougiBar = new OugiBar  ;
		private var _healthBar = new HealthBar  ;
		private var _pauseScreen = new PauseScreen  ;
		//map stuff
		private var _mapContainer:Array = new Array  ;
		private var _mapChecker:MovieClip = new Rock  ;

		public function InfiniteModeView(model:Object, controller:Object):void
		{
			_model = model;
			_controller = controller;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//make the animated stuff stop first
			_ougiBar.stop();
			_healthBar.stop();
			_player.stop();
			//load the XML map;
			loadMap();
		}
		private function onAddedToStage(event:Event):void
		{
			_model.addEventListener(Event.CHANGE, onChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			initialize();
		}
		private function onChange(event:Event):void
		{
			//check gotostage
			if (_model.gotoStage == "InfiniteModeScreen")
			{
				//remove everything from the last stage
				removeEverything();
				_model.currentStage = "InfiniteModeScreen";
				_model.gotoStage = "";
			}
			//stuff to do
			switch (_model.currentStage)
			{
				case "InfiniteModeScreen" :
					loopPlayerAction();
					checkObstacles();
					barAnimations();
					//if _mapChecker is high enough, then build a new map
					if (_mapChecker.y <= 800)
					{
						addObstacles();
					}
					//set stuff
					_player.x = _model.playerPosition;
					_statusBar.score.text = String(_model.score);
					_statusBar.moneyEarned.text = String(_model.moneyEarned);
					_statusBar.traveledLength.text = String(_model.traveledLength);
					break;
				case "PauseScreen" :
					pauseEverything();
					break;
				default :
					trace("back to MainScreen / EndScreen");
					break;
			}
		}
		/*
		* GENERAL USE-ONCE-PER-INSTANTIATION FUNCTIONS
		*/
		private function initialize():void
		{
			//stick everything inside an array and give them names
			for (var i:uint = 0; i < _model.OBSTACLE_NUMBER; i++)
			{
				var explodingRock = new ExplodingRock  ;
				explodingRock.name = "explodingRock";
				_explodingRockArray.push(explodingRock);
				var rock = new Rock  ;
				rock.name = "rock";
				_rockArray.push(rock);
				var money1 = new Money1  ;
				money1.name = "money1";
				_money1Array.push(money1);
				var money2 = new Money2  ;
				money2.name = "money2";
				_money2Array.push(money2);
				var riceball = new Riceball  ;
				riceball.name = "riceball";
				_riceballArray.push(riceball);
				var soulOrb = new SoulOrb  ;
				soulOrb.name = "soulOrb";
				_soulOrbArray.push(soulOrb);
			}
			//stuff to add;
			addMovieClipWithAxis(_player, _model.PLAYER_INITIATE_X, _model.PLAYER_INITIATE_Y);
			addMovieClipWithAxis(_statusBar, 240, 15);
			addMovieClipWithAxis(_ougiBar, 200, 760);
			addMovieClipWithAxis(_healthBar, 200, 760);
			addButtonWithAxis(_pauseButton, 455, 775);
			//set mapChecker's y to 800 to start adding obstacles
			addChild(_mapChecker);
			_mapChecker.x = 600;
			_mapChecker.y = 800;
			_mapChecker.visible = false;
			//stop the bars & reset them
			_ougiBar.gotoAndStop(1);
			_ougiBar.bar.width = 0;
			_healthBar.gotoAndStop(1);
			_healthBar.bar.width = _model.healthFill;
			//event listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_pauseButton.addEventListener(MouseEvent.CLICK, onPauseClick);
			//reset the player
			_player.gotoAndPlay(1);
		}
		//load ze map from the XML file
		private function loadMap():void
		{
			//embed the XML
			[Embed(source = "../Map.xml",mimeType = "application/octet-stream")]
			var XmlData:Class;
			var totalMaps:Object = new XmlData();
			totalMaps = XML(totalMaps);

			//find out some info
			_model.mapNumber = totalMaps.map.length();

			//make the mapContainer a 2D array first
			for (var i:uint = 0; i < _model.mapNumber; i++)
			{
				var oneMap:Array = [];
				_mapContainer.push(oneMap);
			}

			//loop through all the stuff in the XML, copy it to an array
			var rowList:XMLList = totalMaps.map.row;
			var rowString:String;
			var rowArray:Array;
			var mapCounter:uint = 0;
			var rowCounter:uint = 0;
			for each (var row in rowList)
			{
				//convert text node into string
				rowString = row.toString();
				//split it into ones separated by commas
				rowArray = rowString.split(",");
				_mapContainer[mapCounter].push(rowArray);
				//add counters to figure out which map it should be;
				rowCounter++;
				if (rowCounter % _model.ROWS == 0)
				{
					mapCounter++;
				}
			}
		}
		/*
		* STUFF TO DO EVERY FRAME
		*/
		private function loopPlayerAction():void
		{
			//loop the action the player is currently doing
			if (_player.currentFrame == 10)
			{
				_player.gotoAndPlay(1);
			}
			else if (_player.currentFrame == 20)
			{
				_player.gotoAndPlay(11);
			}
			else if (_player.currentFrame == 30)
			{
				_player.gotoAndPlay(21);
			}
			//change which way the player is facing
			if (_model.playerPositionChange < 0 && _player.currentFrame < 21)
			{
				_player.gotoAndPlay(21);
			}
			else if (_model.playerPositionChange > 0 && (_player.currentFrame < 11 || _player.currentFrame > 20))
			{
				_player.gotoAndPlay(11);
			}
			else if (_model.playerPositionChange == 0 && _player.currentFrame > 10)
			{
				_player.gotoAndPlay(1);
			}
		}
		//make the health bar and the ougi bar change
		private function barAnimations():void
		{
			//make stuff local to save energy first
			const barMax:uint = _model.BAR_MAX_NUMBER;
			const barPercent:uint = barMax / 5;
			const ougiFill:uint = _model.ougiFill;
			const healthFill:uint = _model.healthFill;
			/*
			* BAR LENGTH SYNC WITH MODEL
			*/
			//make the bar slowly add up when _model.ougiFill increases (feel animation-y)
			if (ougiFill > _ougiBar.bar.width)
			{
				_ougiBar.bar.width++;
			}
			//make the health bar do the same
			if (healthFill > _healthBar.bar.width)
			{
				_healthBar.bar.width++;
			}
			if (healthFill < _healthBar.bar.width)
			{
				_healthBar.bar.width = healthFill;
			}
			/*
			* BAR STATUS AT CERTAIN POINTS
			*/
			//OUGI
			//less than 40%
			if (_ougiBar.bar.width < barPercent * 2)
			{
				_ougiBar.gotoAndStop(1);
			}
			//less than 60%
			else if (_ougiBar.bar.width < barPercent * 3)
			{
				_ougiBar.gotoAndStop(2);
			}
			//less than 80%
			else if (_ougiBar.bar.width < barPercent * 4)
			{
				_ougiBar.gotoAndStop(3);
			}
			//100%
			else if (_ougiBar.bar.width == barMax)
			{
				_ougiBar.gotoAndStop(4);
			}
			//HEALTH
			//more than 80%
			if (_healthBar.bar.width > barPercent * 4)
			{
				_healthBar.gotoAndStop(1);
			}
			//more than 60%
			else if (_healthBar.bar.width > barPercent * 3)
			{
				_healthBar.gotoAndStop(2);
			}
			//more than 40%
			else if (_healthBar.bar.width > barPercent * 2)
			{
				_healthBar.gotoAndStop(3);
			}
			//less than 40%
			else
			{
				_healthBar.gotoAndStop(4);
			}
		}
		private function addObstacles():void
		{
			//choose a map by random
			var mapToUse:uint = uint(Math.random() * _model.mapNumber);
			//build the map
			for (var row:uint = 0; row < _model.ROWS; row++)
			{
				for (var col:uint = 0; col < _model.COLUMNS; col++)
				{
					var currentTile:uint = _mapContainer[mapToUse][row][col];
					//if there is indeed something that is supposed to appear
					if (currentTile != _model.NAUGHT)
					{
						//a movieclip value to temporarily store the thing that will be put on the stage
						var thisArray:Vector.<MovieClip > ;

						switch (currentTile)
						{
							case _model.EXPLODING_ROCK :
								thisArray = _explodingRockArray;
								break;
							case _model.ROCK :
								thisArray = _rockArray;
								break;
							case _model.MONEY1 :
								thisArray = _money1Array;
								break;
							case _model.MONEY2 :
								thisArray = _money2Array;
								break;
							case _model.RICEBALL :
								thisArray = _riceballArray;
								break;
							case _model.SOUL_ORB :
								thisArray = _soulOrbArray;
								break;
							default :
								trace("Something is wrong with obstacles. Map " + mapToUse + ", Row " + row + ", Col " + col);
								break;
						}

						//set the object to the stage after knowing which array to use
						//choose which movieClip from the array to use
						var thisOne:uint = useThis(thisArray);
						//position the object - 800 y so that it will scroll up later
						if (thisOne != 5709)
						{
							addChildAt(thisArray[thisOne], getChildIndex(_player));
							thisArray[thisOne].x = col * _model.TILE_SIZE + 25;
							thisArray[thisOne].y = row * _model.TILE_SIZE + 800;
						}
						else
						{
							trace("Overload of obstacles, map " + mapToUse + ", " + thisArray[1]);
						}
					}
				}
			}
			_mapChecker.y = 1600;
			trace("Map " + mapToUse);
		}
		//checking whether obstacles should be removed this frame due to running out of the picture, or keep moving up
		private function checkObstacles():void
		{
			for (var i:uint = 0; i < _model.OBSTACLE_NUMBER; i++)
			{
				checkThis(_explodingRockArray[i]);
				checkThis(_rockArray[i]);
				checkThis(_money1Array[i]);
				checkThis(_money2Array[i]);
				checkThis(_riceballArray[i]);
				checkThis(_soulOrbArray[i]);
			}
			_mapChecker.y -=  _model.playerSpeed;
		}
		//when the pause button is pressed...
		private function pauseEverything():void
		{
			_player.stop();
			addMovieClipWithAxis(_pauseScreen, 240, 415);
			addButtonWithAxis(_backButton, 25, 775);
			_backButton.addEventListener(MouseEvent.CLICK, backButtonClick);
			//stop arrow keys from working;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			//push the pause button to the highest order (for it to be clickable)
			_pauseButton.parent.setChildIndex(_pauseButton, _pauseButton.parent.getChildIndex(_pauseButton) + 1);
		}
		/*
		* REUSABLE FUNCTIONS
		*/
		private function addMovieClipWithAxis(movieClip:MovieClip, xValue:uint, yValue:uint):void
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
		//check to see which movieclip from an array should be used
		private function useThis(array:Vector.<MovieClip>):uint
		{
			for (var i:uint = 0; i < _model.OBSTACLE_NUMBER; i++)
			{
				if (! this.contains(array[i]))
				{
					return i;
				}
			}
			//because 5709 kind of looks like STOP?
			return 5709;
		}
		//check to see if a movieclip should be removed
		private function checkThis(movieClip:MovieClip, remove:Boolean = false):void
		{
			if (this.contains(movieClip))
			{
				//removes the obstacle
				if (movieClip.y <= -25 || remove)
				{
					removeChild(movieClip);
				}
				else if (_player.box1.hitTestObject(movieClip.box) || _player.box2.hitTestObject(movieClip.box))
				{
					_controller.processHitTest(movieClip.name);
					removeChild(movieClip);
				}
				else
				{
					//move the obstacles up
					movieClip.y -=  _model.playerSpeed;
				}
			}
		}
		/*
		* REMOVERS
		*/
		private function removeEverything():void
		{
			switch (_model.currentStage)
			{
				case "PauseScreen" :
					stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
					stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					_backButton.removeEventListener(MouseEvent.CLICK, backButtonClick);
					removeChild(_pauseScreen);
					removeChild(_backButton);
					//push pausebutton back to where it was
					_pauseButton.parent.setChildIndex(_pauseButton, _pauseButton.parent.getChildIndex(_pauseButton) - 1);
					_player.play();
					break;
				default :
					trace("you called removeEverything in infiniteModeView with a weird currentStage");
					break;
			}
		}
		//clear the obstacle arrays
		private function clearArray(array:Vector.<MovieClip>):void
		{
			for (var i:uint = 0; i < _model.OBSTACLE_NUMBER; i++)
			{
				if (this.contains(array[i]))
				{
					removeChild(array[i]);
				}
			}
			array.length = 0;
		}
		private function onRemovedFromStage(event:Event):void
		{
			//removeEventListener
			_pauseButton.removeEventListener(MouseEvent.CLICK, onPauseClick);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_model.removeEventListener(Event.CHANGE, onChange);
			//remove Objects
			clearArray(_explodingRockArray);
			clearArray(_rockArray);
			clearArray(_money1Array);
			clearArray(_money2Array);
			clearArray(_riceballArray);
			clearArray(_soulOrbArray);
			removeChild(_player);
			removeChild(_statusBar);
			removeChild(_ougiBar);
			removeChild(_healthBar);
			removeChild(_pauseButton);
			removeChild(_mapChecker);
			//remove the following if the screen is PauseScreen
			if (this.contains(_pauseScreen))
			{
				_backButton.removeEventListener(MouseEvent.CLICK, backButtonClick);
				removeChild(_pauseScreen);
				removeChild(_backButton);
			}
		}
		/*
		* STUFF TO GIVE TO THE CONTROLLER
		*/
		private function onKeyDown(event:KeyboardEvent):void
		{
			_controller.processKeyDown(event);
		}
		private function onKeyUp(event:KeyboardEvent):void
		{
			_controller.processKeyUp(event);
		}
		private function onPauseClick(event:MouseEvent):void
		{
			_controller.processPauseClick();
		}
		private function backButtonClick(event:MouseEvent):void
		{
			_controller.endGamePlay("MainScreen");
		}
	}
}