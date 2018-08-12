package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;

/**
 * ...
 * @author 
 */
class Dialogue extends FlxSprite 
{
	var text:FlxText;
	var iText:String = "";

	var tickRate:Int = 2;
	var tick:Int = 0;
	
	var textAlt:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, dlg:String) 
	{
		super(0, 0);
		
		makeGraphic(FlxG.width, 16, FlxColor.BLACK);
		
		text = new FlxText(0, 1, FlxG.width, "", 8);
		
		iText = dlg;
		
		scrollFactor.set(0, 0);
		text.scrollFactor.set(0, 0);
		
		FlxG.state.add(this);
		FlxG.state.add(text);
	}
	
	override public function update(elapsed:Float):Void 
	{
		tick++;
		if (iText.length > 0 && tick % tickRate == 0){
			text.text = text.text + iText.charAt(0);
			iText = iText.substring(1, iText.length);
			if (textAlt % 4 == 0) SoundPlayer.sound("text1");
			if (textAlt % 4 == 2) SoundPlayer.sound("text2");
			textAlt++;
		}
		super.update(elapsed);
	}
	
	override public function kill():Void 
	{
		text.kill();
		FlxG.state.remove(this);
		FlxG.state.remove(text);
		super.kill();
	}
	
}