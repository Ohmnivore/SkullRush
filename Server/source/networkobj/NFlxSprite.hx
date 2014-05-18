package networkobj;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class NFlxSprite extends FlxSprite
{
	public var parent:NSprite;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:NSprite) 
	{
		super(X, Y, GraphicString);
		
		parent = Parent;
	}
	
}