package networkobj;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class NTimer extends FlxText
{
	public var count:Float = 0;
	private var old_count:Float = 0;
	public var base:String;
	public var status:Int;
	
	static public inline var STOPPED:Int = 0;
	static public inline var TICKING:Int = 1;
	static public inline var UNTICKING:Int = 2;
	
	public function new(Base:String, X:Float, Y:Float)
	{
		base = Base;
		status = STOPPED;
		
		super(X, Y, FlxG.width, '$base:  0:00', 12);
		
		setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
	}
	
	private function countToText(Count:Float):String
	{
		var ret:String = "";
		
		var m:Int = Math.floor(Count / 60);
		
		var s:Int = Std.int(Count - 60 * m);
		
		if (s < 10)
		{
			ret = '$base:  $m:0$s';
		}
		
		else
		{
			ret = '$base:  $m:$s';
		}
		
		return ret;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (status == TICKING)
		{
			count += FlxG.elapsed;
		}
		
		if (status == UNTICKING)
		{
			count -= FlxG.elapsed;
			
			if (count < 0)
				count = 0;
		}
		
		if (old_count != count)
		{
			text = countToText(count);
		}
		
		old_count = count;
	}
}