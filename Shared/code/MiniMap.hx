package ;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import haxe.xml.Fast;
import OgmoLoader.TileDef;

/**
 * ...
 * @author ...
 */
class MiniMap
{
	static public function loadXML(XML:String, State:PlayState):Void
	{
		var xml = Xml.parse(XML);
		
		var fast = new Fast(xml.firstElement());
		
		var arrays:Array<Dynamic> = [];
		var heights:Array<Dynamic> = [];
		
		for (x in fast.elements)
		{
			if (x.has.tileset) //Tilemap layer
			{
				var td:TileDef = OgmoLoader.loadFile(Assets.getImg(x.att.tileset));
				
				var data:String = x.innerData;
				var height:Int = data.split("\n").length;
				heights.push(height);
				var arr:Array<Int> = interpretData(td, data);
				arrays.push(arr);
				
				var map:FlxTilemap = makeTilemap(State, arr, height);
			}
			else
			{
				if (x.has.exportMode) //Grid layer
				{
					var data:String = x.innerData;
					var height:Int = data.split("\n").length;
					heights.push(height);
					var arr:Array<Int> = getArrayGrid(data);
					
					makeTilemap(State, arr, height);
					arrays.push(arr);
				}
			}
		}
		
		var mergedArray:Array<Int> = arrays[0];
		var index:Int = 1;
		while (index < arrays.length)
		{
			mergedArray = mergeArrays(mergedArray, cast arrays[index]);
			
			index++;
		}
		
		//makeTilemap(State, mergedArray, heights[0]);
		
		var height:Int = Std.int(heights[0] * 1);
		var width:Int = Std.int(mergedArray.length / heights[0]) * 1;
		var scaleX:Float = FlxG.width / width;
		var scaleY:Float = FlxG.height / height;
		
		for (t in State.minimaps.members)
		{
			var tilemap:FlxTilemap = cast t;
			
			tilemap.scrollFactor.set();
			
			if (scaleX > scaleY)
				tilemap.scale.set(scaleY, scaleY);
			else
				tilemap.scale.set(scaleX, scaleX);
		}
	}
	
	static public function toggleMap(S:PlayState):Void
	{
		S.minimaps.visible = !S.minimaps.visible;
	}
	
	static private function interpretData(T:TileDef, S:String):Array<Int>
	{
		var Arr:Array<Int> = [];
		S = StringTools.replace(S, "\n", ","); 
		var rawArr:Array<String> = S.split(",");
		
		var index:Int = 0;
		var height:Int = S.split("\n").length;
		var width:Int = Std.int(rawArr.length / height);
		
		while (index < rawArr.length)
		{
			var x:String = StringTools.trim(rawArr[index]);
			x = StringTools.trim(x); 
			var number:Int = Std.parseInt(x);
			
			if (T.tiles.exists(number))
			{
				var props:Map<String, Dynamic> = T.getTileProps(number);
				
				number = 0;
				if (props.get("Solid") == true)
				{
					number = 1;
				}
			}
			else
			{
				number = 0;
			}
			
			Arr.push(number);
			
			//if ((index % width) == 0)
			//{
				//Arr.push(0);
			//}
			
			index++;
		}
		
		return Arr;
	}
	
	static private function getArray(S:String):Array<Int>
	{
		var Arr:Array<Int> = [];
		var rawArr:Array<String> = S.split(",");
		
		var index:Int = 0;
		var height:Int = S.split("\n").length;
		var width:Int = Std.int(rawArr.length / height);
		
		while (index < rawArr.length)
		{
			var x:String = StringTools.trim(rawArr[index]);
			var number:Int = Std.parseInt(x);
			if (number > 1)
				number = 1;
			if (number < 1)
				number = 0;
			Arr.push(number);
			
			//if ((index % width) == 0)
			//{
				//Arr.push(0);
			//}
			
			index++;
		}
		
		return Arr;
	}
	
	static private function getArrayGrid(S:String):Array<Int>
	{
		var Arr:Array<Int> = [];
		var index:Int = 0;
		while (index < S.length)
		{
			var str:String = S.charAt(index);
			if (str == "0" || str == "1")
			{
				var number:Int = Std.parseInt(str);
				Arr.push(number);
			}
			
			index++;
		}
		
		return Arr;
	}
	
	static private function mergeArrays(Arr1:Array<Int>, Arr2:Array<Int>):Array<Int>
	{
		var index:Int = 0;
		var Arr:Array<Int> = [];
		
		while (index < Arr1.length)
		{
			var v1:Int = Arr1[index];
			var v2:Int = Arr2[index];
			
			if (v1 > v2)
			{
				Arr.push(v1);
			}
			else
			{
				Arr.push(v2);
			}
			
			index++;
		}
		
		return Arr;
	}
	
	static private function makeTilemap(State:PlayState, Arr:Array<Int>, HeightInTiles:Int):FlxTilemap
	{
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.widthInTiles = Std.int(Arr.length / HeightInTiles);
		tilemap.heightInTiles = HeightInTiles;
		tilemap.loadMap(Arr,
			ArtifactFix.artefactFix(Assets.getImg("assets/images/minimaptile2.png"), 1, 1),
			0, 0, FlxTilemap.OFF);
		State.minimaps.add(tilemap);
		
		return tilemap;
	}
}