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
	public var canChoose:Bool = true;
	public var dashing:Bool = false;
	public var dashing_down:Bool = false;
	
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
			canChoose = false;
			
			if (dashing_down)
			{
				maxVelocity.y -= 300;
				dashing_down = false;
			}
		}
		
		if (isTouching(FlxObject.ANY) || (velocity.x < 20 && velocity.x > -20))
		{
			stopDashSimple();
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
	
	public function dash(ToTheRight:Bool):Void
	{
		velocity.y = 0;
		maxVelocity.x += 330;
		acceleration.y -= 100;
		if (acceleration.y < 0) acceleration.y = 0;
		drag.x -= 200;
		if (drag.x < 0) drag.x = 0;
		
		if (ToTheRight)
		{
			velocity.x += 330;
		}
		
		else
		{
			velocity.x -= 330;
		}
		
		dashing = true;
		canChoose = false;
		new FlxTimer(0.35, stopDash);
	}
	
	public function stopDash(T:FlxTimer):Void
	{
		stopDashSimple();
	}
	
	public function stopDashSimple():Void
	{
		if (dashing)
		{
			maxVelocity.x -= 330;
			if (maxVelocity.x < 0) maxVelocity.x = 0;
			acceleration.y += 100;
			drag.x += 200;
			dashing = false;
		}
	}
	
	override public function s_unserialize(S:String):Void 
	{
		_arr.splice(0, _arr.length);
		
		_arr = Unserializer.run(S);
		
		if (_arr.length == 9)
		{
			move_right = _arr[0];
			move_left = _arr[1];
			move_jump = _arr[2];
			a = _arr[3];
			isRight = _arr[4];
			shoot = _arr[5];
			dash_left = _arr[6];
			dash_right = _arr[7];
			dash_down = _arr[8];
			
			if (!dashing)
			{
				if (move_right) //move right
				{
					velocity.x += 20;
				}
				
				if (move_left) //move left
				{
					velocity.x += -20;
				}
				
				if (canChoose && dash_down)
				{
					velocity.y += 300;
					maxVelocity.y += 300;
					canChoose = false;
					dashing_down = true;
				}
			}
			
			else
			{
				if (move_right && velocity.x < 0) //move right
				{
					velocity.x += 20;
				}
				
				if (move_left && velocity.x > 0) //move left
				{
					velocity.x += -20;
				}
			}
			
			if (!dashing && canChoose)
			{
				if (dash_left)
				{
					dash(false);
				}
				
				if (dash_right)
				{
					dash(true);
				}
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
					if (canChoose)
					{
						velocity.y = -210;
						canChoose = false;
					}
					
					else
					{
						move_jump = false;
					}
				}
			}
			
			if (shoot && alive) //shoot
			{
				fire();
			}
		}
	}
}