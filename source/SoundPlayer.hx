package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;

/**
 * ...
 * @author 
 */
class SoundPlayer
{

	public function new() 
	{
	}
	
	
	public static function music(s:String){
		#if flash
		FlxG.sound.playMusic('assets/music/$s.mp3', 0.5);
		#else
		FlxG.sound.playMusic('assets/music/$s.ogg', 0.5);
		#end
	}
	
	public static function sound(s:String){
		FlxG.sound.play('assets/sounds/$s.wav');
	}
}