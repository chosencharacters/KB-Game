package actor;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Player extends Actor
{
	var speed:Int = 100;
	var jumpBoom:Int = 100;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y - 4);
		
		PlayState.actors.add(this);
		
		kbCost = 4;
		type = "player";
		team = 1;
		
		loadGraphic(AssetPaths.player__png, true, 8, 8);
		
		acceleration.y = 400; //gravity
		
		maxVelocity.x = speed;
		drag.x = 200;
		
		if (PlayState.spawnGate != null){
			setPosition(PlayState.spawnGate.x + 2, PlayState.spawnGate.y);
			PlayState.spawnGate.cd = 60;
		}
		
		makeTrail();
	}
	
	override function act()
	{
		controls();
		super.act();
	}
	
	function controls(){
		if (Ctrl.left){
			velocity.x -= speed / 15;
		}
		if (Ctrl.right){
			velocity.x += speed / 15;
		}
		if (Ctrl.jjump && isTouching(FlxObject.FLOOR)){
			velocity.y = -jumpBoom;
		}
		if (!Ctrl.jump && !isTouching(FlxObject.FLOOR) && velocity.y < 0){
			velocity.y = velocity.y / 15;
		}
	}
	
	override public function kill():Void 
	{
		if (killedOff) PlayState.respawnTimer = 30;
		super.kill();
	}
	
}