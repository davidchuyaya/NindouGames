package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	
	public class Main extends MovieClip
	{
		//the actual movieClip stuff
		var enemy1Animation = new Enemy1Animation;
		var enemy2Animation = new Enemy2Animation;
		var story = new Story();
		var tank = new Tank();
		var ghost = new Ghost();
		var shieldToken = new ShieldToken();
		var shield = new Shield();
		//other variables that I need to use
		var vx:int;
		var enemy1AnimationDone:Boolean;
		var enemy2AnimationDone:Boolean;
		var enemy2CreationY:uint;
		var addLifeRequiredScore:uint;
		var notInitialCreation:Boolean;
		var enemySuicide:Boolean;
		var shieldInitiate:Boolean;
		var shieldOn:Boolean;
		public var gameDone:Boolean;
		public var enemy1Array:Array = new Array();
		public var enemy2Array:Array = new Array();
		public var enemy3Array:Array = new Array();
		public var score:int;
		public var enemy2ShootingX:Number;
		public var enemy2ShootingY:Number;
		public var bulletFired:Boolean;
		public var tankLife:int;
		public var ghostLife:int;
		public var creationNumber:int;
		var secondStage:Boolean;
		public var finalStage:Boolean;
		//the timer for ending the game
		var timer = new Timer(1000);
		//timer for shield tokens
		var shieldTimer = new Timer(1000);
		
		//make the enemies
		private function enemy1Creation():void
		{
			for (var i:uint = 1; i <= 10; i++)
			{
				var enemy1:MovieClip = new Enemy1();
				addChild(enemy1);
				enemy1Array[i] = enemy1;
				enemy1Array[i].x = i*50;
				enemy1Array[i].y = 50;
			}
		}
		//make the enemies (2)
		private function enemy2Creation():void
		{
			for (var i:uint = 1; i <= 10; i++)
			{
				var enemy2:MovieClip = new Enemy2();
				addChild(enemy2);
				enemy2Array[i] = enemy2;
				enemy2Array[i].x = i*50;
				//the enemy2CreationY increases by 50 every time the whole array dies, so they get closer to the player
				enemy2Array[i].y = enemy2CreationY;
			}
		}
		
		public function Main()
		{
			addChild(story);
			story.visible = true;
			story.gotoAndStop(1);
			story.addEventListener(MouseEvent.CLICK, onStoryClick);
		}
		public function init()
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			shieldTimer.addEventListener(TimerEvent.TIMER, onShieldTimer);
			
			enemy1AnimationDone = false;
			enemy2AnimationDone = false;
			gameDone = false;
			bulletFired = false;
			notInitialCreation = false;
			secondStage = false;
			finalStage = false;
			enemySuicide = false;
			shieldInitiate = false;
			shieldOn = false;
			vx = 0;
			enemy2CreationY = 100;
			addLifeRequiredScore = 100;
			tankLife = 30;
			ghostLife = 40;
			creationNumber = 1;
			timer.start();
			shieldTimer.start();
			
			player.x = 275;
			player.y = 375;
			
			tank.visible = false;
			tank.gotoAndStop(1);
			backGround.gotoAndStop(1);
			
			//show the enemies suddenly appearing
			addChild(enemy1Animation);
			enemy1Animation.x = 50;
			enemy1Animation.y = 50;
			enemy1Animation.play();
			//show enemy 2s suddenly appearing
			addChild(enemy2Animation);
			enemy2Animation.x = 50;
			enemy2Animation.y = 100;
			enemy2Animation.play();
			
			//set score back to zero
			score = 0;
			scoreMeter.textArea.text = "";
		}
		
		private function onEnterFrame(event:Event):void
		{
			//make the score meter display the score
			scoreMeter.textArea.text = "" + score;
			
			if (shieldInitiate)
			{
				addChild(shield);
				shield.visible = true;
				shield.x = player.x;
				shield.y = player.y;
				
				shieldInitiate = false;
				shieldOn = true;
				shieldTimer.reset();
				shieldTimer.start();
			}
			
			//if the timer runs out, you lose
			if (timeText.text == "0")
			{
				LoseGame();
			}
			
			//the background stops
			if (backGround.currentFrame == 34)
			{
				backGround.gotoAndStop(35);
			}
			
			//add lives whenever the score reaches the 100 mark (and then the 200th, so on, so forth)
			if (score > addLifeRequiredScore)
			{
				if (life5.visible && ! life4.visible)
				{
					life4.visible = false;
				}
				else if (life5.visible && life4.visible && ! life3.visible)
				{
					life3.visible = true;
				}
				else if (life5.visible && life4.visible && life3.visible && ! life2.visible)
				{
					life2.visible = true;
				}
				else if (life5.visible && life4.visible && life3.visible && life2.visible && ! life1.visible)
				{
					life1.visible = true;
				}
				
				addLifeRequiredScore += 100;
			}
			
			//add the real enemies when the enemy1Animation is done
			if (enemy1Animation.currentFrame == 20)
			{
				enemy1Creation();
				enemy1Animation.gotoAndStop(1);
				removeChild(enemy1Animation); 
				enemy1AnimationDone = true;
			}
			if (enemy2Animation.currentFrame == 20)
			{
				enemy2Creation();
				enemy2Animation.gotoAndStop(1);
				removeChild(enemy2Animation);
				enemy2AnimationDone = true;
			}
			
			//kill the tank if its life is over, and proceed to 3rd level (last stage)
			if (tank != null && tankLife <= 1 && tank.visible && ! finalStage)
			{
				removeChild(tank);
				tank.visible = false;
				secondStage = false;
				timer.reset();
				//get rid of the shield
				shieldTimer.reset();
				shield.visible = false;
				shieldOn = false;
				//stop you from using weapons
				bulletFired = true;
				
				//add the story
				addChild(story);
				story.visible = true;
				story.gotoAndStop(7);
			}
			//kill the ghost if its life is over
			if (ghost != null && ghostLife <= 1 && ghost.visible)
			{
				removeChild(ghost);
				ghost.visible = false;
				
				gameDone = true;
				WinGame();
			}
			
			//see if there are no more enemies and add more or go to second level by adding tank
			if (enemy1Array.length == 1  && enemy1AnimationDone)
			{
				//add the story the second time
				addChild(story);
				story.visible = true;
				story.gotoAndStop(4);
				clearEnemies();
				enemySuicide = true;
				timer.reset();
				//get rid of the shield
				shieldTimer.reset();
				shield.visible = false;
				shieldOn = false;
				//stop you from shooting
				bulletFired = true;
			}
			if (enemy2Array.length == 1 && enemy2AnimationDone)
			{
				enemy2CreationY += 50;
				addChild(enemy2Animation);
				enemy2Animation.y = enemy2CreationY;
				enemy2Animation.play();
				notInitialCreation = true;
				enemy2AnimationDone = false;
			}
			
			//see if there are any enemies touching the player
			for (var i:uint = 1; i <= 10; i++)
			{
				if (enemy2Array[i] != null && enemy2Array[i].visible && enemy2Array[i].body.hitTestObject(player))
				{
					enemy2Array[i].visible = false;
					enemy2Array.splice(i, 1);
					
					if (! shieldOn)
					{
						cutLives();
					}
				}
				
				if (enemy3Array[i] != null && enemy3Array[i].visible && enemy3Array[i].body.hitTestObject(player))
				{
					enemy3Array[i].visible = false;
					enemy3Array.splice(i, 1);
					
					if (! shieldOn)
					{
						cutLives();
					}
				}
			}
			
			//wrap the player around the stage
			if (player.x >= 550)
			{
				player.x = 0;
			}
			else if (player.x <= 0)
			{
				player.x = 550;
			}
			//wrap the shield too
			if (shield != null && shield.visible && shieldOn)
			{
				if (shield.x >= 550)
				{
					shield.x = 0;
				}
				else if (shield.x <= 0)
				{
					shield.x = 550;
				}
			}
			
			//You lose the game when you have no more lives
			if (! life1.visible && ! life2.visible && ! life3.visible && ! life4.visible && ! life5.visible)
			{
				LoseGame();
			}
			
			//add velocity to player
			player.x += vx;
			//add velocity to shield if it is on
			if (shieldOn && shield != null && shield.visible)
			{
				shield.x += vx;
			}
		}
		public function onTimer(event:TimerEvent):void
		{
			//change the timeText to the time remaining
			//first stage
			if (! secondStage && ! finalStage)
			{
				timeText.text = "" + (40 - timer.currentCount);
			}
			//second stage
			else if (secondStage && ! finalStage)
			{
				timeText.text = "" + (80 - timer.currentCount);
			}
			//final stage
			else if (! secondStage && finalStage)
			{
				timeText.text = "" + (480 - timer.currentCount);
			}
		}
		public function onShieldTimer(event:Event):void
		{
			//let a token start falling when it is time
			if (shieldTimer.currentCount == 17 && ! shieldOn)
			{
				shieldToken.visible = true;
				addChild(shieldToken);
				shieldToken.x = Math.floor(Math.random()*400);
				shieldToken.y = 0;
				shieldTimer.reset();
				shieldTimer.start();
			}
			
			//the shield disappears after a while
			if (shieldOn && shieldTimer.currentCount == 10)
			{
				shield.visible = false;
				removeChild(shield);
				shieldOn = false;
			}
		}
		
		public function onKeyDown(event:KeyboardEvent):void
		{
			//can move player by using the keyboard
			if (event.keyCode == Keyboard.LEFT)
			{
				vx = -5;
			}
			if (event.keyCode == Keyboard.RIGHT)
			{
				vx = 5;
			}
		}
		public function onKeyUp(event:KeyboardEvent):void
		{
			//stop player when the keys are no longer pressed
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				vx = 0;
			}
			//fire bullets!!!
			if (event.keyCode == Keyboard.SPACE)
			{
				//don't let another bullet be fired if there is already one on the screen
				if (! bulletFired)
				{
					bulletFired = true;
					addChild(new Bullet());
				}
			}
		}
		//destroy the enemies when they need to be destroyed
		public function killEnemy1(bullet:MovieClip)
		{
			//record the bullet number
			var enemy1Killed:uint = uint(bullet.name);
			//kill the enemy that the bullet "hit"
			if (enemy1Array[enemy1Killed] != null && enemy1Array[enemy1Killed].visible)
			{
				enemy1Array[enemy1Killed].visible = false;
				enemy1Array.splice(enemy1Killed, 1);
			}
			//remove the bullet
			removeChild(bullet);
			bullet = null;
			//add score
			score += 5;
		}
		//destroy the enemies when they need to be destroyed
		public function killEnemy2(bullet:MovieClip)
		{
			//record the bullet number
			var enemy2Killed:uint = uint(bullet.name);
			//kill the enemy that the bullet "hit"
			if (enemy2Array[enemy2Killed] != null && enemy2Array[enemy2Killed].visible)
			{
				enemy2Array[enemy2Killed].visible = false;
				enemy2Array.splice(enemy2Killed, 1);
			}
			//remove the bullet
			removeChild(bullet);
			bullet = null;
			//add score
			score += 5;
		}
		//destroy the enemies when they need to be destroyed
		public function killEnemy3(bullet:MovieClip)
		{
			//record the bullet number
			var enemy3Killed:uint = uint(bullet.name);
			//kill the enemy that the bullet "hit"
			if (enemy3Array[enemy3Killed] != null && enemy3Array[enemy3Killed].visible)
			{
				enemy3Array[enemy3Killed].visible = false;
				enemy3Array.splice(enemy3Killed, 1);
			}
			//remove the bullet
			removeChild(bullet);
			bullet = null;
			//add score
			score += 5;
		}
		//destroy the bullets when they go off screen
		public function killChild(child:MovieClip)
		{
			removeChild(child);
			child = null;
		}
		
		//YA LOSE DA GAME!!
		public function LoseGame()
		{
			addChild(story);
			story.visible = true;
			//choose which ending to play depending on which stage you died in
			if (finalStage)
			{
				story.gotoAndPlay(11);
			}
			else
			{
				story.gotoAndStop(61);
				story.textArea.text = "" + score;
			}
			
			gameDone = true;
			//add a new Enterframe event listener for the score
			addEventListener(Event.ENTER_FRAME, endEnterFrame);
			//clear every enemy
			clearEnemies();
			if (tank != null && tank.visible)
			{
				tank.visible = false;
			}
			if (ghost != null && ghost.visible)
			{
				ghost.visible = false;
			}
			
			timer.stop();
			shieldTimer.stop();
			//kill every event listener
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			shieldTimer.removeEventListener(TimerEvent.TIMER, onShieldTimer);
		}
		
		//YA WIN DA GAME!!
		public function WinGame()
		{
			addChild(story);
			story.visible = true;
			story.gotoAndPlay(61);
			gameDone = true;
			//add to score based on lives remaining
			if (life1.visible)
			{
				score += 300;
			}
			else if (! life1.visible && life2.visible)
			{
				score += 200;
			}
			else if (! life1.visible && ! life2.visible && life3.visible)
			{
				score += 100;
			}
			else if (! life1.visible && ! life2.visible && ! life3.visible && life4.visible)
			{
				score += 50;
			}
			
			//add a new EnterFrame event listener for the score
			addEventListener(Event.ENTER_FRAME, endEnterFrame);
			//clear every enemy
			clearEnemies();
			if (tank != null && tank.visible)
			{
				tank.visible = false;
			}
			if (ghost != null && ghost.visible)
			{
				ghost.visible = false;
			}
			
			timer.stop();
			shieldTimer.stop();
			//kill every event listener
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			shieldTimer.removeEventListener(TimerEvent.TIMER, onShieldTimer);
		}
		
		//let the enemy2 start shooting
		public function enemy2Shoot(enemy:MovieClip)
		{
			enemy2ShootingX = enemy.x;
			enemy2ShootingY = enemy.y;
			
			addChild(new EnemyBullet());
		}
		
		//remove the enemies remaining
		public function clearEnemies()
		{
			for (var i:uint = 1; i <= 10; i++)
			{
				if (enemy1Array[i] != null && enemy1Array[i].visible)
				{
					enemy1Array[i].visible = false;
					enemy1Array.splice(i, 1);
				}
				if (enemy2Array[i] != null && enemy2Array[i].visible)
				{
					enemy2Array[i].visible = false;
					enemy2Array.splice(i, 1);
				}
				if (enemy3Array[i] != null && enemy3Array[i].visible)
				{
					enemy3Array[i].visible = false;
					enemy3Array.splice(i, 1);
				}
			}
			
			//make sure the animationDone stuff is all false so their revival doesn't trigger
			enemy1AnimationDone = false;
			enemy2AnimationDone = false;
		}
		
		//minus the amout of lives
		public function cutLives()
		{
			if (life1.visible)
			{
				life1.visible = false;
			}
			else if (! life1.visible && life2.visible)
			{
				life2.visible = false;
			}
			else if (! life1.visible && ! life2.visible && life3.visible)
			{
				life3.visible = false;
			}
			else if (! life1.visible && ! life2.visible && ! life3.visible && life4.visible)
			{
				life4.visible = false;
			}
			else if (! life1.visible && ! life2.visible && ! life3.visible && ! life4.visible && life5.visible)
			{
				life5.visible = false;
			}
		}
		
		//create enemy3s on Ghost's command
		public function createEnemy3()
		{
			var enemy3:MovieClip = new Enemy3();
			addChild(enemy3);
			enemy3Array[creationNumber] = enemy3;
			
			if (creationNumber == 10)
			{
				creationNumber = 1;
			}
			else
			{
				creationNumber += 1;
			}
			
			enemy3.x = Math.floor(Math.random() * 550);
			enemy3.y = 150;
		}
		
		//show the score at the end of the game
		public function endEnterFrame(event:Event):void
		{
			if (story != null && story.currentFrame == 60)
			{
				story.gotoAndStop(61);
				removeEventListener(Event.ENTER_FRAME, endEnterFrame);
				
				story.textArea.text = "" + score;
			}
			else if (story != null && story.currentFrame == 130)
			{
				story.gotoAndStop(131);
			}
		}
		
		//the story event listener
		public function onStoryClick(event:Event):void
		{
			if (story != null && story.visible)
			{
				if (story.currentFrame == 1)
				{
					story.gotoAndStop(2);
				}
				else if (story.currentFrame == 2)
				{
					removeChild(story);
					story.visible = false;
					//the game actually starts here
					init();
				}
				else if (story.currentFrame == 4)
				{
					story.gotoAndStop(5);
				}
				else if (story.currentFrame == 5)
				{
					removeChild(story);
					story.visible = false;
					//go to the second stage
					secondStage = true;
					timer.start();
					shieldTimer.start();
					//you can start firing bullets now
					bulletFired = false;
					//DA TANK appears!!!!!!!!!!!!!!!!
					addChild(tank);
					tank.visible = true;
					tank.x = 275;
					tank.y = 50;
				}
				else if (story.currentFrame == 7)
				{
					story.gotoAndStop(8);
				}
				else if (story.currentFrame == 8)
				{
					story.gotoAndStop(9);
				}
				else if (story.currentFrame == 9)
				{
					removeChild(story);
					story.visible = false;
					//go to the third stage
					timer.start();
					shieldTimer.start();
					//you can start firing bullets now
					bulletFired = false;
					//3rd level stuff
					enemySuicide = false;
					addChild(ghost);
					ghost.x = 275;
					ghost.y = 40;
					finalStage = true;
				}
				else if (story.currentFrame == 131)
				{
					//end of the game
					story.gotoAndStop(132);
					story.textArea.text = "" + score;
					removeEventListener(Event.ENTER_FRAME, endEnterFrame);
				}
			}
		}
	}
}