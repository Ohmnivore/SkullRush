package ;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends PlayerBase
{
	public function new(Id:Int, Name:String, X:Int, Y:Int)
	{
		super(Id, Name, X, Y);
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (health <= 0)
		{
			alive = false;
			
			if (visible)
				hide();
		}
		
		else
		{
			if (!visible)
				show();
		}
	}
}