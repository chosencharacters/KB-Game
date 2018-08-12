package actor.enemy;

import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class Pacer extends Enemy 
{

	var speed:Int = 50;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		type = "pacer";
		
		acceleration.y = 200;
		
		loadGraphic("assets/images/pacer.png");
		
		touching = 0;
		
		maxVelocity.x = speed;
		
		makeTrail();
	}
	
	override function ai() 
	{
		meleeHitPlayer();
		velocity.x = 0;
		if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT) || x + 1 + width >= PlayState.lvl.x + FlxG.width || x - 1 <= PlayState.lvl.x){
			speed =-speed;
			if (isTouching(FlxObject.RIGHT) || x > FlxG.width) x -= 2;
			if (isTouching(FlxObject.LEFT) || x < 0) x += 2;
		}
		if (isTouching(FlxObject.FLOOR)) velocity.x = speed;
		super.ai();
	}
	
}