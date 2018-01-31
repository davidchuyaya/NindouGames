package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Main extends MovieClip
	{
		var dungeonOne = new DungeonOne_Manager();
		var dungeonTwo = new DungeonTwo_Manager();
		var dungeonThree = new DungeonThree_Manager();
		var story = new Story();
		var _dungeonOneWon:Boolean;
		var _dungeonTwoWon:Boolean;
		var spBar = new SpBar();
		var health = new Health();
		var enemyBar = new SpBar();
		var i:uint;
		
		public function Main()
		{
			i = 1;
			
			_dungeonOneWon = false;
			_dungeonTwoWon = false;
			addChild(story);
			story.stop();
			addChild(spBar);
			spBar.x = 83;
			spBar.y = 58;
			spBar.visible = false;
			addChild(health);
			health.x = 6.5;
			health.y = 31.1;
			health.visible = false;
			addChild(enemyBar);
			enemyBar.x = 275;
			enemyBar.y = 350;
			enemyBar.visible = false;
			
			//event listeners
			stage.addEventListener(MouseEvent.CLICK, onStoryClick);
		}
		
		//flip through the story part
		private function onStoryClick(event:MouseEvent):void
		{
			if (story.visible == true)
			{
				i++;
				story.gotoAndStop(i);
					
				if (i == 7)
				{
					addChild(dungeonOne);
					removeChild(story);
					story.visible = false;
					stage.removeEventListener(MouseEvent.CLICK, onStoryClick);
					
					spBar.visible = true;
					health.visible = true;
				}
			}
		}
		private function onStoryClick2(event:MouseEvent):void
		{
			if (story.visible == false)
			{
				i = 7;
				health.visible = false;
				spBar.visible = false;
			}
			
			story.visible = true;
			if (story.visible == true)
			{
				i++;
				story.gotoAndStop(i);
				
				if (i == 15)
				{
					addChild(dungeonThree);
					removeChild(story);
					story.visible = false;
					stage.removeEventListener(MouseEvent.CLICK, onStoryClick2);
					
					health.visible = true;
					spBar.visible = true;
				}
			}
		}
		private function onStoryClick3Lost(event:MouseEvent):void
		{
			if (story.visible == false)
			{
				i = 19;
				removeChild(health);
				health = null;
				removeChild(spBar);
				spBar = null;
			}
			
			story.visible = true;
			
			if (story.visible == true)
			{
				i++;
				story.gotoAndStop(i);
				
				if (i == 25)
				{
					stage.removeEventListener(MouseEvent.CLICK, onStoryClick3Lost);
				}
			}
		}
		private function onStoryClick3Won(event:MouseEvent):void
		{
			if (story.visible == false)
			{
				i = 15;
				removeChild(health);
				health = null;
				removeChild(spBar);
				spBar = null;
			}
			
			story.visible = true;
			
			if (story.visible == true)
			{
				i++;
				story.gotoAndStop(i);
				
				if (i == 19)
				{
					story.gotoAndStop(23);
					i = 23;
				}
				if (i == 25)
				{
					stage.removeEventListener(MouseEvent.CLICK, onStoryClick3Won);
				}
			}
		}
		
		//Let wall check if player is colliding with them
		public function checkCollisionWithPlayer(wall:MovieClip)
		{
			if (dungeonOne.player != null)
			{
			Collision.block(dungeonOne.player, wall);
			}
			if (dungeonTwo.player != null)
			{
			Collision.block(dungeonTwo.player, wall);
			}
		}
		public function enemyCheckCollisionWithWall(wall:MovieClip)
		{
			//if enemy three isn't dead
			if (dungeonTwo.enemyThree != null)
			{
				Collision.block(dungeonTwo.enemyThree, wall);
			}
			//if enemy four isn't dead
			if (dungeonTwo.enemyFour != null)
			{
				Collision.block(dungeonTwo.enemyFour, wall);
			}
		}
		//check to see if yoyo hits any enemy except for rats
		public function checkCollisionWithEnemies(yoyo:MovieClip)
		{
			if (yoyo.isArmed)
			{
				//EnemyOne
				if (dungeonOne.enemyOne != null)
				{
					if (dungeonOne.enemyOne.subObject.meter.width >= 1)
					{
						if (yoyo.collisionArea != null)
						{
							if (dungeonOne.enemyOne.hitTestObject(yoyo.collisionArea))
							{
								dungeonOne.enemyOne.subObject.meter.width -= 5;
						
								if (yoyo.ougiOne == false && yoyo.ougiTwo == false && yoyo.ougiThree == false)
								{
									spBar.meter.width += 1;
								}
							}
						}
						//ougi damage
						if (yoyo.collisionArea1 != null)
						{
							if (dungeonOne.enemyOne.hitTestObject(yoyo.collisionArea1))
							{
								dungeonOne.enemyOne.subObject.meter.width -= 10;
							}
						}
						if (yoyo.collisionArea2 != null)
						{
							if (dungeonOne.enemyOne.hitTestObject(yoyo.collisionArea2))
							{
								dungeonOne.enemyOne.subObject.meter.width -= 15;
							}
						}
						if (yoyo.collisionArea3 != null)
						{
							if (dungeonOne.enemyOne.hitTestObject(yoyo.collisionArea3))
							{
								dungeonOne.enemyOne.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea4 != null)
						{
							if (dungeonOne.enemyOne.hitTestObject(yoyo.collisionArea4))
							{
								dungeonOne.enemyOne.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea5 != null)
						{
							if (dungeonOne.enemyOne.hitTestObject(yoyo.collisionArea5))
							{
								dungeonOne.enemyOne.subObject.meter.width -= 30;
							}
						}
					}
				}
				//EnemyTwo
				if (dungeonOne.enemyTwo != null)
				{
					if (dungeonOne.enemyTwo.subObject.meter.width >= 1)
					{
						if (yoyo.collisionArea != null)
						{
							if (dungeonOne.enemyTwo.hitTestObject(yoyo.collisionArea))
							{
								dungeonOne.enemyTwo.subObject.meter.width -= 5;
						
								if (yoyo.ougiOne == false && yoyo.ougiTwo == false && yoyo.ougiThree == false)
								{
									spBar.meter.width += 1;
								}
							}
						}
						
						//ougi damage
						if (yoyo.collisionArea1 != null)
						{
							if (dungeonOne.enemyTwo.hitTestObject(yoyo.collisionArea1))
							{
								dungeonOne.enemyTwo.subObject.meter.width -= 10;
							}
						}
						if (yoyo.collisionArea2 != null)
						{
							if (dungeonOne.enemyTwo.hitTestObject(yoyo.collisionArea2))
							{
								dungeonOne.enemyTwo.subObject.meter.width -= 15;
							}
						}
						if (yoyo.collisionArea3 != null)
						{
							if (dungeonOne.enemyTwo.hitTestObject(yoyo.collisionArea3))
							{
								dungeonOne.enemyTwo.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea4 != null)
						{
							if (dungeonOne.enemyTwo.hitTestObject(yoyo.collisionArea4))
							{
								dungeonOne.enemyTwo.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea5 != null)
						{
							if (dungeonOne.enemyTwo.hitTestObject(yoyo.collisionArea5))
							{
								dungeonOne.enemyTwo.subObject.meter.width -= 30;
							}
						}
					}
				}
				//EnemyThree
				if (dungeonTwo.enemyThree != null)
				{
					if (dungeonTwo.enemyThree.subObject.meter.width >= 1)
					{
						if (yoyo.collisionArea != null)
						{
							if (dungeonTwo.enemyThree.hitTestObject(yoyo.collisionArea))
							{
								dungeonTwo.enemyThree.subObject.meter.width -= 5;
						
								if (yoyo.ougiOne == false && yoyo.ougiTwo == false && yoyo.ougiThree == false)
								{
									spBar.meter.width += 1;
								}
							}
						}
						
						//ougi damage
						if (yoyo.collisionArea1 != null)
						{
							if (dungeonTwo.enemyThree.hitTestObject(yoyo.collisionArea1))
							{
								dungeonTwo.enemyThree.subObject.meter.width -= 10;
							}
						}
						if (yoyo.collisionArea2 != null)
						{
							if (dungeonTwo.enemyThree.hitTestObject(yoyo.collisionArea2))
							{
								dungeonTwo.enemyThree.subObject.meter.width -= 15;
							}
						}
						if (yoyo.collisionArea3 != null)
						{
							if (dungeonTwo.enemyThree.hitTestObject(yoyo.collisionArea3))
							{
								dungeonTwo.enemyThree.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea4 != null)
						{
							if (dungeonTwo.enemyThree.hitTestObject(yoyo.collisionArea4))
							{
								dungeonTwo.enemyThree.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea5 != null)
						{
							if (dungeonTwo.enemyThree.hitTestObject(yoyo.collisionArea5))
							{
								dungeonTwo.enemyThree.subObject.meter.width -= 30;
								trace("done");
							}
						}
					}
				}
				//EnemyFour
				if (dungeonTwo.enemyFour != null)
				{
					if (dungeonTwo.enemyFour.subObject.meter.width >= 1)
					{
						if (yoyo.collisionArea != null)
						{
							if (dungeonTwo.enemyFour.hitTestObject(yoyo.collisionArea))
							{
								dungeonTwo.enemyFour.subObject.meter.width -= 5;
						
								if (yoyo.ougiOne == false && yoyo.ougiTwo == false && yoyo.ougiThree == false)
								{
									spBar.meter.width += 1;
								}
							}
						}
						
						//ougi damage
						if (yoyo.collisionArea1 != null)
						{
							if (dungeonTwo.enemyFour.hitTestObject(yoyo.collisionArea1))
							{
								dungeonTwo.enemyFour.subObject.meter.width -= 10;
							}
						}
						if (yoyo.collisionArea2 != null)
						{
							if (dungeonTwo.enemyFour.hitTestObject(yoyo.collisionArea2))
							{
								dungeonTwo.enemyFour.subObject.meter.width -= 15;
							}
						}
						if (yoyo.collisionArea3 != null)
						{
							if (dungeonTwo.enemyFour.hitTestObject(yoyo.collisionArea3))
							{
								dungeonTwo.enemyFour.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea4 != null)
						{
							if (dungeonTwo.enemyFour.hitTestObject(yoyo.collisionArea4))
							{
								dungeonTwo.enemyFour.subObject.meter.width -= 30;
							}
						}
						if (yoyo.collisionArea5 != null)
						{
							if (dungeonTwo.enemyFour.hitTestObject(yoyo.collisionArea5))
							{
								dungeonTwo.enemyFour.subObject.meter.width -= 30;
							}
						}
					}
				}
				//Boss
				if (dungeonThree.boss != null)
				{
					if (dungeonThree.boss.subObject.meter.width >= 1)
					{
						if (yoyo.collisionArea != null)
						{
							if (dungeonThree.boss.hitTestObject(yoyo.collisionArea))
							{
								if (! dungeonThree.flute.invinsible)
								{
									dungeonThree.boss.subObject.meter.width -= 0.4;
									enemyBar.meter.width += 1.5;
						
									if (yoyo.ougiOne == false && yoyo.ougiTwo == false && yoyo.ougiThree == false)
									{
										spBar.meter.width += 2;
									}
								}
							}
						}
						//ougi damage
						if (! dungeonThree.flute.invinsible)
						{
						if (yoyo.collisionArea1 != null)
						{
							if (dungeonThree.boss.hitTestObject(yoyo.collisionArea1))
							{
								dungeonThree.boss.subObject.meter.width -= 0.8;
								enemyBar.meter.width += 3;
							}
						}
						if (yoyo.collisionArea2 != null)
						{
							if (dungeonThree.boss.hitTestObject(yoyo.collisionArea2))
							{
								dungeonThree.boss.subObject.meter.width -= 1.2;
								enemyBar.meter.width += 4.5;
							}
						}
						if (yoyo.collisionArea3 != null)
						{
							if (dungeonThree.boss.hitTestObject(yoyo.collisionArea3))
							{
								dungeonThree.boss.subObject.meter.width -= 2.4;
								enemyBar.meter.width += 9;
							}
						}
						if (yoyo.collisionArea4 != null)
						{
							if (dungeonThree.boss.hitTestObject(yoyo.collisionArea4))
							{
								dungeonThree.boss.subObject.meter.width -= 2.4;
								enemyBar.meter.width += 9;
							}
						}
						if (yoyo.collisionArea5 != null)
						{
							if (dungeonThree.boss.hitTestObject(yoyo.collisionArea5))
							{
								dungeonThree.boss.subObject.meter.width -= 2.4;
								enemyBar.meter.width += 9;
							}
						}
						}
					}
				}
			}
		}
		//let flute do damage on player
		public function hitPlayer(flute:MovieClip)
		{
			if (flute.enemyCollisionArea != null)
			{
				if (! dungeonThree._yoyo.invinsible)
				{
					if (flute.enemyCollisionArea.hitTestObject(dungeonThree.player))
					{
						health.meter.width -= 0.2;
						enemyBar.meter.width += 0.2;
					}
				}
			}
			//check to see if player could be hit with ougiOne
			if (flute.enemyCollisionArea1 != null)
			{
				if (! dungeonThree._yoyo.invinsible)
				{
					if (flute.enemyCollisionArea1.hitTestObject(dungeonThree.player))
					{
						flute.checkOugiOne = true;
					}
				}
			}
			//check to see if player could be hit with ougiTwo
			if (flute.enemyCollisionArea2 != null)
			{
				if (! dungeonThree._yoyo.invinsible)
				{
					if (flute.enemyCollisionArea2.hitTestObject(dungeonThree.player))
					{
						flute.checkOugiTwo = true;
					}
				}
			}
		}
		//see if the player is hit by the flute's ougi
		public function checkOugiHit(flute:MovieClip)
		{
			if (flute.currentFrame >= 11 && flute.currentFrame <= 22)
			{
				if (flute.enemyCollisionArea1.hitTestObject(dungeonThree.player))
				{
					if (! dungeonThree._yoyo.invinsible)
					{
						dungeonThree.player.hitByOugiOne = true;
					}
				}
			}
			if (flute.currentFrame >= 24 && flute.currentFrame <= 43)
			{
				if (flute.enemyCollisionArea2.hitTestObject(dungeonThree.player))
				{
					if (! dungeonThree._yoyo.invinsible)
					{
						dungeonThree.player.hitByOugiOne = true;
						dungeonThree.hitByOugiTwo = true;
					}
				}
			}
		}
		//see if the player is in the range of the mouse's ougi
		public function checkOugi(rat:MovieClip)
		{
			if (dungeonThree.player != null)
			{
				if (dungeonThree.player.hitTestObject(rat.enemyCollisionArea))
				{
					rat.startOugi = true;
				}
			}
		}
		//let rat's ougi hurt the player
		public function explodePlayer(rat:MovieClip)
		{
			if (dungeonThree.player.hitTestObject(rat.enemyCollisionArea))
			{
				if (! dungeonThree._yoyo.invinsible)
				{
					health.meter.width -= 20;
					spBar.meter.width += 20;
				}
			}
		}
		//stop spbar from going over ougi three
		public function spAdd(spBar:MovieClip)
		{
			if (spBar.meter.width >= 120)
			{
				spBar.meter.width = 120;
			}
		}
		//eat the rice ball
		public function eatRiceBall(player:MovieClip)
		{
			if (player.hitTestObject(dungeonThree.riceBall))
			{
				dungeonThree.removeChild(dungeonThree.riceBall);
				dungeonThree.riceBallExists = false;
				health.meter.width += 30;
				if (health.meter.width >= 80)
				{
					health.meter.width = 80;
				}
			}
		}
		
		public function checkDungeonOneWon(dungeonOne:MovieClip)
		{
			removeChild(dungeonOne);
			dungeonOne = null;
			addChild(dungeonTwo);
		}
		public function checkDungeonTwoWon(dungeonTwo:MovieClip)
		{
			removeChild(dungeonTwo);
			dungeonTwo = null;
			addChild(story);
			story.gotoAndStop(8);
			stage.addEventListener(MouseEvent.CLICK, onStoryClick2);
		}
		public function checkDungeonThreeLost(dungeonThree:MovieClip)
		{
			removeChild(dungeonThree);
			dungeonThree = null;
			addChild(story);
			story.gotoAndStop(20);
			stage.addEventListener(MouseEvent.CLICK, onStoryClick3Lost);
		}
		public function checkDungeonThreeWon(dungeonThree:MovieClip)
		{
			removeChild(dungeonThree);
			dungeonThree = null;
			addChild(story);
			story.gotoAndStop(16);
			stage.addEventListener(MouseEvent.CLICK, onStoryClick3Won);
		}
	}
}
