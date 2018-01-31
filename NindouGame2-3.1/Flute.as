package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Flute extends MovieClip
	{
		public var attackUP:Boolean;
		public var attackDOWN:Boolean;
		public var attackLEFT:Boolean;
		public var attackRIGHT:Boolean;
		public var checkOugiOne:Boolean;
		public var checkOugiTwo:Boolean;
		public var ougiOne:Boolean;
		public var ougiTwo:Boolean;
		public var ougiThree:Boolean;
		public var ougiSignal:Boolean;
		public var invinsible:Boolean;
		private var _ougiTimer:Timer;
		
		public function Flute()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			stop();
			rotation = 360;
			//variables
			attackUP = false;
			attackDOWN = false;
			attackLEFT = false;
			attackRIGHT = false;
			checkOugiOne = false;
			checkOugiTwo = false;
			ougiOne = false;
			ougiTwo = false;
			ougiThree = false;
			ougiSignal = false;
			invinsible = false;
			
			//timer
			_ougiTimer = new Timer(1000);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_ougiTimer.addEventListener(TimerEvent.TIMER, onCountDown);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_ougiTimer.removeEventListener(TimerEvent.TIMER, onCountDown);
		}
		
		private function onEnterFrame(event:Event):void
		{
			//activate ougiOne
				if (enemyCollisionArea1 != null)
				{
					if (MovieClip(parent.parent).enemyBar.spText.text == "SP 1" && MovieClip(parent.parent).enemyBar.meter.width >= 40 && MovieClip(parent.parent).enemyBar.meter.width < 80)
					{
						if (checkOugiOne)
						{
							var randomNumber1:uint = Math.ceil(Math.random() * 250)
							if (randomNumber1 == 2)
							{
								ougiSignal = true;
								ougiOne = true;
								MovieClip(parent.parent).enemyBar.spText.text = "";
								MovieClip(parent.parent).enemyBar.meter.width = 0;
								checkOugiOne = false;
							}
						}
					}
				}
			//activate ougiTwo
				if (enemyCollisionArea2 != null)
				{
					if (MovieClip(parent.parent).enemyBar.spText.text == "SP 2" && MovieClip(parent.parent).enemyBar.meter.width >= 80 && MovieClip(parent.parent).enemyBar.meter.width < 120)
					{
						if (checkOugiTwo)
						{
							var randomNumber2:uint = Math.ceil(Math.random() * 2)
							if (randomNumber2 == 2)
							{
								ougiSignal = true;
								ougiTwo = true;
								MovieClip(parent.parent).enemyBar.spText.text = "";
								MovieClip(parent.parent).enemyBar.meter.width = 0;
								checkOugiTwo = false;
							}
						}
					}
				}
			//activate ougiThree
			if (MovieClip(parent.parent).enemyBar.spText.text == "SP 3" && MovieClip(parent.parent).enemyBar.meter.width >= 120)
			{
				if (! MovieClip(parent)._yoyo.invinsible)
				{
					ougiSignal = true;
					ougiThree = true;
					MovieClip(parent.parent).enemyBar.spText.text = "";
					MovieClip(parent.parent).enemyBar.meter.width = 0;
				}
			}
			
			//start ougiOne
			if (ougiOne && ! ougiSignal)
			{
				if (attackUP)
				{
					rotation = 180;
				}
				if (attackDOWN)
				{
					rotation = 360;
				}
				if (attackLEFT)
				{
					rotation = 90;
				}
				if (attackRIGHT)
				{
					rotation = 270;
				}
				
				invinsible = true;
				ougiOne = false;
				gotoAndPlay(11);
				MovieClip(parent.parent).checkOugiHit(this);
				_ougiTimer.start();
			}
			//start ougiTwo
			if (ougiTwo && ! ougiSignal)
			{
				invinsible = true;
				ougiTwo = false;
				gotoAndPlay(24);
				MovieClip(parent.parent).checkOugiHit(this);
				MovieClip(parent.parent).spBar.meter.width = 0;
				MovieClip(parent)._yoyo._isArmed = false;
				_ougiTimer.start();
			}
			//start ougiThree
			if (ougiThree && ! ougiSignal)
			{
				invinsible = true;
				ougiThree = false;
				gotoAndPlay(45);
				_ougiTimer.start();
			}
			
			//check to see if normal attack hit player
			if (attackUP || attackDOWN || attackLEFT || attackRIGHT)
			{
				MovieClip(parent.parent).hitPlayer(this);
			}
			
			//attack in all four directions
			if (currentFrame == 1)
			{
				if (attackUP)
				{
					rotation = 180;
					gotoAndPlay(2);
				}
				if (attackDOWN)
				{
					rotation = 360;
					gotoAndPlay(2);
				}
				if (attackLEFT)
				{
					rotation = 90;
					gotoAndPlay(2);
				}
				if (attackRIGHT)
				{
					rotation = 270;
					gotoAndPlay(2);
				}
			}
			//stop attacks
			if (currentFrame == 9)
			{
				if (attackUP)
				{
					gotoAndStop(1);
					attackUP = false;
				}
				if (attackDOWN)
				{
					gotoAndStop(1);
					attackDOWN = false;
				}
				if (attackLEFT)
				{
					gotoAndStop(1);
					attackLEFT = false;
				}
				if (attackRIGHT)
				{
					gotoAndStop(1);
					attackRIGHT = false;
				}
			}
			//stop ougiOne
			if (currentFrame == 22)
			{
				gotoAndStop(1);
			}
			//stop ougiTwo
			if (currentFrame == 43)
			{
				gotoAndStop(1);
			}
			//stop ougiThree
			if (currentFrame == 92)
			{
				gotoAndStop(1);
			}
		}
		
		private function onCountDown(event:TimerEvent):void
		{
			if (_ougiTimer.currentCount == 6)
			{
				invinsible = false;
				_ougiTimer.reset();
				_ougiTimer.stop();
			}
		}
	}
}