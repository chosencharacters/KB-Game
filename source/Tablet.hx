package;

import actor.Actor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Tablet extends Actor 
{
	var dlgText:String = "";
	var dlgSprite:Dialogue;
	
	var touchingPlayer:Bool = false;
	var wasTouchingPlayer:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, dialogue:String) 
	{
		super(X, Y-3);
		PlayState.tablets.add(this);
		
		loadGraphic(AssetPaths.tablet__png);
		
		dlgText = dialogue;
	}
	
	override function act() 
	{
		touchingPlayer = false;
		if (FlxG.overlap(this, PlayState.player)){
			touchingPlayer = true;
		}
		if (wasTouchingPlayer != touchingPlayer){
			if (touchingPlayer){
				dlgSprite = new Dialogue(x, y, dlgText);
			}else{
				dlgSprite.kill();
			}
		}
		wasTouchingPlayer = touchingPlayer;
		super.act();
	}
	
}