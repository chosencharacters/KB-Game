package actor;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Enemy extends Actor
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		kbCost = 4;
		type = "enemy";
		team = -1;
		
		PlayState.actors.add(this);
	}
	
	override function act() 
	{
		ai();
		super.act();
	}
	
	function ai(){
		//...
	}
	
	function meleeHitPlayer(){
		if (overlaps(PlayState.player)) PlayState.player.killOff();
	}
	
}