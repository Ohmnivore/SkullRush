package ;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import ext.FlxWeaponExt;
import flixel.util.FlxTimer;
import haxe.Serializer;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends PlayerBase
{
	public function new(Id:Int, Name:String, X:Int, Y:Int)
	{
		super(Id, Name, X, Y);
		trace("newplayer");
		setGun(1);
		
		acceleration.y = PlayerBase.gravity;
	}
	
	override public function fire():Void 
	{
		super.fire();
		
		if (ID == Reg.state.player.ID)
		{
			var reload:FlxTimer = new FlxTimer(last_shot.mock_fireRate / 1000);
			Reg.state.wepBar.setRange(0, 1);
			Reg.state.wepBar.setParent(reload, "progress", false);
		}
	}
	
	override public function setGun(GunID:Int, Force:Bool = false):Void
	{
		if (Std.is(GunID, Int))
		{
			var g:FlxWeaponExt = guns_arr[GunID - 1];
			if (g != null)
			{
				if (gun != null)
					gun.visible = false;
				g.gun.visible = true;
				gun = g.gun;
				cannon = g;
				
				current_weap = GunID;
				
				Reg.state.wepHUD.selectIcon(current_weap);
				
				gun.x = x + width/2 - gun.width / 2;
				gun.y = y + height/2 - gun.height / 2 + 2;
			}
		}
	}
	
	override public function draw():Void
	{
		super.draw();
		
		//FlxG.camera.scroll.x -= Reg.state.player.gun_offset.x * 2;
		//FlxG.camera.scroll.y -= Reg.state.player.gun_offset.y * 2;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (health <= 0)
		{
			alive = false;
			
			if (visible)
			{
				hide();
				
				if (ID == Reg.state.player.ID)
				{
					FlxG.camera.flash();
				}
			}
		}
		
		else
		{
			if (!alive)
			{
				show();
				
				alive = true;
				
				FlxSpriteUtil.fadeIn(this, 3, true);
				FlxSpriteUtil.fadeIn(gun, 3, true);
			}
		}
	}
	
	override public function c_unserialize(Arr:Array<Dynamic>):Void 
	{
		_arr = Arr;
		
		if (_arr.length == 14) //used to be 7
		{
			//velocity.x = ((_arr[1] - x) * 0.3 + _arr[7] * 0.5 + velocity.x * 0.2);
			//velocity.y = ((_arr[2] - y) * 0.3 + _arr[8] * 0.4 + velocity.y * 0.3);
			
			velocity.x = lerp(velocity.x, _arr[7], 0.4);
			velocity.y = lerp(velocity.y, _arr[8], 0.4);
			
			x = lerp(x, _arr[1], 0.8);
			y = lerp(y, _arr[2], 0.8);
			
			//x = _arr[1];
			//y = _arr[2];
			
			a = _arr[3];
			isRight = _arr[4];
			shoot = _arr[5];
			
			if (_arr[6] < health)
			{
				FlxSpriteUtil.flicker(this);
				FlxSpriteUtil.flicker(gun);
				
				if (ID == Reg.state.player.ID)
				{
					FlxG.camera.shake();
				}
			}
			
			health = _arr[6];
			dash_left = _arr[9];
			dash_right = _arr[10];
			//if (current_weap != _arr[11])
			//{
				setGun(_arr[11], true);
			//}
			
			var ind:Int = _arr[13];
			
			//if (guns_arr)
			//{
				var shot_gun:FlxWeaponExt = guns_arr[ind];
				if (shot_gun != null)
				{
					var diff:Int = Std.int(_arr[12] / 2);
					diff -= Std.int(shot_gun.fireRate / 2);
					if (diff > 0)
					{
						if (!(shot_gun.fireRate > 0 && FlxG.game.ticks < shot_gun.nextFire))
						{
							fire();
						}
						else
						{
							shoot = false;
						}
					}
				}
			//}
		}
	}
	
	override public function c_serialize():String 
	{
		_arr.splice(0, _arr.length);
		
		_arr.push(move_right);
		_arr.push(move_left);
		_arr.push(move_jump);
		_arr.push(a);
		_arr.push(isRight);
		_arr.push(shoot);
		_arr.push(dash_left);
		_arr.push(dash_right);
		_arr.push(dash_down);
		_arr.push(current_weap);
		
		return Serializer.run(_arr);
	}
}