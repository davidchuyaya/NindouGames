package
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Yoyo extends MovieClip
	{
		
		public var _isArmed:Boolean;
		public var _rotating:Boolean;
		private var _ougiTimer:Timer;
		private var ougiStart:Boolean;
		private var ougiDirection:String;
		public var ougiOne:Boolean;
		public var ougiTwo:Boolean;
		public var ougiThree:Boolean;
		public var ougiSignal:Boolean;
		public var invinsible:Boolean;
		
		public function Yoyo()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			gotoAndStop(1);
			if (subObject != null)
			{
				subObject.stop();
			}
			_isArmed = false;
			_rotating = false;
			ougiDirection = null;
			ougiStart = false;
			ougiOne = false;
			ougiTwo = false;
			ougiThree = false;
			ougiSignal = false;
			invinsible = false;
			_ougiTimer = new Timer(1000);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onOugi);
			stage.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onRemovedFromStage(event:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onOugi);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onOugi(event:KeyboardEvent):void
		{
			if (_isArmed)
			{
			//ougi
			if (event.keyCode == Keyboard.SPACE)
			{
				if (MovieClip(parent) != null)
				{
					if (MovieClip(parent.parent).spBar.meter.width >= 40)
					{
						ougiStart = true;
					}
				}
			}
			}
			if (ougiStart)
			{
				//ougi 1
				if (MovieClip(parent.parent).spBar.spText.text == "SP 1" && MovieClip(parent.parent).spBar.meter.width >= 40 && MovieClip(parent.parent).spBar.meter.width < 80)
				{
					//choose directions
					stage.addEventListener(KeyboardEvent.KEY_UP, chooseDirection);
					
					//choose here
					function chooseDirection(event:KeyboardEvent):void
					{
						//up
						if (event.keyCode == Keyboard.W)
						{
							ougiDirection = "up";
						}
						//down
						if (event.keyCode == Keyboard.S)
						{
							ougiDirection = "down";
						}
						//left
						if (event.keyCode == Keyboard.A)
						{
							ougiDirection = "left";
						}
						//right
						if (event.keyCode == Keyboard.D)
						{
							ougiDirection = "right";
						}
						
						MovieClip(parent.parent).spBar.meter.width = 0;
						MovieClip(parent.parent).spBar.spText.text = "";
						ougiStart = false;
						ougiOne = true;
						ougiSignal = true;
						stage.removeEventListener(KeyboardEvent.KEY_UP, chooseDirection);
						stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
						stage.removeEventListener(KeyboardEvent.KEY_DOWN, onOugi);

					}
				}
				//ougi two
				else if (MovieClip(parent.parent).spBar.spText.text == "SP 2" && MovieClip(parent.parent).spBar.meter.width >= 80 && MovieClip(parent.parent).spBar.meter.width < 120)
				{
					//choose directions
					stage.addEventListener(KeyboardEvent.KEY_UP, chooseDirection2);
					//any direction
					function chooseDirection2(event:KeyboardEvent):void
					{
						if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.A || event.keyCode == Keyboard.S || event.keyCode == Keyboard.D)
						{
							MovieClip(parent.parent).spBar.meter.width = 0;
							MovieClip(parent.parent).spBar.spText.text = "";
							ougiStart = false;
							ougiTwo = true;
							ougiSignal = true;
							stage.removeEventListener(KeyboardEvent.KEY_UP, chooseDirection2);
							stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
							stage.removeEventListener(KeyboardEvent.KEY_DOWN, onOugi);

						}
					}
				}
				//ougi three
				else if (MovieClip(parent.parent).spBar.spText.text == "SP 3" && MovieClip(parent.parent).spBar.meter.width >= 120)
				{
					//choose directions
					stage.addEventListener(KeyboardEvent.KEY_UP, chooseDirection3);
					//any direction
					function chooseDirection3(event:KeyboardEvent):void
					{
						if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.A || event.keyCode == Keyboard.S || event.keyCode == Keyboard.D)
						{
							MovieClip(parent.parent).spBar.meter.width = 0;
							MovieClip(parent.parent).spBar.spText.text = "";
							ougiStart = false;
							ougiThree = true;
							ougiSignal = true;
							stage.removeEventListener(KeyboardEvent.KEY_UP, chooseDirection3);
							stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
							stage.removeEventListener(KeyboardEvent.KEY_DOWN, onOugi);

						}
					}
				}
				else
				{
					ougiStart = false;
					ougiDirection = null;
					gotoAndStop(1);
				}
			}
			
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.A || event.keyCode == Keyboard.S || event.keyCode == Keyboard.D)
			{
				if (_isArmed)
				{
					if (this != null)
					{
						if (! ougiStart || ! ougiOne)
						{
							_rotating = true;
						}
					}
				}
			}
		}
		private function onEnterFrame(event:Event):void
		{
			//stop ougiOne
			if (currentFrame == 31)
			{
				_ougiTimer.reset();
				
				gotoAndStop(1);
				ougiOne = false;
				ougiDirection = null;
				ougiDirection = "";
				_ougiTimer.addEventListener(TimerEvent.TIMER, onCountDown);
				_ougiTimer.start();
			}
			//stop ougiTwo
			if (currentFrame == 87)
			{
				_ougiTimer.reset();
				
				gotoAndStop(1);
				ougiTwo = false;
				_ougiTimer.addEventListener(TimerEvent.TIMER, onCountDown);
				_ougiTimer.start();
			}
			//stop ougiThree
			if (currentFrame == 165)
			{
				_ougiTimer.reset();
				
				gotoAndStop(1);
				ougiThree = false;
				_ougiTimer.addEventListener(TimerEvent.TIMER, onCountDown);
				_ougiTimer.start();
			}
			
			//make hand appear on yoyo
			if (_isArmed)
			{
				if (currentFrame == 1)
				{
					if (subObject != null)
					{
						subObject.gotoAndStop(2);
					}
				}
			}
			else
			{
				if (currentFrame == 1)
				{
					if (subObject != null)
					{
						subObject.gotoAndStop(1);
					}
				}
			}
			//attack rotation
			if (_rotating)
			{
				//stop rotating
				if (currentFrame == 42)
				{
					gotoAndStop(1);
					_rotating = false;
				}
				else if (currentFrame == 1)
				{
					gotoAndPlay(32);
					
					//check collision
					if (parent != null)
					{
						MovieClip(parent.parent).checkCollisionWithEnemies(this);
					}
				}
			}
			
			//******ougi stuff animation******
			if (ougiOne && (ougiSignal == false))
			{
				//ougi goes in direction
				//if it is up or down
				if (ougiDirection == "up")
				{
					rotation = 270;
					MovieClip(parent).player.gotoAndStop(2);
				}
				else if (ougiDirection == "down")
				{
					rotation = 90;
					MovieClip(parent).player.gotoAndStop(1);
				}
				
				//if it is left or right
				else if (ougiDirection == "left")
				{
					rotation = 180;
					MovieClip(parent).player.gotoAndStop(4);
				}
				else if (ougiDirection == "right")
				{
					rotation = 0;
					MovieClip(parent).player.gotoAndStop(3);
				}
				gotoAndPlay(2);
				ougiOne = false;
				invinsible = true;
				_rotating = false;
				ougiDirection = null;
				ougiDirection = "";
				//check collision
				if (parent != null)
				{
					MovieClip(parent.parent).checkCollisionWithEnemies(this);
				}
			}
			//******ougiTwo animation******
			if (ougiTwo && (ougiSignal == false))
			{
				gotoAndPlay(43);
				ougiTwo = false;
				invinsible = true;
				_rotating = false;
				
				//check collision
				if (parent != null)
				{
					MovieClip(parent.parent).checkCollisionWithEnemies(this);
				}
			}
			//******ougiThree animation******
			if (ougiThree && (ougiSignal == false))
			{
				ougiThree = false;
				gotoAndPlay(89);
				invinsible = true;
				_rotating = false;
				
				//check collision
				if (parent != null)
				{
					MovieClip(parent.parent).checkCollisionWithEnemies(this);
				}
			}
		}
		private function onCountDown(event:TimerEvent):void
		{
			if (! _isArmed)
			{
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onOugi);
				invinsible = false;
				_ougiTimer.removeEventListener(TimerEvent.TIMER, onCountDown);
				_ougiTimer.reset();
				_ougiTimer.stop();
			}
			
			if (MovieClip(parent.parent).story.visible == false || _isArmed)
			{
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onOugi);
			}
			
			if (_ougiTimer.currentCount == 7)
			{
				invinsible = false;
				_ougiTimer.removeEventListener(TimerEvent.TIMER, onCountDown);
				_ougiTimer.reset();
				_ougiTimer.stop();
			}
		}
		
		//getters & setters
		public function get isArmed():Boolean
		{
			return _isArmed;
		}
		public function set isArmed(weaponState:Boolean)
		{
			_isArmed = weaponState;
		}
	}
}