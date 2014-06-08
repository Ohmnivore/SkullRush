package ;
import flixel.ui.FlxBar;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class WeaponBar extends FlxBar
{

	public function new(X:Float = 0, Height:Int = 100) 
	{
		super(X, 0, FlxBar.FILL_TOP_TO_BOTTOM, 10, Height, null, "", 0, 2000, true);
		
		scrollFactor.set();
		createFilledBar(0xff00F400, 0xff005100, true, 0xff000000);
		
		centerY();
	}
	
	public function centerY():Void
	{
		FlxSpriteUtil.screenCenter(this, false, true);
	}
	
}