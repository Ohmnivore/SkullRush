package ;
import enet.ENet;
import entities.Spawn;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import haxe.Unserializer;
import networkobj.NEmitter;
import networkobj.NWeapon;
import ext.FlxWeaponExt;

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
	
	public var canSpawn:Bool = false;
	
	public var score:Int = 0;
	public var kills:Int = 0;
	public var deaths:Int = 0;
	
	public var _jump:Float;
	public var doJump:Bool = false;
	public var jumping:Bool = false;
	public var wallJumped:Bool = false;
	
	public function new(Id:Int, Name:String, X:Int, Y:Int)
	{
		super(Id, Name, X, Y);
		setGun(1);
		last_shot = cannon;
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
	override public function update():Void 
	{
		//Jump code
		//if (!isTouching(FlxObject.FLOOR))
			//landBuffer = false;
		
		if(doJump && !jumping && canJump)  // Only play the jump sound once per jump
		{                                                // There are probably better ways to do this, but this is fast and good enough
			//onJump();
			jumping = true;
		}
		
		if(_jump >= 0 && doJump && canJump) //You can also use space or any other key you want
		{
			_jump += FlxG.elapsed;
			if(_jump > 0.25) _jump = -1; //You can't jump for more than 0.25 seconds
		}
		else _jump = -1;

		if (_jump > 0)
		{
			if(_jump < 0.035)   // this number is how long before a short slow jump shifts to a faster, high jump
			{
				velocity.y = -.6 * PlayerBase.jumpHeight; //This is the minimum height of the jump
			}
			else
			{
				velocity.y = -.8 * PlayerBase.jumpHeight;
			}
		}
		
		if (isTouching(FlxObject.DOWN))
		{
			canJump = true;
			canChoose = false;
			
			_jump = 0;
			jumping = false;
			wallJumped = false;
			
			if (dashing_down)
			{
				maxVelocity.y -= 300;
				dashing_down = false;
			}
		}
		
		if ((isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)) && !wallJumped && doJump)
		{
			_jump = 0;
			jumping = false;
			canJump = true;
			wallJumped = true;
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
	
	public function respawnIn(Seconds:Float, Channel:Int = 1):Void
	{
		//FlxTimer.start(Seconds, respawnCall, 1);
		canSpawn = false;
		new FlxTimer(Seconds, respawnCall, 1);
		Msg.DeathInfo.data.set("timer", Std.int(Seconds));
		Reg.server.sendMsg(ID, Msg.DeathInfo.ID, Channel, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	public function respawnCall(T:FlxTimer):Void
	{
		canSpawn = true;
	}
	
	public function respawn():Void
	{
		var s:Spawn = Spawn.findSpawn(team);
		if (s != null)
		{
			setGun(1, true);
			
			x = s.x;
			y = s.y;
			
			velocity.y = 0;
			velocity.x = 0;
			
			if (!visible)
				show();
			health = 100;
			alive = true;
			allowCollisions = FlxObject.ANY;
			
			canSpawn = false;
		}
		
		Msg.SpawnConfirm.data.set("color", header.color);
		Msg.SpawnConfirm.data.set("graphic", graphicKey);
		Reg.server.sendMsg(ID, Msg.SpawnConfirm.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
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
	
	override public function setGun(GunID:Int, Force:Bool = false):Void
	{
		if (Std.is(GunID, Int))
		{
			if (grantedWeps.exists(GunID))
			{
				if (grantedWeps.get(GunID) == true)
				{
					var g:FlxWeaponExt = guns_arr[GunID - 1];
					if (g != null)
					{
						if (Force || canChange)
						{
							if (gun != null)
								gun.visible = false;
							g.gun.visible = true;
							gun = g.gun;
							if (cannon != null)
								g.nextFire = cannon.nextFire;
							cannon = g;
							
							current_weap = GunID;
							
							canChange = false;
							weap_change_timer.reset(0.3);
							
							gun.x = x + width/2 - gun.width / 2;
							gun.y = y + height/2 - gun.height / 2 + 2;
						}
					}
				}
			}
		}
	}
	
	override public function s_unserialize(S:String):Void 
	{
		_arr.splice(0, _arr.length);
		
		_arr = Unserializer.run(S);
		
		if (_arr.length == 10)
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
			if (current_weap != _arr[9])
			{
				setGun(_arr[9]);
			}
			
			if (!dashing)
			{
				if (move_right) //move right
				{
					//velocity.x += 50;
					acceleration.x = PlayerBase.speedX;
				}
				
				else if (move_left) //move left
				{
					//velocity.x += -50;
					acceleration.x = -PlayerBase.speedX;
				}
				
				else
				{
					acceleration.x = 0;
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
					//velocity.x += 50;
					acceleration.x = PlayerBase.speedX;
				}
				
				else if (move_left && velocity.x > 0) //move left
				{
					//velocity.x += -50;
					acceleration.x = -PlayerBase.speedX;
				}
				
				else
				{
					acceleration.x = 0;
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
			doJump = move_jump;
			if (move_jump) //jump
			{
				if (isTouching(FlxObject.ANY) && canJump)
				{
					//velocity.y = -PlayerBase.jumpHeight;
					//canJump = false;
				}
				
				else
				{
					if (canChoose && (_jump == 0 || _jump == -1))
					{
						velocity.y = -PlayerBase.jumpHeight;
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
				if (!(cannon.fireRate > 0 && FlxG.game.ticks < cannon.nextFire))
					fire();
				else
					shoot = false;
			}
		}
	}
}