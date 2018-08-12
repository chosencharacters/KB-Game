package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author 
 */
class Gate extends Actor
{
	
	var destText:FlxText;
	public var dest:String = "";
	public var gcolor:String = "";
	public var lvl:Level;
	
	var waitForRelease:Bool = true;
	var playerOverlap:Bool = false;
	public var cd:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, destination:String, gateColor:String) 
	{
		super(X - 2, Y - 2);
		
		loadGraphic(AssetPaths.gate__png);
		
		dest = destination;
		lvl = PlayState.lvl;
		gcolor = gateColor;
		
		PlayState.gates.add(this);
		
		switch(gcolor){
			case "red": color = FlxColor.MAGENTA;
			case "cyan": color = FlxColor.CYAN;
			case "green": color = FlxColor.LIME;
			case "yellow": color = FlxColor.YELLOW;
		}
		
		destText = new FlxText(x - 3, y - 10, 20, dest, 8);
		destText.color = color;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (cd > 0) waitForRelease = true;
		cd--;
		playerOverlap = false;
		if(FlxG.overlap(this, PlayState.player)) {
			playerOverlap = true;
			if(!waitForRelease && (PlayState.player.x >= x + 2) && (PlayState.player.x + PlayState.player.width <= x + width) && PlayState.player.y + PlayState.player.height == y + height && PlayState.player.isTouching(FlxObject.FLOOR)) transitionGate(findNextGate());
		}
		if (waitForRelease && !playerOverlap && cd <= 0) waitForRelease = false;
	}
	
	function transitionGate(gate:Gate){
		cd = 60;
		
		FlxTween.tween(FlxG.camera.scroll, {x: gate.lvl.x, y:gate.lvl.y}, 1, {ease:FlxEase.cubeIn});
		FlxTween.tween(PlayState.player, {x: gate.x + 2, y:gate.y}, 1, {ease:FlxEase.cubeIn});
		new SFX(PlayState.player.x, PlayState.player.y, "greenBlock");
		
		PlayState.player.alpha = 0.25;
		PlayState.player.velocity.set(0, 0);
		
		gate.waitForRelease = true;
		gate.cd = 60;
		
		PlayState.lvl = gate.lvl;
		
		PlayState.transitioning = true;
		
		PlayState.spawnGate = gate;
		
		SoundPlayer.sound("gateOUT");
	}
	
	function findNextGate(){
		for (nextGate in PlayState.gates){
			if (nextGate.lvl.name == dest && nextGate.gcolor == gcolor){
				return nextGate;
			}
		}
		return null;
	}
	
}