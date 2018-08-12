package;

import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author 
 */
class EndState extends FlxState 
{
	var text:FlxText;
	var iText:String = "Thank you for clearing the memory.\n\nI hope you enjoyed the memory.\nI hope you enjoyed the memory.\nI hope you enjoyed the memory.\n\nI.\nHope.\nYou.\nEnjoyed.\nThe Memory.";
	
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
	}
	
	override public function update(elapsed:Float):Void 
	{
		tick++;
		delay--;
		
		if (delay <= 0){
			if (iText.length > 0 && tick % tickRate == 0){
				if (iText.charAt(0) == "."){
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
				SoundPlayer.sound("text1");
				text.text = text.text + "\n\nCompletion:\n" + PlayState.tick + " frames";
			}
		}
		
		super.update(elapsed);
	}
	
}