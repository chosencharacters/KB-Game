package;

import flixel.FlxG;

/**
 * ...
 * @author 
 */
class Ctrl 
{
	public static var right:Bool = false;
	public static var left:Bool = false;
	public static var jjump:Bool = false;
	public static var jump:Bool = false;
	public static var nextTile:Bool = false;

	public function new() 
	{
		
	}
	
	public static function update(){
		right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		left = FlxG.keys.anyPressed(["LEFT", "A"]);
		jump = FlxG.keys.anyPressed(["UP", "W"]);
		jjump = FlxG.keys.anyJustPressed(["UP", "W"]);
	}
	
}