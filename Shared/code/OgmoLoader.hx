package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.util.FlxBitmapUtil;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxPoint;
import flixel.util.loaders.CachedGraphics;
import flixel.util.loaders.TextureRegion;
import haxe.xml.Fast;

#if SERVER
import entities.Flag;
import entities.HealthPack;
import entities.Spawn;
import entities.CapturePoint;
#end

/**
 * ...
 * @author Ohmnivore
 */

class OgmoLoader
{
	public static var tilemaps:Map<String, String>;
	public static var inits:Map<String, Bool>;
	
	static public function initTilemaps():Void
	{
		//Initializing entities
		#if SERVER
		Spawn;
		Flag;
		HealthPack;
		CapturePoint;
		#end
		
		inits = new Map<String, Bool>();
		
		tilemaps = new Map<String, String>();
		tilemaps.set("grid", "assets/images/gridtiles2.png");
		tilemaps.set("tiles", "assets/images/scifitiles.png");
	}
	
	static public function loadXML(XML:String, State:PlayState):Void
	{
		var xml = Xml.parse(XML);
		
		var fast = new Fast(xml.firstElement());
		
		for (x in fast.elements)
		{
			if (x.has.tileset) //Tilemap
			{
				var map:FlxTilemap = new FlxTilemap();
				map.loadMap(x.innerData, Assets.getImg("assets/images/scifitiles.png"), 16, 16, 0, 0, 0, 0);
				State.maps.add(map);
			}
			
			else
			{
				if (!x.has.exportMode) //Entity layer
				{
					#if SERVER
					for (ent in x.elements)
					{
						var c:Class<Dynamic> = Type.resolveClass("entities." + ent.name);
						
						if (!inits.exists(ent.name))
						{
							var funct2:Dynamic = Reflect.field(c, "init");
							Reflect.callMethod(c, funct2, []);
							inits.set(ent.name, true);
						}
						
						var funct:Dynamic = Reflect.field(c, "makeFromXML");
						Reflect.callMethod(c, funct, [ent]);
					}
					#end
				}
				
				else //Grid layer
				{
					var mapdata:GridData = loadGrid(x);
					
					var map:FlxTilemap = new FlxTilemap();
					map.widthInTiles = mapdata.widthInTiles;
					map.heightInTiles = mapdata.heightInTiles;
					
					map.loadMap(mapdata.arr, ArtifactFix.artefactFix(Assets.getImg("assets/images/gridtiles2.png"), 16, 16),
						16, 16, 0, 0, 1, 1);
					makeTileCollisions(map);
					State.maps.add(map);
					map.setDirty(true);
					
					State.collidemap = map;
					
					if (x.name.indexOf("Tiles") > -1)
					{
						FlxG.worldBounds.set(map.x - 100, map.y - 100, map.width + 200, map.height + 200);
					}
				}
			}
		}
	}
	
	static public function makeTileCollisions(M:FlxTilemap):Void
	{
		M.setTileProperties(16, FlxObject.NONE, 4);
		M.setTileProperties(20, FlxObject.NONE, 2);
	}
	
	static public function findGridWidth(GridStrArr:Array<String>):Int
	{
		return GridStrArr[0].length;
	}
	
	static public function findGridHeight(GridStrArr:Array<String>):Int
	{
		return GridStrArr.length;
	}
	
	static public function loadGrid(X:Fast):GridData
	{
		var returnData:GridData = new GridData();
		
		var col:Array<Dynamic> = new Array();
		
		var gridstrings:Array<String> = X.innerData.split("\n");
		returnData.widthInTiles = findGridWidth(gridstrings);
		returnData.heightInTiles = findGridHeight(gridstrings);
		
		gridInit(X.innerData, col);
		
		var buffer:Array<Int> = new Array();
		
		var i_col:Int = 0; //x
		var i_row:Int = 0; //y
		
		while (i_row < col.length)
		{
			i_col = 0;
			var g_row:Array<Bool> = col[i_row];
			
			while (i_col < g_row.length)
			{
				if (getXY(i_col, i_row, col))
				{
					var sum:Int = 0;
					
					if (i_row - 1 >= 0)
					{
						if (getXY(i_col, i_row - 1, col)) //Up
						{
							sum += 1;
						}
					}
					if (i_row + 1 < col.length)
					{
						if (getXY(i_col, i_row + 1, col)) //Down
						{
							sum += 4;
						}
					}
					if (i_col - 1 >= 0)
					{
						if (getXY(i_col - 1, i_row, col)) //Left
						{
							sum += 8;
						}
					}
					if (i_col + 1 < g_row.length)
					{
						if (getXY(i_col + 1, i_row, col)) //Right
						{
							sum += 2;
						}
					}
					
					buffer.push(sum);
				}
				
				else
				{
					buffer.push(-1);
				}
				
				i_col++;
			}
			
			i_row++;
		}
		
		i_col = 0; //x
		i_row = 0; //y
		
		while (i_row < col.length)
		{
			i_col = 0;
			var g_row:Array<Bool> = col[i_row];
			
			while (i_col < g_row.length)
			{
				var sum:Int = getBuffer(i_col, i_row, g_row.length, buffer);
				if (sum != -1)
				{
					addDetail(i_col, i_row, g_row.length, buffer, sum);
				}
				
				incrementTile(i_col, i_row, g_row.length, buffer, sum);
				
				i_col++;
			}
			
			i_row++;
		}
		
		returnData.arr = buffer;
		
		return returnData;
	}
	
	static public function incrementTile(X:Int, Y:Int, Width:Int, Buffer:Array<Int>, Sum:Int):Void
	{
		setBuffer(X, Y, Width, Sum + 1, Buffer);
	}
	
	static public function addDetail(X:Int, Y:Int, Width:Int, Buffer:Array<Int>, Sum:Int):Void
	{
		if (Sum == 14 || Sum == 10)
		{
			if (FlxRandom.chanceRoll(40))
			{
				if (Y - 1 >= 0) 
					setBuffer(X, Y - 1, Width, FlxRandom.intRanged(17, 20), Buffer);
			}
		}
		
		if (Sum == 11 || Sum == 10)
		{
			if (FlxRandom.chanceRoll(30))
			{
				if (Y + 1 < Buffer.length / Width)
					setBuffer(X, Y + 1, Width, FlxRandom.intRanged(20, 23), Buffer);
			}
		}
	}
	
	static public function setBuffer(X:Int, Y:Int, Width:Int, ToSet:Int, Buffer:Array<Int>):Void
	{
		var index:Int = Y * Width + X;
		Buffer[index] = ToSet;
	}
	
	static public function getBuffer(X:Int, Y:Int, Width:Int, Buffer:Array<Int>):Int
	{
		return Buffer[Y * Width + X];
	}
	
	static public function gridInit(Grid:String, col:Array<Dynamic>):Void
	{
		var gridrows:Array<String> = Grid.split("\n");
		
		var g_row:Int = 0;
		for (g in gridrows)
		{
			var g_col:Int = 0;
			var g_arr:Array<Bool> = new Array();
			
			while (g_col < g.length)
			{
				var char:String = g.charAt(g_col);
				
				if (char == "1")
				{
					g_arr.insert(g_col, true);
				}
				
				else
				{
					g_arr.insert(g_col, false);
				}
				
				g_col++;
			}
			
			col.insert(g_row, g_arr);
			g_row++;
		}
	}
	
	static public function getXY(X:Int, Y:Int, Arr:Array<Dynamic>):Bool
	{
		return Arr[Y][X];
	}
}

class GridData
{
	public var arr:Array<Int>;
	public var widthInTiles:Int;
	public var heightInTiles:Int;
	
	public function new()
	{
		
	}
}