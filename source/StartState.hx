package;

import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author 
 */
class StartState extends FlxState 
{
	var text:FlxText;
	var iText:String = "The memory must be cleared.\n\nUse mouse and keys.\n\nPlease clear the memory.\nPlease clear the memory.\nPlease clear the memory.\n\nInitializing Memory.exe";
	
	var tickRate:Int = 2;
	var tick:Int = 0;
	
	var delay:Int = 160;
	
	var finalPrint:Bool = false;
	
	var textAlt:Int = 0;
	
	override public function create():Void
	{
		super.create();
		add(text = new FlxText(0, 0, FlxG.width));
		
		SoundPlayer.music("KBSong");
		FlxG.sound.music.stop();
		
		FlxG.mouse.visible = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		tick++;
		delay--;
		
		if (FlxG.mouse.justPressed) delay = 0;
		
		if (delay <= 0){
			if (iText.length > 0 && tick % tickRate == 0){
				if (iText.charAt(0) == "." && iText.length > 8){
					delay = 120;
				}
				text.text = text.text + iText.charAt(0);
				iText = iText.substring(1, iText.length);
				if (textAlt % 4 == 0) SoundPlayer.sound("text1");
				if (textAlt % 4 == 2) SoundPlayer.sound("text2");
				textAlt++;
				if (iText.length == 0) delay = 160;
			}
			if (iText.length <= 0 && !finalPrint && delay <= 0){
				finalPrint = true;
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function(){FlxG.switchState(new PlayState()); });
			}
		}
		
		super.update(elapsed);
	}
	
}