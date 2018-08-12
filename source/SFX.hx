package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class SFX extends FlxSprite 
{
	var type:String = "";
	
	public function new(?X:Float=0, ?Y:Float=0, assignType:String) 
	{
		super(X, Y);
		type = assignType;
		switch(type){
			case "addBlock": loadGraphic(AssetPaths.blueSquare__png);
			case "addYellowBlock": loadGraphic(AssetPaths.yellowSquare__png); type = "addBlock";
			case "vaporize": loadGraphic(AssetPaths.orangeSquare__png); type = "addBlock";
			case "greenBlock": loadGraphic(AssetPaths.greenBlock__png); type = "addBlock";
		}
		PlayState.sfx.add(this);
	}
	
	override public function update(elapsed:Float):Void 
	{
		switch(type){
			case "addBlock": scale.set(scale.x * 1.25, scale.y * 1.25);
			alpha = alpha * .8;
			if (alpha <= 0) kill();
		}
		super.update(elapsed);
	}
	
	override public function kill():Void 
	{
		PlayState.sfx.remove(this, true);
		super.kill();
	}
	
}