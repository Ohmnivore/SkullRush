package ;
import flixel.addons.effects.FlxTrail;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends FlxSprite
{
	public var name:String;
	public var team:Int;
	
	public var a:Float;
	public var isRight:Bool;
	public var move_right:Bool;
	public var move_left:Bool;
	public var move_jump:Bool;
	public var shoot:Bool;
	public var ceilingwalk:Bool;
	
	private var _arr:Array<Dynamic>;
	private var cannon:FlxWeaponExt;
	private var trail:FlxTrailExt;
	
	private var gun:FlxSprite;
	private var gun2:FlxSprite;
	
	private var healthBar:FlxBar;
	private var header:FlxTextExt;
	
	public function new(Id:Int, Name:String, X:Int, Y:Int)
	{
		super(X, Y);
		ID = Id;
		a = 1;
		isRight = true;
		move_right = false;
		move_left = false;
		move_jump = false;
		shoot = false;
		ceilingwalk = false;
		_arr = [];
		
		loadGraphic(Assets.getImg("assets/images/playerblue.png"), true, true, 24, 24);
		animation.add("walking", [0, 1, 2, 3, 4, 5], 12, true);
		animation.add("i_walking", [5, 4, 3, 2, 1, 0], 12, true);
		animation.add("idle", [0]);
		
		animation.add("rwalking", [6, 7, 8, 9, 10, 11], 12, true);
		animation.add("ri_walking", [11, 10, 9, 8, 7, 6], 12, true);
		animation.add("ridle", [6]);
		
		animation.add("ledgeidle", [12]);
		
		gun = new FlxSprite(0, 0, Assets.getImg("assets/images/gun.png"));
		gun.loadRotatedGraphic(Assets.getImg("assets/images/gun.png"), 180, -1, false, false);
		Reg.state.over_players.add(gun);
		
		gun2 = new FlxSprite(0, 0, Assets.getImg("assets/images/gun2.png"));
		gun2.loadRotatedGraphic(Assets.getImg("assets/images/gun2.png"), 180, -1, false, false);
		Reg.state.over_players.add(gun2);
		
		health = 100;
		healthBar = new FlxBar(8, 26, FlxBar.FILL_LEFT_TO_RIGHT, 38, 6, this, "health", 0, 100, true);
		healthBar.trackParent(-6, -7);
		healthBar.createFilledBar(0xFFFF0000, 0xFF09FF00, true, 0xff000000);
		Reg.state.over_players.add(healthBar);
		
		name = Name;
		team = 0;
		//teamcolor = 0xff00A8C2;
		
		header = new FlxTextExt(0, 0, 200, name, 8, false);
		Reg.state.over_players.add(header);
		header.color = 0xff00A8C2;
		
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
		
		trail = new FlxTrailExt(this, Assets.getImg("assets/images/trail.png"), 7, 2, 0.4, 0.08);
		trail.setTrailOffset(4, 4);
		
		Reg.state.under_players.add(trail);
		Reg.state.bullets.add(cannon.group);
		Reg.state.players.add(this);
	}
	
	override public function draw():Void
	{
		setFollow();
		
		super.draw();
	}
	
	override public function update():Void 
	{
		updateGuns();
		
		updateAnims();
		
		super.update();
	}
	
	override public function kill():Void 
	{
		Reg.state.under_players.remove(trail, true);
		Reg.state.bullets.remove(cannon.group, true);
		Reg.state.players.remove(this, true);
		Reg.state.over_players.remove(header, true);
		Reg.state.over_players.remove(healthBar, true);
		Reg.state.over_players.remove(gun2, true);
		Reg.state.over_players.remove(gun, true);
		
		gun.kill();
		gun2.kill();
		header.kill();
		healthBar.kill();
		cannon = null;
		super.kill();
	}
	
	public function fire():Void
	{
		cannon.fireFromAngle(Std.int(a));
	}
	
	private function updateGuns():Void
	{
		if (isRight)
		{
			gun2.visible = false;
			gun.visible = true;
			gun.angle = a;
			gun.facing = FlxObject.RIGHT;
			facing = FlxObject.RIGHT;
		}
		else
		{
			gun.visible = false;
			gun2.visible = true;
			gun2.angle = a;
			gun2.facing = FlxObject.LEFT;
			facing = FlxObject.LEFT;
		}
	}
	
	private function updateAnims():Void
	{
		if (!ceilingwalk)
		{
			if (isTouching(FlxObject.ANY))
			{
				if (facing == FlxObject.RIGHT && move_right) { animation.play("walking"); }
				if (facing == FlxObject.LEFT && move_left) { animation.play("walking"); }
				if (facing == FlxObject.RIGHT && move_left) { animation.play("i_walking"); }
				if (facing == FlxObject.LEFT && move_right) { animation.play("i_walking"); }
				else if (!move_left && !move_right) { animation.play("idle"); }
			}
			
			else
			{
				animation.play("idle");
			}
		}
		
		else
		{
			if (isTouching(FlxObject.ANY))
			{
				if (facing == FlxObject.RIGHT && velocity.x > 0) { animation.play("rwalking"); }
				if (facing == FlxObject.LEFT && velocity.x < 0) { animation.play("rwalking"); }
				if (facing == FlxObject.RIGHT && velocity.x < 0) { animation.play("ri_walking"); }
				if (facing == FlxObject.LEFT && velocity.x > 0) { animation.play("ri_walking"); }
				else if (velocity.x == 0) { animation.play("ridle"); }
			}
			
			else
			{
				animation.play("ridle");
			}
		}
	}
	
	private function setFollow():Void
	{
		header.y = y - header.height - 4;
		header.x = x - (header.width - width) / 2;
		
		gun.x = x;
		gun.y = y + 2;
		
		gun2.x = x;
		gun2.y = y + 2;
	}
	
	public function s_serialize():String
	{
		_arr.splice(0, _arr.length);
		
		_arr.push(ID);
		_arr.push(x);
		_arr.push(y);
		_arr.push(a);
		_arr.push(isRight);
		_arr.push(shoot);
		
		return Serializer.run(_arr);
	}
	
	public function c_unserialize(Arr:Array<Dynamic>):Void
	{
		_arr = Arr;
		
		x = _arr[1];
		y = _arr[2];
		
		velocity.x = (_arr[1] - x) * 0.75 + velocity.x * 0.25;
		velocity.y = (_arr[2] - y) * 0.75 + velocity.y * 0.25;
		
		a = _arr[3];
		isRight = _arr[4];
		shoot = Arr[5];
	}
	
	public function c_serialize():String
	{
		_arr.splice(0, _arr.length);
		
		_arr.push(move_right);
		_arr.push(move_left);
		_arr.push(move_jump);
		_arr.push(a);
		_arr.push(isRight);
		_arr.push(shoot);
		
		return Serializer.run(_arr);
	}
	
	public function s_unserialize(S:String):Void
	{
		_arr.splice(0, _arr.length);
		
		_arr = Unserializer.run(S);
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
			trace("jumping");
			if (isTouching(FlxObject.ANY))
			{
				trace("jumping for real");
				velocity.y = -280;
			}
			
			else
			{
				trace("not jumping");
				move_jump = false;
			}
		}
		
		if (shoot) //shoot
		{
			fire();
		}
	}
}