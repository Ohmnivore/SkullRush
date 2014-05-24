package networkobj;

import flixel.addons.weapon.FlxBullet;
import flixel.FlxG;
import flixel.util.FlxRect;
import FlxWeaponExt;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import enet.ENet;
import haxe.Serializer;

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
	
	public var EMITTER:Int;
	public var TRAIL_EMITTER:Int;
	public var TRAIL_EMITTER_GRAPHIC:String;
	
	public function new()
	{
		
	}
	
	static public function grantWeapon(P:Int, Slots:Array<Int>):Void
	{
		var p:Player = Reg.server.playermap.get(P);
		for (Slot in Slots)
		{
			p.grantedWeps.set(NWeapon.getWeapon(Slot).slot, true);
		}
		
		Msg.GrantGun.data.set("slot", Serializer.run(p.grantedWeps));
		Reg.server.sendMsg(P, Msg.GrantGun.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	static public function setUpWeapons(P:PlayerBase):Void
	{
		for (wep in NWeapon.weapons)
		{
			var w:NWeapon = wep;
			
			var fw:FlxWeaponExt = w.makeWeapon(P);
			fw.template = w;
			Reg.state.bullets.add(fw.group);
			fw.gun = new FlxSprite(0, 0, Assets.images.get(w.gunGraphic));
			fw.gun.loadGraphic(Assets.getImg(w.gunGraphic));
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
	
	public function collide(Bullet:FlxBullet, Other:Dynamic):Void
	{
		
	}
	
	public function fire(Parent:FlxSprite, LaunchX:Float, LaunchY:Float, Angle:Int, BulletSpeed:Int):Void
	{
		
	}
	
	public function kill(Parent:FlxSprite, Bullet:FlxBullet):Void
	{
		
	}
	
	public function makeWeapon(Parent:FlxSprite):FlxWeaponExt
	{
		var w:FlxWeaponExt = new FlxWeaponExt(name, Parent, FlxBulletExt);
		
		w.setBulletElasticity(bulletElasticity);
		w.setBulletLifeSpan(bulletLifeSpan);
		w.setBulletSpeed(bulletSpeed);
		w.setFireRate(fireRate);
		w.name = name;
		w.shotsToFire = shotsToFire;
		w.spread = spread;
		
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
		//w.setBulletAcceleration(50, 50, 300, 300);
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
		//w.setBulletLifeSpan(1.5);
		return w;
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
	
	static public function announceWeapons(player:Int = 0):Void
	{
		var map:Map<Int, Dynamic> = new Map<Int, Dynamic>();
		//trace(array);
		for (slot in NWeapon.weapons.keys())
		{
			//trace("trace");
			var arr:Array<Dynamic> = [];
			var w:NWeapon = cast NWeapon.weapons.get(slot);
			//trace("Wep:", w);
			
			arr.push(w.bulletElasticity);
			arr.push(w.bulletLifeSpan);
			arr.push(w.bulletSpeed);
			arr.push(w.fireRate);
			arr.push(w.name);
			arr.push(w.bulletGraphic);
			arr.push(w.gunGraphic);
			arr.push(w.gunIcon);
			arr.push(w.bulletAcceleration);
			arr.push(w.bulletMaxSpeed);
			arr.push(w.bulletGravity);
			arr.push(w.bulletOffset);
			arr.push(w.bulletInheritance);
			arr.push(w.EMITTER);
			arr.push(w.TRAIL_EMITTER);
			arr.push(w.TRAIL_EMITTER_GRAPHIC);
			arr.push(w.shotsToFire);
			arr.push(w.spread);
			arr.push(w.ignoreCollisions);
			
			map.set(slot, arr);
		}
		//trace(array);
		Msg.AnnounceGuns.data.set("serialized", Serializer.run(map));
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.AnnounceGuns.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.AnnounceGuns.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
}