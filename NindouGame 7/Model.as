package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		//strings
		public var currentStage:String = "";
		public var gotoStage:String = "";
		//numbers
		public const PLAYER_INITIATE_X:uint = 190;
		public const PLAYER_INITIATE_Y:uint = 93;
		public const BAR_MAX_NUMBER:uint = 125;
		public const OBSTACLE_NUMBER:uint = 10;
		private const Y_ACCELERATION:Number = 0.2;
		//stuff to do with the player's speed
		private const PLAYER_INITIATE_SPEED:uint = 7;
		public const ORIGINAL_SCOOCH:uint = 64;
		public var scooch:uint = ORIGINAL_SCOOCH;
		public const X_LIMIT:uint = 32;
		public const ORIGINAL_MIN_SCOOCH:uint = 4;
		public var minScooch:uint = ORIGINAL_MIN_SCOOCH;
		private var _playerPosition:Number = PLAYER_INITIATE_X;
		public var playerPositionChange:Number = 0; //note: playerPositionChange public only in android version
		private var _playerSpeed:Number = PLAYER_INITIATE_SPEED;
		//stuff that changes in the game
		private var _traveledLength:uint = 0;
		private var _score:uint = 0;
		private var _moneyEarned:uint = 0;
		private var _ougiFill:uint = 0;
		private var _healthFill:uint = BAR_MAX_NUMBER;
		//stuff that needs to be saved
		private var _money:uint;
		//map stuff
		public const NAUGHT:uint = 0;
		public const EXPLODING_ROCK:uint = 1;
		public const ROCK:uint = 2;
		public const MONEY1:uint = 3;
		public const MONEY2:uint = 4;
		public const RICEBALL:uint = 5;
		public const SOUL_ORB:uint = 6;
		public const TILE_SIZE:uint = 80;
		public const COLUMNS:uint = 6;
		public const ROWS:uint = 10;
		public var mapNumber:uint;
		
		public function Model():void
		{
		}
		public function update():void
		{
			//what to do when the game begins on every frame
			if (currentStage == "InfiniteModeScreen")
			{
				_playerPosition += playerPositionChange;
				_traveledLength += 1;
				//increase the y axis speed
				increaseSpeed();
				if (_traveledLength % 10 == 0)
				{
					_score += 1;
				}
				//loop the player around the screen
				if (_playerPosition > 436)
				{
					_playerPosition = -44;
				}
				else if (_playerPosition < -44)
				{
					_playerPosition = 436;
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function increaseSpeed():void
		{
			if (_traveledLength < 1000)
			{
				//speed up every 50m if total traveled is less than 1000
				if (_traveledLength % 50 == 0)
				{
					_playerSpeed += Y_ACCELERATION;
				}
			}
			else if (_traveledLength < 10000)
			{
				//speed up every 100m if total traveled is in the thousands
				if (_traveledLength % 100 == 0)
				{
					_playerSpeed += Y_ACCELERATION;
				}
			}
			else
			{
				//speed up every 1000m if total traveled is in the ten thousands or more
				if (_traveledLength % 1000 == 0)
				{
					_playerSpeed += Y_ACCELERATION;
				}
			}
		}
		/*
		* RESETTING FUNCTIONS
		*/
		public function resetPlayerPosition():void
		{
			_playerPosition = PLAYER_INITIATE_X;
		}
		public function resetPlayerPositionChange():void
		{
			playerPositionChange = 0;
		}
		public function resetPlayerSpeed():void
		{
			_playerSpeed = PLAYER_INITIATE_SPEED;
		}
		public function resetScore():void
		{
			_score = 0;
		}
		public function resetMoneyEarned():void
		{
			_moneyEarned = 0;
		}
		public function resetOugiFill():void
		{
			_ougiFill = 0;
		}
		public function resetHealthFill():void
		{
			_healthFill = BAR_MAX_NUMBER;
		}
		public function resetTraveledLength():void
		{
			_traveledLength = 0;
		}
		/*
		* FUNCTIONS THAT ACTUALLY DO SOME STUFF, BUT STILL SHOULD BE UNTOUCHABLE
		*/
		//at the end of a game, add the money earned to the total amount that will be saved
		public function addMoney():void
		{
			_money += _moneyEarned;
		}
		public function addToScore(thisMuch:uint):void
		{
			_score += thisMuch;
		}
		//add some money each time you get one in the game
		public function addToMoneyEarned(thisMuch:uint):void
		{
			_moneyEarned += thisMuch;
		}
		public function addToOugiFill(thisMuch:uint):void
		{
			//check first to see that it doesn't extend farther than the max #
			if (_ougiFill + thisMuch < BAR_MAX_NUMBER)
			{
				_ougiFill += thisMuch;
			}
			else
			{
				_ougiFill = BAR_MAX_NUMBER;
			}
		}
		public function addToHealth(thisMuch:int):void
		{
			//store what the new healthFill will be
			var result:int = _healthFill + thisMuch;
			//normal
			if (result < BAR_MAX_NUMBER && result > 0)
			{
				_healthFill = result;
			}
			//don't have enough health left, then go to zero
			else if (result <= 0)
			{
				_healthFill = 0;
			}
			//fill up to the brim!
			else
			{
				_healthFill = BAR_MAX_NUMBER;
			}
		}
		/*
		* GETTERS AND SETTERS
		*/
		//change the player's position
		public function get playerPosition():int
		{
			return _playerPosition;
		}
		//see the values during the game
		public function get playerSpeed():Number
		{
			return _playerSpeed;
		}
		public function get score():uint
		{
			return _score;
		}
		public function get moneyEarned():uint
		{
			return _moneyEarned;
		}
		public function get money():uint
		{
			return _money;
		}
		public function get ougiFill():uint
		{
			return _ougiFill;
		}
		public function get healthFill():uint
		{
			return _healthFill;
		}
		public function get traveledLength():uint
		{
			return _traveledLength;
		}
	}
}