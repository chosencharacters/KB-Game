package;

import actor.Actor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Upgrade extends Actor 
{
	var upgrade:String = "";

	public function new(?X:Float = 0, ?Y:Float = 0, UpgradeSet:String) 
	{
		super(X, Y);
		upgrade = UpgradeSet;
		PlayState.actors.add(this);
		loadGraphic(AssetPaths.upgrade__png);
	}
	
	function colorRandom(){
		color = PlayState.ran.color(0xffFFCDFF, 0xffFF99FF);
	}
	
	override function act() 
	{
		colorRandom();
		if (overlaps(PlayState.player)){
			FlxG.camera.flash();
			PlayState.upgrades.push(upgrade);
			if (upgrade == "kbUP"){
				PlayState.maxKB = PlayState.maxKB + 16;
			}
			kill();
			SoundPlayer.sound("upgrade");
		}
		super.act();
	}
	
}