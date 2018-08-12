package actor;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Receiver extends Actor 
{
	var listener:String = "";
	
	public function new(?X:Float=0, ?Y:Float=0, Listener:String) 
	{
		super(X, Y);
		type = "receiver";
		
		loadGraphic(AssetPaths.receiver__png, true, 8, 8);
		
		listener = Listener;
		
		PlayState.receivers.add(this);
	}
	
	override function act() 
	{
		if (overlaps(PlayState.player) && animation.frameIndex == 0){
			PlayState.player.killOff();
		}
		super.act();
	}
	
	public function receiveSignal(s:String, on:Bool){
		if (listener == s){
			if(on) animation.frameIndex = 1;
			if(!on) animation.frameIndex = 0;
		}
	}
	
}