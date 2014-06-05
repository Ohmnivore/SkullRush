package ;
import flixel.effects.particles.FlxEmitterExt;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Ohmnivore
 */
class FlxEmitterAuto extends FlxEmitterExt
{
	public var parent:FlxGroup;
	public var autoDestroy:Bool = true;
	public var buffer:Bool = false;
	
	/**
	 * Creates a new FlxEmitterExt object at a specific position.
	 * Does NOT automatically generate or attach particles!
	 * 
	 * @param	X		The X position of the emitter.
	 * @param	Y		The Y position of the emitter.
	 * @param	Size	Optional, specifies a maximum capacity for this emitter.
	 * @param	Parent	The group this emitter is added to
	 */
	public function new(Parent:FlxGroup, X:Float = 0, Y:Float = 0, Size:Int = 0)
	{
		super(X, Y, Size);
		parent = Parent;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (autoDestroy == true)
		{
			if (countLiving() <= 0)
			{
				if (buffer == true)
				{
					parent.remove(this, true);
					on = false;
					kill();
					destroy();
				}
			}
			
			else
			{
				buffer = true;
			}
		}
	}
}