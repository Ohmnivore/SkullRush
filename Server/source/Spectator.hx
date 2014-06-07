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
	static public inline var speed:Int = 100;
	static public inline var cam_lerp:Int = 20;
	static public inline var max_velocity:Int = 230;
	
	public function new() 
	{
		super(FlxG.width / 2, FlxG.height / 2);
		
		FlxG.camera.follow(this);
		FlxG.camera.followLerp = cam_lerp;
		
		maxVelocity = new FlxPoint(max_velocity, max_velocity);
		drag = new FlxPoint(max_velocity, max_velocity);
		
		visible = false;
	}
	
	override public function update():Void 
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			x = Reg.state.collidemap.x + Reg.state.collidemap.width / 2;
			y = Reg.state.collidemap.y + Reg.state.collidemap.height / 2;
		}
		
		if (FlxG.keys.anyPressed(["W", "UP"]))
		{
			velocity.y -= speed;
		}
		
		if (FlxG.keys.anyPressed(["S", "DOWN"]))
		{
			velocity.y += speed;
		}
		
		if (FlxG.keys.anyPressed(["D", "RIGHT"]))
		{
			velocity.x += speed;
		}
		
		if (FlxG.keys.anyPressed(["A", "LEFT"]))
		{
			velocity.x -= speed;
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