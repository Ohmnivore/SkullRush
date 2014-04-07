package ;
import flash.text.TextFormat;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class FlxTextExt extends FlxText
{
	public var markups:Array<FlxMarkup>;
	public var autowidth:Bool;
	
	public function new(X:Float, Y:Float, Width:Int, ?Text:String, size:Int = 8, Autowidth:Bool = true, Markups:Array<FlxMarkup> = null, EmbeddedFont:Bool = true) 
	{
		markups = [];
		autowidth = Autowidth;
		
		super(X, Y, Width, Text, size, EmbeddedFont);
		
		if (autowidth)
		{
			_textField.multiline = false;
			_textField.wordWrap = false;
		}
		
		if (Markups != null)
		{
			for (mark in Markups)
			{
				markItUp(mark);
			}
		}
		
		setRealWidth();
	}
	
	public function setRealWidth():Void
	{
		width = textField.textWidth + 4;
	}
	
	public function markItUp(mark:FlxMarkup):Void
	{
		markups.push(mark);
		_textField.setTextFormat(new TextFormat("system", mark.size, mark.color), 
								mark.startindex, mark.endindex);
		calcFrame();
		setRealWidth();
	}
	
	/**
	 * Returns a serialized array of this instance's markups
	 */
	public function ExportMarkups():String
	{
		var arr:Array<Dynamic> = [];
		
		for (m in markups)
		{
			var arrm:Array<Dynamic> = [];
			
			arrm.push(m.startindex);
			arrm.push(m.endindex);
			arrm.push(m.size);
			arrm.push(m.color);
			
			arr.push(arrm);
		}
		
		return Serializer.run(arr);
	}
	
	/**
	 * Markups the text using the serialized string that is passed to this function
	 */
	public function ImportMarkups(ser_markups:String):Void 
	{
		if (ser_markups.length > 2)
		{
			var arr:Array<Dynamic> = Unserializer.run(ser_markups);
			
			for (m in arr)
			{
				markItUp(new FlxMarkup(m[0], m[1], m[2], m[3]));
			}
		}
	}
}