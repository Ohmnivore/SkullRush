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
		
		if (status != STOPPED)
		{
			var m:Int = Math.floor(count / 60);
			
			var s:Int = Std.int(count - 60 * m);
			
			if (s < 10)
			{
				text = '$base:  $m:0$s';
			}
			
			else
			{
				text = '$base:  $m:$s';
			}
		}
	}
}