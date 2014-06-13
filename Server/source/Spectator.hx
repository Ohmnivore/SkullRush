package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;

/**
 * ...
 * @author Ohmnivore
 */
class Spectator extends FlxSprite
{
	static private inline var speed:Int = 100;
	static private inline var cam_lerp:Int = 20;
	static private inline var max_velocity:Int = 230;
	
	static private inline var rectSize:Int = 20;
	private var leftRect:FlxRect;
	private var rightRect:FlxRect;
	private var topRect:FlxRect;
	private var botRect:FlxRect;
	
	public function new() 
	{
		super(FlxG.width / 2, FlxG.height / 2);
		
		FlxG.camera.follow(this);
		FlxG.camera.followLerp = cam_lerp;
		
		maxVelocity = new FlxPoint(max_velocity, max_velocity);
		drag = new FlxPoint(max_velocity * 4, max_velocity * 4);
		
		visible = false;
		
		initRects();
	}
	
	public function initRects():Void
	{
		leftRect = new FlxRect(0, 0, rectSize, FlxG.height);
		
		rightRect = new FlxRect(0, 0, rectSize, FlxG.height);
		rightRect.x = FlxG.width - rightRect.width;
		
		topRect = new FlxRect(0, 0, FlxG.width, rectSize);
		
		botRect = new FlxRect(0, 0, FlxG.width, rectSize);
		botRect.y = FlxG.height - botRect.height;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (!FlxG.debugger.visible)
		{
			if (FlxG.mouse.justPressed)
			{
				x = Reg.state.collidemap.x + Reg.state.collidemap.width / 2;
				y = Reg.state.collidemap.y + Reg.state.collidemap.height / 2;
			}
			
			var mouse_pos:FlxPoint = FlxG.mouse.getScreenPosition();
			
			if (leftRect.containsFlxPoint(mouse_pos))
			{
				velocity.x -= speed;
			}
			if (rightRect.containsFlxPoint(mouse_pos))
			{
				velocity.x += speed;
			}
			if (topRect.containsFlxPoint(mouse_pos))
			{
				velocity.y -= speed;
			}
			if (botRect.containsFlxPoint(mouse_pos))
			{
				velocity.y += speed;
			}
		}
	}
	
}