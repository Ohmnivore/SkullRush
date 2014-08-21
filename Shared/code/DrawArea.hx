package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class DrawArea extends FlxSprite
{
	public function new() 
	{
		super(0, 0);
		
		scrollFactor.set();
		
		makeGraphic(FlxG.width, FlxG.height, 0x00000000);
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		FlxSpriteUtil.fill(this, 0x00000000);
	}
}