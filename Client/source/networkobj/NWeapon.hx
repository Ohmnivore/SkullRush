package networkobj;

import flixel.util.FlxPoint;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxG;
import flixel.util.FlxRect;
import ext.FlxWeaponExt;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Ohmnivore
 */

class NWeapon
{
	//static public var weapons:Array<NWeapon>;
	static public var weapons:Map<Int, NWeapon>;
	
	public var slot:Int;
	public var bulletElasticity:Float = 0;
	public var bulletLifeSpan:Float = 0;
	public var bulletSpeed:Int = 100;
	public var fireRate:Int = 1000;
	public var name:String = "gun";
	public var verb:String = "exploded";
	public var bulletGraphic:String = "assets/images/explosionparticle.png";
	public var gunGraphic:String = "assets/images/gun.png";
	public var gunIcon:String = "assets/images/gun.png";
	public var bulletAcceleration:FlxPoint;
	public var bulletMaxSpeed:FlxPoint;
	public var bulletGravity:FlxPoint;
	public var bulletOffset:FlxPoint;
	public var bulletInheritance:FlxPoint;
	public var shotsToFire:Int = 1;
	public var spread:Int = 0;
	public var ignoreCollisions:Bool = false;
	
	public var TRAIL_EMITTER:Int;
	public var TRAIL_EMITTER_GRAPHIC:String;
	
	public function new(Arr:Array<Dynamic>) 
	{
		bulletElasticity = Arr[0];
		bulletLifeSpan = Arr[1];
		bulletSpeed = Arr[2];
		fireRate = Std.int(Arr[3] / 2);
		//trace(fireRate);
		name = Arr[4];
		bulletGraphic = Arr[5];
		gunGraphic = Arr[6];
		gunIcon = Arr[7];
		bulletAcceleration = Arr[8];
		bulletMaxSpeed = Arr[9];
		bulletGravity = Arr[10];
		bulletOffset = Arr[11];
		bulletInheritance = Arr[12];
		
		TRAIL_EMITTER = Arr[14];
		TRAIL_EMITTER_GRAPHIC = Arr[15];
		
		shotsToFire = Arr[16];
		spread = Arr[17];
		
		ignoreCollisions = Arr[18];
	}
	
	static public function setUpWeapons(P:PlayerBase):Void
	{
		for (wep in NWeapon.weapons)
		{
			var w:NWeapon = wep;
			
			var fw:FlxWeaponExt = w.makeWeapon(P);
			fw.template = w;
			//fw.makeImageBullet(4, Assets.images.get(w.bulletGraphic),
				//Std.int(w.bulletOffset.x), Std.int(w.bulletOffset.y), false, 180);
			Reg.state.bullets.add(fw.group);
			fw.gun = new FlxSprite(0, 0, Assets.images.get(w.gunGraphic));
			fw.gun.loadGraphic(Assets.getImg(w.gunGraphic));
			//fw.gun.loadRotatedGraphic(Assets.getImg(w.gunGraphic), 180, -1, false, false);
			fw.gun.visible = false;
			P.guns.add(fw.gun);
			P.guns_arr.push(fw);
			
			if (w.slot == 1)
				P.grantedWeps.set(w.slot, true);
			else
				P.grantedWeps.set(w.slot, false);
			
			var bounds:FlxRect = Reg.state.collidemap.getBounds();
			bounds.x -= FlxG.width / 2;
			bounds.width += FlxG.width;
			bounds.y -= FlxG.height / 2;
			bounds.height += FlxG.height;
			fw.setBulletBounds(bounds);
		}
	}
	
	public function makeWeapon(Parent:FlxSprite):FlxWeaponExt
	{
		var w:FlxWeaponExt = new FlxWeaponExt(name, Parent, FlxBulletExt);
		
		w.setBulletElasticity(bulletElasticity);
		w.setBulletLifeSpan(bulletLifeSpan);
		w.setBulletSpeed(bulletSpeed);
		w.name = name;
		w.shotsToFire = shotsToFire;
		w.spread = spread;
		w.setFireRate(fireRate);
		
		w.makeImageBullet(10, Assets.images.get(bulletGraphic),
				Std.int(bulletOffset.x), Std.int(bulletOffset.y), false, 180);
		
		if (bulletAcceleration != null)
		{
			if (bulletMaxSpeed != null)
			{
				w.setBulletAcceleration(Std.int(bulletAcceleration.x), Std.int(bulletAcceleration.y),
					Std.int(bulletMaxSpeed.x), Std.int(bulletMaxSpeed.y));
			}
		}
		
		if (bulletGravity != null)
		{
			w.setBulletGravity(Std.int(bulletGravity.x), Std.int(bulletGravity.y));
		}
		
		if (bulletOffset != null)
		{
			w.setBulletOffset(bulletOffset.x, bulletOffset.y);
		}
		
		if (bulletInheritance != null)
		{
			w.setBulletInheritance(bulletInheritance.x, bulletInheritance.y);
		}
		
		return w;
	}
	
	public function collide(Bullet:FlxBullet, Other:Dynamic):Void
	{
		
	}
	
	public function fire(Parent:FlxSprite, LaunchX:Float, LaunchY:Float, Angle:Int, BulletSpeed:Int):Void
	{
		
	}
	
	public function kill(Parent:FlxSprite, Bullet:FlxBullet):Void
	{
		
	}
	
	static public function init():Void
	{
		NWeapon.weapons = new Map<Int, NWeapon>();
	}
	
	static public function addWeapon(W:NWeapon, Slot:Int):Void
	{
		var s:Int = Slot - 1;
		NWeapon.weapons.set(s, W);
		W.slot = Slot;
		
		Reg.state.wepHUD.addIcon(Slot, W.gunIcon);
	}
	
	static public function deleteWeapon(Slot:Int):Void
	{
		var s:Int = Slot - 1;
		NWeapon.weapons.remove(s);
	}
	
	static public function getWeapon(Slot:Int):NWeapon
	{
		var s:Int = Slot - 1;
		return NWeapon.weapons.get(s);
	}
}