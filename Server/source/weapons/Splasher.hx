package weapons;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import gamemodes.BaseGamemode;
import gevents.HurtEvent;
import gevents.HurtInfo;
import networkobj.NEmitter;
import networkobj.NWeapon;
import ext.FlxEmitterAuto;

/**
 * ...
 * @author Ohmnivore
 */
class Splasher extends NWeapon
{
	public var toTroll:Array<Player>;
	public var counter:Map<Int, Int>;
	
	public function new() 
	{
		super();
		
		name = "Splasher";
		verb = "splashed";
		bulletSpeed = 195;
		bulletLifeSpan = 1.4;
		fireRate = 1200;
		bulletOffset = new FlxPoint(12, 12);
		bulletInheritance = new FlxPoint(0.5, 0.5);
		gunGraphic = "assets/images/gun_splasher.png";
		gunIcon = "assets/images/gun_splasher.png";
		bulletGraphic = "assets/images/gun_splasher_bullet.png";
		bulletGravity = new FlxPoint(0, 300);
		ignoreCollisions = true;
		
		var emit:FlxEmitterAuto = new FlxEmitterAuto(Reg.state.emitters);
		emit.setRotation(0, 0);
		emit.setMotion(0, 45, 0.3, 360, 55, 0.1);
		emit.setAlpha(1, 1, 0.4, 0.4);
		emit.setColor(0xff004C9E, 0xff004C99);
		emit.setXSpeed(250, 500);
		emit.setYSpeed(250, 500);
		emit.bounce = 0.5;
		emit.frequency = 0.01;
		
		EMITTER = NEmitter.registerEmitter(emit);
		
		var t_emit:FlxEmitterAuto = new FlxEmitterAuto(Reg.state.emitters);
		t_emit.setRotation(0, 0);
		t_emit.setMotion(0, 17, 0.9, 360, 25, 0);
		t_emit.setAlpha(1, 1, 0, 0);
		t_emit.setColor(0xff09C0D9, 0xffB3F6FF);
		t_emit.setXSpeed(150, 150);
		t_emit.setYSpeed(150, 150);
		t_emit.bounce = 0.5;
		
		TRAIL_EMITTER = NEmitter.registerEmitter(t_emit);
		TRAIL_EMITTER_GRAPHIC = "assets/images/explosionparticle.png";
		
		toTroll = [];
		counter = new Map<Int, Int>();
	}
	
	function troll(T:FlxTimer):Void
	{
		for (player in toTroll)
		{
			player.velocity.x /= 2;
			player.velocity.y /= 2;
			
			counter.set(player.ID, counter.get(player.ID) + 1);
			
			if (counter.get(player.ID) >= 20)
			{
				toTroll.remove(player);
				counter.remove(player.ID);
			}
		}
	}
	
	override public function kill(Parent:FlxSprite, Bullet:FlxBullet):Void 
	{
		NEmitter.playEmitter(EMITTER, true, Std.int(Bullet.x + Bullet.width / 2),
			Std.int(Bullet.y + Bullet.height / 2), "assets/images/explosionparticle.png", 0, 0, false, 200);
		
		for (p in Reg.state.players.members)
		{
			var pl:Player = cast (p, Player);
			
			var v:FlxVector = new FlxVector(1, 0);
			
			v.rotateByRadians(FlxAngle.angleBetween(Bullet, pl));
			
			var dist:Float = FlxMath.distanceBetween(pl, Bullet);
			var dist_coeff:Float = (100 - dist) / 100;
			if (dist_coeff < 0) dist_coeff = 0;
			
			pl.velocity.x += v.x * 300 * dist_coeff;
			pl.velocity.y += v.y * 300 * dist_coeff;
			
			if (pl.ID != Reflect.field(Bullet._weapon.parent, "ID"))
			{
				var dmg:Float = dist_coeff * 75;
				
				var info:HurtInfo = new HurtInfo();
				info.attacker = Reflect.field(Bullet._weapon.parent, "ID");
				info.victim = pl.ID;
				info.dmg = Std.int(dmg);
				info.dmgsource = Bullet.getMidpoint();
				info.weapon = this;
				info.type = BaseGamemode.TYPE_BULLET;
				
				if (dist < 50 + (Bullet.width + pl.width) / 2)
				{
					toTroll.push(pl);
					counter.set(pl.ID, 0);
					new FlxTimer(0.1, troll, 20);
				}
				
				Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
			}
		}
		
		//Bullet.kill();
	}
	
	//override public function collide(Bullet:FlxBullet, Other:Dynamic):Void 
	//{
		//if (Other != Bullet._weapon.parent)
		//{
			//NEmitter.playEmitter(EMITTER, true, Std.int(Bullet.x + Bullet.width / 2),
				//Std.int(Bullet.y + Bullet.height / 2), "assets/images/explosionparticle.png", 0, 0, true, 50);
			//
			//for (p in Reg.state.players.members)
			//{
				//var pl:Player = cast (p, Player);
				//
				//var v:FlxVector = new FlxVector(1, 0);
				//
				//v.rotateByRadians(FlxAngle.angleBetween(Bullet, pl));
				//
				//var dist_coeff:Float = (100 - FlxMath.distanceBetween(pl, Bullet)) / 100;
				//if (dist_coeff < 0) dist_coeff = 0;
				//
				//pl.velocity.x += v.x * 300 * dist_coeff;
				//pl.velocity.y += v.y * 300 * dist_coeff;
				//
				//if (pl.ID != Reflect.field(Bullet._weapon.parent, "ID"))
				//{
					//var dmg:Float = dist_coeff * 75;
					//
					//var info:HurtInfo = new HurtInfo();
					//info.attacker = Reflect.field(Bullet._weapon.parent, "ID");
					//info.victim = pl.ID;
					//info.dmg = Std.int(dmg);
					//info.dmgsource = Bullet.getMidpoint();
					//info.weapon = this;
					//info.type = BaseGamemode.BULLET;
					//
					//Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
				//}
			//}
			//
			//Bullet.kill();
		//}
	//}
}