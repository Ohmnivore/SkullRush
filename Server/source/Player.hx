package ;
import entities.Spawn;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

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
			if (alive)
			{
				if (visible)
					hide();
				alive = false;
				allowCollisions = FlxObject.NONE;
				
				//respawnIn(4);
			}
		}
	}
	
	public function respawnIn(Seconds:Float):Void
	{
		FlxTimer.start(Seconds, respawnCall, 1);
	}
	
	public function respawnCall(T:FlxTimer):Void
	{
		respawn();
	}
	
	public function respawn():Void
	{
		var s:Spawn = Spawn.findSpawn(team);
		if (s != null)
		{
			x = s.x;
			y = s.y;
			
			velocity.y = 0;
			velocity.x = 0;
		}
		
		if (!visible)
				show();
		health = 100;
		alive = true;
		allowCollisions = FlxObject.ANY;
	}
}