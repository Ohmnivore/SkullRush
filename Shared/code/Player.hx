package ;
import flixel.addons.effects.FlxTrail;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends FlxSprite
{
	public var peer:Dynamic;
	
	public var name:String;
	public var team:Int;
	public var a:Float;
	public var isRight:Bool;
	
	public var move_right:Bool;
	public var move_left:Bool;
	public var move_jump:Bool;
	public var shoot:Bool;
	
	private var _arr:Array<Dynamic>;
	public var cannon:FlxWeaponExt;
	public var trail:FlxTrailExt;
	
	public function new(Id:Int, Peer:Dynamic, X:Int, Y:Int) 
	{
		super(X, Y);
		ID = Id;
		peer = Peer;
		a = 1;
		isRight = true;
		move_right = false;
		move_left = false;
		move_jump = false;
		shoot = false;
		_arr = [];
		
		makeGraphic(24, 24);
		
		acceleration.y = 440;
		drag.x = 120;
		maxVelocity.x = 150;
		
		cannon = new FlxWeaponExt("launcher", this, FlxBullet, 0);
		cannon.makePixelBullet(4, 4, 4, FlxColor.CYAN);
		cannon.setBulletSpeed(220);
		cannon.setBulletBounds(Reg.state.collidemap.getBounds());
		cannon.setFireRate(1200);
		cannon.setBulletOffset(12, 12);
		cannon.setBulletInheritance(0.5, 0.5);
		
		trail = new FlxTrailExt(this, "shared/images/trail.png", 7, 2, 0.4, 0.08);
		trail.setTrailOffset(4, 4);
		
		Reg.state.under_players.add(trail);
		Reg.state.bullets.add(cannon.group);
		Reg.state.players.add(this);
	}
	
	override public function update():Void 
	{
		if (!Reg.host.isServer)
		{
			//Move right
			if (FlxG.keys.pressed.D)
			{
				move_right = true;
				velocity.x += 20;
			}
			else
			{
				move_right = false;
			}
			
			//Move left
			if (FlxG.keys.pressed.A)
			{
				move_left = true;
				velocity.x += -20;
			}
			else
			{
				move_left = false;
			}
			
			//Jump
			if (FlxG.keys.justPressed.W)
			{
				if (isTouching(FlxObject.ANY))
				{
					move_jump = true;
					velocity.y = -280;
				}
			}
			else
			{
				move_jump = false;
			}
			
			//Shoot
			if (FlxG.mouse.pressed)
			{
				shoot = true;
				cannon.fireAtMouse();
			}
			else
			{
				shoot = false;
			}
		}
		
		super.update();
	}
	
	public function s_serialize():String
	{
		_arr.splice(0, _arr.length);
		
		_arr.push(ID);
		_arr.push(x);
		_arr.push(y);
		_arr.push(a);
		_arr.push(isRight);
		
		return Serializer.run(_arr);
	}
	
	public function c_unserialize(Arr:Array<Dynamic>):Void
	{
		_arr = Arr;
		
		x = _arr[1];
		y = _arr[2];
		
		velocity.x = _arr[1] - x;
		velocity.y = _arr[2] - y;
		
		a = _arr[3];
		isRight = _arr[4];
	}
	
	public function c_serialize():String
	{
		_arr.splice(0, _arr.length);
		
		_arr.push(move_right);
		_arr.push(move_left);
		_arr.push(move_jump);
		_arr.push(a);
		_arr.push(isRight);
		
		return Serializer.run(_arr);
	}
	
	public function s_unserialize(S:String):Void
	{
		_arr.splice(0, _arr.length);
		
		_arr = Unserializer.run(S);
		
		if (_arr[0] == true) //move right
		{
			
		}
		
		if (_arr[1] == true) //move left
		{
			
		}
		
		if (_arr[2] == true) //jump
		{
			
		}
		
		a = _arr[3];
		isRight = _arr[4];
	}
}