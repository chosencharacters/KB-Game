package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

/**
 * ...
 * @author 
 */
class FlxOgmoLoaderExt extends FlxOgmoLoader 
{

	public function new(LevelData:Dynamic) 
	{
		super(LevelData);
		
	}
	
	public function loadTilemapLVL(TileGraphic:Dynamic, TileWidth:Int = 16, TileHeight:Int = 16, TileLayer:String = "tiles"):Level
	{
		var tileMap:Level = new Level();
		tileMap.loadMapFromCSV(_fastXml.node.resolve(TileLayer).innerData, TileGraphic, TileWidth, TileHeight);
		return tileMap;
	}
}