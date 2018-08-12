package actor;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class PuzzleManager 
{
	
	static var signals:Array<String> = [];
	
	static var cupDrawing:Array<Array<Int>> = 
								   [[1, 1, 1, 1, 1], 
									[1, 0, 0, 0, 1],
									[0, 1, 1, 1, 0],
									[0, 0, 1, 0, 0],
									[0, 0, 1, 0, 0],
									[0, 1, 1, 1, 0]];
									
	static var fehuDrawing:Array<Array<Int>> = 
								   [[1, 0, 1, 0, 1],
								    [1, 1, 0, 1, 0],
									[1, 0, 1, 0, 0],
									[1, 1, 0, 0, 0],
									[1, 0, 0, 0, 0]];
									
	static var othalaDrawing:Array<Array<Int>> = 
								   [[0, 0, 1, 0, 0],
									[0, 1, 0, 1, 0],
									[1, 0, 0, 0, 1],
									[0, 1, 0, 1, 0],
									[0, 0, 1, 0, 0],
									[0, 1, 0, 1, 0],
									[1, 0, 0, 0, 1]];
									
	static var holeDrawing:Array<Array<Int>> = 
								   [[1, 1, 1, 1, 1, 1, 1],
								    [1, 1, 1, 1, 1, 1, 1]];
	
	public static function receiveSignal(signal:String, on:Bool){
		if (on) signals.push(signal);
		if (!on) signals.remove(signal);
		puzzleSolve();
	}
	
	static function puzzleSolve(){
		if (puzzleSet(["air1", "earth2", "water3", "spark4", "fire5"]) && puzzleNot(["air2", "air3", "air4", "air5", "earth1", "earth3", "earth4", "earth5", "water1", "water2", "water4", "water5", "spark1", "spark2", "spark3", "spark5", "fire1", "fire2", "fire3", "fire4"])){
			Signal.emitSignal("elements", true);
		}else{
			Signal.emitSignal("elements", false);
		}
		if (PlayState.lvl.name == "B10" && puzzleSet(["cupcheck", "goldcupfound"])){
			if (drawingCheck(FlxPoint.weak(14, 4), cupDrawing)) Signal.emitSignal("cup", true);
		}
		if (PlayState.lvl.name == "C14" && puzzleSet(["goldcupcheck"])){
			if (drawingCheck(FlxPoint.weak(14, 3), cupDrawing)){
				Signal.emitSignal("goldcupfound", true);
				signals.push("goldcupfound");
			}
		}
		if (PlayState.lvl.name == "B11" && puzzleSet(["fehucheck"])){
			if (drawingCheck(FlxPoint.weak(21, 3), fehuDrawing)) Signal.emitSignal("fehu", true);
		}
		if (PlayState.lvl.name == "C13" && puzzleSet(["othalacheck"])){
			if (drawingCheck(FlxPoint.weak(14, 4), othalaDrawing)) Signal.emitSignal("othala", true);
		}
		if (PlayState.lvl.name == "B7" && puzzleSet(["holecheck"])){
			if (drawingCheck(FlxPoint.weak(12, 13), holeDrawing)) Signal.emitSignal("hole", true);
		}
	}
	
	static function puzzleSet(set:Array<String>){
		for (s in set){
			if (signals.indexOf(s) == -1){
				return false;
			}
		}
		return true;
	}
	
	static function puzzleNot(set:Array<String>){
		for (s in set){
			if (signals.indexOf(s) != -1){
				return false;
			}
		}
		return true;
	}
	
	static function drawingCheck(start:FlxPoint, drawing:Array<Array<Int>>):Bool {
		var startX:Int = Math.floor(start.x);
		var startY:Int = Math.floor(start.y);
		for (y in 0...drawing.length){
			for (x in 0...drawing[y].length){
				var tile:Int = PlayState.lvl.col.getTile(x + startX, y + startY);
				if (drawing[y][x] == 1 && !(tile == 2 || tile == 3 || tile == 5)) return false;
				if (drawing[y][x] == 0 && !(tile == 0 || tile == 4 || tile == 6)) return false;
			}
		}
		return true;
		
	}
	
}