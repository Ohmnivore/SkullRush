package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Ohmnivore
 */
class Spectator extends FlxSprite
{
	public function new() 
	{
		super(FlxG.width / 2, FlxG.height / 2);
		
		FlxG.camera.follow(this);
		FlxG.camera.followLerp = 20;
		
		maxVelocity = new FlxPoint(230, 230);
		drag = new FlxPoint(230, 230);
		
		visible = false;
	}
	
	override public function update():Void 
	{
		if (FlxG.keys.anyPressed(["W", "UP"]))
		{
			velocity.y -= 70;
		}
		
		if (FlxG.keys.anyPressed(["S", "DOWN"]))
		{
			velocity.y += 70;
		}
		
		if (FlxG.keys.anyPressed(["D", "RIGHT"]))
		{
			velocity.x += 70;
		}
		
		if (FlxG.keys.anyPressed(["A", "LEFT"]))
		{
			velocity.x -= 70;
		}
		
		if (x < Reg.state.collidemap.x)
			x = Reg.state.collidemap.x;
		
		if (x > Reg.state.collidemap.x + Reg.state.collidemap.width)
			x = Reg.state.collidemap.x + Reg.state.collidemap.width;
		
		if (y < Reg.state.collidemap.y)
			y = Reg.state.collidemap.y;
		
		if (y > Reg.state.collidemap.y + Reg.state.collidemap.height)
			y = Reg.state.collidemap.y + Reg.state.collidemap.height;
		
		super.update();
	}
	
}