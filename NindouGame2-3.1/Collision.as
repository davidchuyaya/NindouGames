﻿package {	import flash.display.MovieClip;	import flash.geom.Point;		public class Collision	//0.2 (March 20, 2009)	{		public function Collision()		{		}				//Block objects		static public function block(objectA:MovieClip, objectB:MovieClip):void		{			var objectA_Halfwidth:Number = objectA.width / 2;			var objectA_Halfheight:Number = objectA.height / 2;			var objectB_Halfwidth:Number = objectB.width / 2;			var objectB_Halfheight:Number = objectB.height / 2;			var dx:Number = objectB.x - objectA.x;			var ox:Number = objectB_Halfwidth + objectA_Halfwidth - Math.abs(dx);			if (ox > 0)			{				var dy:Number = objectA.y - objectB.y;				var oy:Number = objectB_Halfheight + objectA_Halfheight - Math.abs(dy);				if (oy > 0)				{					if (ox < oy)					{						if (dx < 0)						{							//Collision on right							oy = 0;						}						else						{							//Collision on left							oy = 0;							ox *= -1;						}					}					else					{						if (dy < 0)						{							//Collision on Top							ox = 0;							oy *= -1;						}						else						{							//Collision on Bottom							ox = 0;						}					}										//Use the calculated x and y overlaps to 					//Move objectA out of the collision										objectA.x += ox;					objectA.y += oy;				}			}		}				//General purpose method for testing Axis-based collisions. Returns true or False		static public function test(objectA:Object,objectB:Object):Boolean		{			var objectA_Halfwidth=objectA.width/2;			var objectA_Halfheight=objectA.height/2;			var objectB_Halfwidth=objectB.width/2;			var objectB_Halfheight=objectB.height/2;			var dx=objectB.x-objectA.x;			var ox=objectB_Halfwidth+objectA_Halfwidth-Math.abs(dx);			if (0<ox)			{				var dy=objectA.y-objectB.y;				var oy=objectB_Halfheight+objectA_Halfheight-Math.abs(dy);				if (0<oy)				{					return true;				}			}			else			{				return false;			}			return false;		}				//Collisions between the player and platform		static public function playerAndPlatform(player:MovieClip, platform:MovieClip, bounce:Number, friction:Number):void		{			//This method requires the following getter and 			//setter properties in the player object:			//objectIsOnGround:Boolean, vx:Number, vy:Number, 			//bounceX:Number, bounceY:Number						//Decalre variables needed for the player's			//position and dimensions			var player_Halfwidth:Number;			var player_Halfheight:Number;			var player_X:Number;			var player_Y:Number						//Decalre variables needed for the physics calculations			var bounceX:Number;			var bounceY:Number;			var frictionX:Number;			var frictionY:Number;						//Find out whether the player object has a collisionArea			//subobject defined			if(player.collisionArea != null)			{				//If it does, find out its width and height				player_Halfwidth = player.collisionArea.width / 2;			    player_Halfheight = player.collisionArea.height / 2;								//Convert the collisionArea's local x,y coordinates to global coordinates				var player_Position:Point = new Point(player.collisionArea.x, player.collisionArea.y);            	player_X = player.localToGlobal(player_Position).x;				player_Y = player.localToGlobal(player_Position).y;			}			else			{				//If there's no collisionArea subobject				//Use the player's main height, width, x and y				player_Halfwidth = player.width / 2;			    player_Halfheight = player.height / 2;				player_X = player.x;				player_Y = player.y;			}			//Find the platform's dimensions			var platform_Halfwidth:Number = platform.width / 2;			var platform_Halfheight:Number = platform.height / 2;						//Find the distance between the player and platfrom on the x axis			var dx:Number = platform.x - player_X;						//Find the amount of overlap on the x axis			var ox:Number = platform_Halfwidth + player_Halfwidth - Math.abs(dx);						//Check for a collision on the x axis			if (ox > 0)			{				//If the objects overlap on the x axis, a collision might be occuring				//Define the variables you need to check for a collision on the y axis				var dy:Number = player.y - platform.y;				var oy:Number = platform_Halfheight + player_Halfheight - Math.abs(dy);								//Check for a y axis collision. We know a collision must be				//occuring if there's a collision on both the x and y axis				if (oy > 0)				{					//Yes, a collision is occuring! 					//Now you need to find out on which side 					//of the platform it's occuring on.					if (ox < oy)					{						if (dx < 0)						{							//Collision on right							oy = 0;							dx = 1;							dy = 0						}						else						{							//Collision on left							oy = 0;							ox *= -1;							dx = -1;							dy = 0						}					}					else					{						if (dy < 0)						{							//Collision on Top							ox = 0;							oy *= -1;							dx = 0;							dy = -1;							//set the player's isOnGround property to							//true to enable jumping							player.isOnGround = true;						}						else						{							//Collision on Bottom							ox = 0;							dx = 0;							dy = 1;						}					}										//Find the direction of the collision ("dot product")					var directionOfCollision:Number = player.vx * dx + player.vy * dy;										//Calculate the new direction for the bounce ("projection")					var newDirection_X:Number = directionOfCollision * dx;					var newDirection_Y:Number = directionOfCollision * dy;										//Find the "tangent velocity":					//the speed in the direction that the object is moving.					//It's used for calculating additional platform friction.					var tangent_Vx:Number = player.vx - newDirection_X;					var tangent_Vy:Number = player.vy - newDirection_Y;										//Apply collision forces if the object is moving into a collision					if (directionOfCollision < 0)					{						//Calculate the friction						frictionX = tangent_Vx * friction;						frictionY = tangent_Vy * friction;												//Calculate the amount of bounce						bounceX = newDirection_X * bounce;						bounceY = newDirection_Y * bounce;					}					else					{						//Prevent forces from being applied if the object is						//moving out of a collision						bounceX = 0;						bounceY = 0;						frictionX = 0;						frictionY = 0;					}					//Apply platform friction					player.vx += ox - frictionX;					player.vy += oy - frictionY;										//Move the player out of the collision					player.x += ox;					player.y += oy;										//Bounce the player off the platform					player.bounceX = bounceX;					player.bounceY = bounceY;				}			}		}	}}