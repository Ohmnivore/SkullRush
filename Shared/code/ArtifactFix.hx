package ;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.util.loaders.CachedGraphics;
import flixel.util.loaders.TextureRegion;
import flixel.system.layer.Region;

/**
 * ...
 * @author Ohmnivore
 */
class ArtifactFix
{

	static public function artefactFix(Graphic:Dynamic, FrameWidth:Int, FrameHeight:Int):TextureRegion 
	{
		var cached:CachedGraphics = FlxG.bitmap.add(Graphic, false);
		
		var cont:BitmapData = ArtifactFix.returnContainer(cached.bitmap.width, cached.bitmap.height, FrameWidth, FrameHeight);
		ArtifactFix.placeTiles(cached.bitmap, cont, FrameWidth, FrameHeight);
		ArtifactFix.placeSafePixelColumn(cached.bitmap, cont, FrameWidth, FrameHeight);
		
		var newcached:CachedGraphics = FlxG.bitmap.add(cont, true);
		
		//top left corner of the first tile
		var startX:Int = 1;
		var startY:Int = 1;
		//tile size
		var tileWidth:Int = FrameWidth;
		var tileHeight:Int = FrameHeight;
		//tile spacing
		var spacingX:Int = 2;
		var spacingY:Int = 2;
		//end of tiles
		var width:Int = Std.int(cont.width - startX);
		var height:Int = Std.int(cont.height - startY);
		//return region
		return new TextureRegion(newcached, startX, startY, tileWidth, tileHeight, spacingX, spacingY, width, height);
	}
	
	static public function placeSafePixelColumn(Source:BitmapData, Dest:BitmapData, TileWidth:Int, TileHeight:Int):Void
	{
		var border:Int = 1;
		var x_tot:Int = Std.int(Source.width / TileWidth);
		var y_tot:Int = Std.int(Source.height / TileHeight);
		var x_count:Int = 0;
		var y_count:Int = 0;
		
		while (x_count < x_tot)
		{
			while (y_count < y_tot)
			{
				//To the right
				var rect:Rectangle = new Rectangle(x_count * TileWidth - 1, y_count * TileWidth,
					1, TileHeight);
				var point:Point = new Point(border + x_count * TileWidth + x_count * 2 - 2,
					border + y_count * TileHeight + y_count * 2);
				Dest.copyPixels(Source, rect, point, true);
				
				//To the bottom
				var rect2:Rectangle = new Rectangle(x_count * TileWidth, y_count * TileWidth - 1,
					TileWidth, 1);
				var point2:Point = new Point(border + x_count * TileWidth + x_count * 2,
					border + y_count * TileHeight + y_count * 2 - 2);
				Dest.copyPixels(Source, rect2, point2, true);
				
				y_count++;
			}
			
			y_count = 0;
			x_count++;
		}
	}
	
	static public function placeTiles(Source:BitmapData, Dest:BitmapData, TileWidth:Int, TileHeight:Int):Void
	{
		var border:Int = 1;
		var x_tot:Int = Std.int(Source.width / TileWidth);
		var y_tot:Int = Std.int(Source.height / TileHeight);
		var x_count:Int = 0;
		var y_count:Int = 0;
		
		while (x_count < x_tot)
		{
			while (y_count < y_tot)
			{
				var rect:Rectangle = new Rectangle(x_count * TileWidth, y_count * TileWidth,
					TileWidth, TileHeight);
				var point:Point = new Point(border + x_count * TileWidth + x_count * 2,
					border + y_count * TileHeight + y_count * 2);
				Dest.copyPixels(Source, rect, point, true);
				
				y_count++;
			}
			
			y_count = 0;
			x_count++;
		}
	}
	
	static public function returnContainer(Width:Int, Height:Int, TileWidth:Int, TileHeight:Int):BitmapData
	{
		var width:Int = Width + (Std.int(Width / TileWidth) - 1) * 2 + 2;
		var height:Int = Height + (Std.int(Height / TileHeight) - 1) * 2 + 2;
		
		return new BitmapData(width, height, true, 0x00ffffff);
	}
	
}