package;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxBar;

class PlayState extends FlxState
{
	var rightClickAllowed:Bool = true;
	
	public static var player:Player;
	
	public static var lvl:Level;
	
	public static var actors:FlxTypedGroup<Actor>;
	public static var tiles:FlxTypedGroup<FlxTilemap>;
	public static var gates:FlxTypedGroup<Gate>;
	public static var tablets:FlxTypedGroup<Tablet>;
	public static var signals:FlxTypedGroup<Signal>;
	public static var receivers:FlxTypedGroup<Receiver>;
	public static var trails:FlxTypedGroup<FlxTrail>;
	public static var sfx:FlxTypedGroup<SFX>;
	
	public static var kb:Int = 0;
	public static var maxKB:Int = 32;
	
	public var meterKB:Int = 0;
	
	var canPlaceTile:Bool = false;
	
	var meter:FlxBar;
	var kbText:FlxText;
	
	var spawnLVL:String = "A2";
	public static var spawnGate:Gate;
	var lvlBeingMade:String = "";
	
	var mapString:Array<Array<String>> =  [["S1", "S2", "S3", "XX", "S5", "XX", "S7"],
										   ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9"],
										   ["XX", "XX", "XX", "XX", "XX", "B6", "B7", "B8", "B9", "B10", "B11", "B12", "B13", "B14"],
										   ["XX", "XX", "XX", "XX", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "XX", "C13", "C14"]];
	var mapLVL:Array<Array<Level>> = [];
	
	public static var paused:Bool = false;
	public static var transitioning:Bool = false;
	
	var mouse:FlxSprite;
	
	public static var upgrades:Array<String> = [];
	
	public static var ran:FlxRandom = new FlxRandom();
	
	var wasTransitioning:Bool = false;
	
	var darken:FlxSprite;
	
	public static var tick:Int = 0;
	
	public static var respawnTimer:Int = -1;
	
	var tileSoundCD:Int = 0;
	
	override public function create():Void
	{
		super.create();
		
		tick = 0;
		
		FlxG.camera.fade(FlxColor.BLACK, 3, true);
		
		actors = new FlxTypedGroup<Actor>();
		gates = new FlxTypedGroup<Gate>();
		tiles = new FlxTypedGroup<FlxTilemap>();
		tablets = new FlxTypedGroup<Tablet>();
		signals = new FlxTypedGroup<Signal>();
		receivers = new FlxTypedGroup<Receiver>();
		trails = new FlxTypedGroup<FlxTrail>();
		sfx = new FlxTypedGroup<SFX>();
		
		add(new FlxBackdrop(AssetPaths.bgSlow__png, 0.1, 0.1, true));
		add(new FlxBackdrop(AssetPaths.bgFast__png, 0.25, 0.25, true));
		add(new FlxBackdrop(AssetPaths.bgUltraSlow__png, 0.05, 0.05, true));
		add(darken = new FlxSprite(0, 0));
		add(tiles);
		add(tablets);
		add(signals);
		add(receivers);
		add(gates);
		add(trails);
		add(actors);
		add(sfx);
		add(meter = new FlxBar(1, 1, FlxBarFillDirection.LEFT_TO_RIGHT, 32, 7, this, "meterKB", 0, maxKB));
		add(kbText = new FlxText(meter.x + meter.width, meter.y - 3, FlxG.width, "8kb/8kb"));
		
		darken.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
		darken.scrollFactor.set(0, 0);
		darken.alpha = 0;
		
		meter.scrollFactor.set(0, 0);
		kbText.scrollFactor.set(0, 0);
		
		add(mouse = new FlxSprite(0, 0, AssetPaths.mouse__png));
		
		meter.createFilledBar(FlxColor.GRAY, FlxColor.WHITE);
		
		makeWorld();
		
		SoundPlayer.music("KBSong");
	}

	override public function update(elapsed:Float):Void
	{
		respawnTimer--;
		tileSoundCD--;
		
		tick++;
		
		if (respawnTimer == 0){
			player = new Player();
			new SFX(player.x, player.y, "greenBlock");
		}
		
		optimize();
		
		if (lvl.x == FlxG.camera.scroll.x && lvl.y == FlxG.camera.scroll.y && transitioning){
			transitioning = false;
			player.alpha = 1;
			new SFX(player.x, player.y, "greenBlock");
			SoundPlayer.sound("gateOUT");
		}
		
		meter.visible = !transitioning;
		kbText.visible = meter.visible;
		
		Ctrl.update();
		
		calcKB();
		mouseControls();
		mouseMove();
		
		if(!transitioning) FlxG.collide(actors, lvl.col);
		
		if (wasTransitioning != transitioning){
			for (r in mapLVL){
				if (transitioning) darken.alpha = 0.5;
				if (!transitioning) darken.alpha = 0;
			}
		}
		
		wasTransitioning = transitioning;
		
		super.update(elapsed);
	}
	
	var lastPressed:Int = -1;
	
	function mouseControls(){
		var mx:Int = Math.floor((FlxG.mouse.x - lvl.x) / 8);
		var my:Int = Math.floor((FlxG.mouse.y - lvl.y) / 8);
		var tile:Int = lvl.col.getTile(mx, my);
		
		if (rightClickAllowed){
			if (FlxG.mouse.pressed && FlxG.mouse.pressedRight) return;
			if (FlxG.mouse.pressed && canPlaceTile){
				if (tile == 0 && upgrades.indexOf("freeDraw") != -1){
					lvl.col.setTile(mx, my, 3);
					lvl.setTile(mx, my, 3);
					new SFX(FlxG.mouse.x, FlxG.mouse.y, "addBlock");
					situationalTileSound("createTile");
				}
				if (tile == 4){
					lvl.col.setTile(mx, my, 3);
					lvl.setTile(mx, my, 3);
					new SFX(FlxG.mouse.x, FlxG.mouse.y, "addBlock");
					situationalTileSound("createTile");
				}
				if (tile == 6){
					lvl.col.setTile(mx, my, 5);
					lvl.setTile(mx, my, 5);
					new SFX(FlxG.mouse.x, FlxG.mouse.y, "addYellowBlock");
					situationalTileSound("createTile");
				}
			}
			if(FlxG.mouse.pressedRight){
				if (tile == 3){
					lvl.col.setTile(mx, my, 4);
					lvl.setTile(mx, my, 4);
					new SFX(FlxG.mouse.x, FlxG.mouse.y, "addBlock");
					situationalTileSound("clearTile");
					tileSoundCD = 10;
				}
				if (tile == 5 && upgrades.indexOf("permanentRemoval") != -1){
					lvl.col.setTile(mx, my, 6);
					lvl.setTile(mx, my, 6);
					new SFX(FlxG.mouse.x, FlxG.mouse.y, "addYellowBlock");
					situationalTileSound("clearTile");
				}
			}
		}
	}
	
	function situationalTileSound(s:String){
		if (tileSoundCD <= 0){
			SoundPlayer.sound(s);
			tileSoundCD = 2;
		}
	}
	
	function calcKB(){
		kb = 0;
		if (lvl.col.getTileInstances(3) != null){
			for (i in lvl.col.getTileInstances(3)){
				kb += 4;
			}
		}
		if (lvl.col.getTileInstances(5) != null){
			for (i in lvl.col.getTileInstances(5)){
				kb += 4;
			}
		}
		for (a in actors){
			if(a.alive && a.active) kb += a.kbCost;
		}
		canPlaceTile = kb + 4 <= maxKB;
		meterKB = kb;
		kbText.text = '$kb kb/$maxKB kb';
		if (kb > maxKB){
			kbText.color = FlxColor.RED;
			meter.color = FlxColor.RED;
		}
		if (kb <= maxKB){
			kbText.color = FlxColor.WHITE;
			meter.color = FlxColor.WHITE;
		}
		meter.setRange(0, maxKB);
		if (kb == 0 && lvl.name == "A1"){
			respawnTimer = -1;
			FlxG.camera.fade(FlxColor.BLACK, 3, false, function(){FlxG.switchState(new EndState()); });
			FlxG.sound.music.stop();
		}
	}
	
	function makeWorld(){
		var spawnLVLsave:Level = null;
		for (r in mapString){
			mapLVL.push([]);
			for (c in r){
				if (c != "XX") makeLevel(c, FlxPoint.weak(r.indexOf(c) * FlxG.width, mapString.indexOf(r) * FlxG.height));
				if (c == "XX") mapLVL[Math.floor(mapString.indexOf(r))].push(null);
				if (c == spawnLVL) spawnLVLsave = lvl;
			}
		}
		lvl = spawnLVLsave;
		FlxG.camera.scroll.set(lvl.x, lvl.y);
	}
	
	function makeLevel(lvlName:String, cord:FlxPoint){		
		var loader:FlxOgmoLoaderExt = new FlxOgmoLoaderExt('assets/data/$lvlName.oel');
		lvl = loader.loadTilemapLVL(AssetPaths.tiles__png, 8, 8, "tiles");
		lvl.col = loader.loadTilemap(AssetPaths.tiles__png, 8, 8, "tiles");
		
		lvl.name = lvlName;
		
		lvl.col.setTileProperties(1, FlxObject.NONE);
		lvl.col.setTileProperties(4, FlxObject.NONE);
		lvl.col.setTileProperties(6, FlxObject.NONE);
		
		lvl.setPosition(cord.x, cord.y);
		lvl.col.setPosition(cord.x, cord.y);
		
		tiles.add(lvl);
		tiles.add(lvl.col);
		
		mapLVL[Math.floor(cord.y / FlxG.height)].push(lvl);
		
		lvlBeingMade = lvlName;
		
		loader.loadEntities(placeEntities, "entities");
		
		levelCleanup();
	}
	
	function levelCleanup(){
		if (lvl.getTileInstances(0) != null){
			for (tile in lvl.getTileInstances(0)){
				//lvl.setTileByIndex(tile, 4);
			}
		}
	}
	
	function placeEntities(entityName:String, entityData:Xml){
		var x:Float = Std.parseInt(entityData.get("x")) + lvl.x;
		var y:Float = Std.parseInt(entityData.get("y")) + lvl.y;
		
		switch(entityName){
			case "player": 
				if (spawnLVL == lvlBeingMade){
					player = new Player(x, y);
					camera.scroll.set(lvl.x, lvl.y);
				}
			case "enemy":
				var e:Enemy;
				switch(entityData.get("name")){
					case "pacer": e = new Pacer(x, y);
				}
			case "gate":
				new Gate(x, y, entityData.get("dest"), entityData.get("color"));
			case "tablet":
				new Tablet(x, y, entityData.get("text"));
			case "signal":
				new Signal(x, y, entityData.get("signal"));
			case "receiver":
				new Receiver(x, y, entityData.get("signal"));
			case "upgrade":
				new Upgrade(x, y, entityData.get("type"));
		}
	}
	
	function mouseMove(){
		FlxG.mouse.visible = false;
		mouse.x = FlxG.mouse.x - 3;
		mouse.y = FlxG.mouse.y - 3;
	}
	
	function optimize(){
		for (r in mapLVL){
			for (c in r){
				if (c != null){
					c.visible = c.active = c.isOnScreen();
					c.col.active = c.col.visible = c.active;
				}
			}
		}
		for (n in actors){
			n.visible = n.active = n.isOnScreen();
		}
		for (n in gates){
			n.visible = n.active = n.isOnScreen();
		}
		for (n in tablets){
			n.visible = n.active = n.isOnScreen();
		}
		for (n in signals){
			n.visible = n.active = n.isOnScreen();
		}
		for (n in receivers){
			n.visible = n.active = n.isOnScreen();
		}
		FlxG.worldBounds.set(lvl.x, lvl.y, lvl.width, lvl.height);
	}
	
	function eraseAll(){
		actors.forEach(function(e:FlxBasic){ e.destroy(); });
		tiles.forEach(function(e:FlxBasic){ e.destroy(); });
		gates.forEach(function(e:FlxBasic){ e.destroy(); });
		actors.clear();
		tiles.clear();
		gates.clear();
	}
	
	override public function destroy():Void 
	{
		eraseAll();
		super.destroy();
	}
}
