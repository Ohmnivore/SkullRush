package weapons;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import gamemodes.BaseGamemode;
import gevents.HurtEvent;
import gevents.HurtInfo;
import networkobj.NEmitter;
import networkobj.NWeapon;

/**
 * ...
 * @author Ohmnivore
 */
class Splasher extends NWeapon
{
	public function new() 
	{
		super();
		
		name = "splasher";
		verb = "splashed";
		bulletSpeed = 255;
		fireRate = 1200;
		bulletOffset = new FlxPoint(12, 12);
		bulletInheritance = new FlxPoint(0.5, 0.5);
		gunGraphic = "assets/images/gun_splasher.png";
		gunIcon = "assets/images/gun_splasher.png";
		bulletGraphic = "assets/images/gun_splasher_bullet.png";
		
		var emit:FlxEmitterExt = new FlxEmitterExt();
		emit.setRotation(0, 0);
		emit.setMotion(0, 17, 0.9, 360, 25, 0);
		emit.setAlpha(1, 1, 0, 0);
		emit.setColor(0xff0000ff, 0xff000099);
		emit.setXSpeed(150, 150);
		emit.setYSpeed(150, 150);
		emit.bounce = 0.5;
		
		EMITTER = NEmitter.registerEmitter(emit);
	}
	
	override public function collide(Bullet:FlxBullet, Other:Dynamic):Void 
	{
		super.collide(Bullet, Other);
		
		NEmitter.playEmitter(EMITTER, true, Std.int(Bullet.x + Bullet.width / 2),
			Std.int(Bullet.y + Bullet.height / 2), "assets/images/explosionparticle.png", 0, 0, true, 35);
		
		for (p in Reg.state.players.members)
		{
			var pl:Player = cast (p, Player);
			
			var v:FlxVector = new FlxVector(1, 0);
			
			v.rotateByRadians(FlxAngle.angleBetween(Bullet, pl));
			
			//if (Reg.state.collidemap.ray(Bullet.getMidpoint(), pl.getMidpoint()))
			//{
				var dist_coeff:Float = (100 - FlxMath.distanceBetween(pl, Bullet)) / 100;
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
					info.type = BaseGamemode.BULLET;
					
					Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
				}
				
				else
				{
					pl.canChoose = true;
				}
			//}
		}
		
		Bullet.kill();
	}
}