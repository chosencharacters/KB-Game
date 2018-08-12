package actor;

import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Actor extends FlxSprite 
{
	public var team:Int = 0;
	public var type:String = "";
	public var kbCost:Int = 0;
	public var killedOff:Bool = false;
	
	var trail:FlxTrail;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (PlayState.transitioning || PlayState.paused) return;
		act();
		super.update(elapsed);
	}
	
	function act(){
		keepInBounds();
		vaporize();
	}
	
	function keepInBounds(){
		if (x + width >= PlayState.lvl.x + FlxG.width || x <= PlayState.lvl.x){
			velocity.x = -velocity.x;
			if (x + width >= PlayState.lvl.x + FlxG.width) x--;
			if (x <= PlayState.lvl.x) x++;
		}
		if (y < PlayState.lvl.y && velocity.y > 0) velocity.y = 0;
	}
	
	function vaporize(){
		if (!alive) return;
		var mx:Int = Math.floor((x + width / 2 - PlayState.lvl.x) / 8);
		var my:Int = Math.floor((y + height / 2 - PlayState.lvl.y) / 8);
		if (PlayState.lvl.col.getTile(mx, my) == 1){
			killOff();
		}
	}
	
	public function killOff(){
		if (!alive) return;
		killedOff = true;
		kill();
		if (trail != null){
			trail.kill();
			PlayState.trails.remove(trail, true);
			SoundPlayer.sound("kill");
		}
		new SFX(x, y, "vaporize");
	}
	
	function makeTrail(g:FlxGraphicAsset = null){
		if (g == null) g = graphic;
		PlayState.trails.add(trail = new FlxTrail(this, g));
		trail.changeValuesEnabled(false);
	}
	
}