package ;
import entities.Spawn;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends PlayerBase
{
	public var canJump:Bool = true;
	
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
		if (isTouching(FlxObject.DOWN))
		{
			canJump = true;
		}
		
		super.update();
		
		//if (isTouching(FlxObject.DOWN))
		//{
			//canJump = true;
		//}
		
		//if (justTouched(FlxObject.DOWN))
		//{
			//canJump = true;
		//}
		
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
		//FlxTimer.start(Seconds, respawnCall, 1);
		new FlxTimer(Seconds, respawnCall, 1);
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
	
	override public function s_unserialize(S:String):Void 
	{
		_arr.splice(0, _arr.length);
		
		_arr = Unserializer.run(S);
		
		if (_arr.length == 6)
		{
			move_right = _arr[0];
			move_left = _arr[1];
			move_jump = _arr[2];
			a = _arr[3];
			isRight = _arr[4];
			shoot = _arr[5];
			
			if (move_right) //move right
			{
				velocity.x += 20;
			}
			
			if (move_left) //move left
			{
				velocity.x += -20;
			}
			
			if (move_jump) //jump
			{
				//trace("jumping");
				if (isTouching(FlxObject.ANY) && canJump)
				{
					//trace(_arr[2]);
					velocity.y = -280;
					canJump = false;
				}
				
				else
				{
					//trace("not jumping");
					move_jump = false;
				}
			}
			
			if (shoot && alive) //shoot
			{
				fire();
			}
		}
	}
}