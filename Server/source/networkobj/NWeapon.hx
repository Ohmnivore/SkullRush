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
	static public var weapons:Array<NWeapon>;
	
	public var bulletElasticity:Float = 0;
	public var bulletLifeSpan:Float = 0;
	public var bulletSpeed:Int = 100;
	public var fireRate:Int = 1000;
	public var name:String = "gun";
	public var bulletGraphic:String = "assets/images/explosionparticle.png";
	public var gunGraphic:String = "assets/images/gun.png";
	public var gunIcon:String = "assets/images/gun.png";
	public var bulletAcceleration:FlxPoint;
	public var bulletMaxSpeed:FlxPoint;
	public var bulletGravity:FlxPoint;
	public var bulletOffset:FlxPoint;
	public var bulletInheritance:FlxPoint;
	
	public var EMITTER:Int;
	
	public function new()
	{
		addWeapon(this);
	}
	
	static public function setUpWeapons(P:PlayerBase):Void
	{
		for (wep in NWeapon.weapons)
		{
			var w:NWeapon = wep;
			
			var fw:FlxWeaponExt = w.makeWeapon(P);
			fw.template = w;
			fw.makeImageBullet(4, Assets.images.get(w.bulletGraphic),
				Std.int(w.bulletOffset.x), Std.int(w.bulletOffset.y), true, 180);
			Reg.state.bullets.add(fw.group);
			fw.gun = new FlxSprite(0, 0, Assets.images.get(w.gunGraphic));
			fw.gun.loadRotatedGraphic(Assets.getImg(w.gunGraphic), 180, -1, false, false);
			P.guns.add(fw.gun);
			P.guns_arr.push(fw);
			
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
	
	public function makeWeapon(Parent:FlxSprite):FlxWeaponExt
	{
		var w:FlxWeaponExt = new FlxWeaponExt(name, Parent);
		
		w.setBulletElasticity(bulletElasticity);
		w.setBulletLifeSpan(bulletLifeSpan);
		w.setBulletSpeed(bulletSpeed);
		w.setFireRate(fireRate);
		w.name = name;
		
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
	
	static public function init():Void
	{
		NWeapon.weapons = [];
		
	}
	
	static public function addWeapon(W:NWeapon):Void
	{
		NWeapon.weapons.push(W);
	}
	
	static public function deleteWeapon(W:NWeapon):Void
	{
		NWeapon.weapons.remove(W);
	}
	
	static public function getWeapon(ID:Int):NWeapon
	{
		return NWeapon.weapons[ID];
	}
	
	static public function announceWeapons(player:Int = 0):Void
	{
		var array:Array<Dynamic> = [];
		//trace(array);
		for (wep in NWeapon.weapons.iterator())
		{
			//trace("trace");
			var arr:Array<Dynamic> = [];
			var w:NWeapon = cast wep;
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
			
			array.push(arr);
		}
		trace(array);
		Msg.AnnounceGuns.data.set("serialized", Serializer.run(array));
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.AnnounceGuns.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.AnnounceGuns.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
}