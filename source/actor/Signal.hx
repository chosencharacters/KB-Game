package actor;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Signal extends Actor 
{
	var signal:String;
	var on:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, signalToEmit:String) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.switch__png, true, 8, 8);
		signal = signalToEmit;
		PlayState.signals.add(this);
	}
	
	override function act() 
	{
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this)){
			on = !on;
			if (on){
				animation.frameIndex = 1;
				SoundPlayer.sound("switchON");
			}
			if (!on){
				animation.frameIndex = 0;
				SoundPlayer.sound("switchOFF");
			}
			emitSignal(signal, on);
			PuzzleManager.receiveSignal(signal, on);
		}
		super.act();
	}
	
	public static function emitSignal(s:String, on:Bool){
		for (p in PlayState.receivers){
			p.receiveSignal(s, on);
		}
	}
	
}