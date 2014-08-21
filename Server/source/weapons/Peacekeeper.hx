package weapons;
import flash.media.ID3Info;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import gamemodes.BaseGamemode;
import gevents.HurtEvent;
import gevents.HurtInfo;
import networkobj.NEmitter;
import networkobj.NFlxEmitterAuto;
import networkobj.NWeapon;
import ext.FlxEmitterAuto;

/**
 * ...
 * @author Ohmnivore
 */
class Peacekeeper extends NWeapon
{
	public function new() 
	{
		super();
		
		name = "Peacekeeper";
		verb = "smashed";
		bulletSpeed = 400;
		bulletLifeSpan = 0.1;
		fireRate = 1600;
		bulletOffset = new FlxPoint(12, 12);
		bulletInheritance = new FlxPoint(0.1, 0.1);
		gunGraphic = "assets/images/gun_peacekeeper.png";
		gunIcon = "assets/images/gun_peacekeeper.png";
		bulletGraphic = "assets/images/gun_peacekeeper_bullet.png";
		bulletGravity = new FlxPoint(0, 0);
		
		var emit:NFlxEmitterAuto = new NFlxEmitterAuto(Reg.state.emitters);
		emit.setRotation(0, 0);
		emit.setMotion(0, 10, 0.6, 360, 5, 0.2);
		emit.setAlpha(1, 1, 0, 0);
		emit.setColor(0xffCC0000, 0xff170000);
		emit.setXSpeed(50, 50);
		emit.setYSpeed(50, 50);
		emit.bounce = 0.5;
		
		EMITTER = NEmitter.registerEmitter(emit);
		
		var t_emit:NFlxEmitterAuto = new NFlxEmitterAuto(Reg.state.emitters);
		t_emit.setRotation(0, 0);
		t_emit.setMotion(0, 5, 0.5, 360, 3, 0.1);
		t_emit.setAlpha(1, 1, 0, 0);
		t_emit.setColor(0xffCC0000, 0xff170000);
		t_emit.setXSpeed(50, 50);
		t_emit.setYSpeed(50, 50);
		t_emit.bounce = 0.5;
		
		TRAIL_EMITTER = NEmitter.registerEmitter(t_emit);
		TRAIL_EMITTER_GRAPHIC = "assets/images/explosionparticle.png";
	}
	
	override public function fire(Parent:FlxSprite, LaunchX:Float, LaunchY:Float, Angle:Int, BulletSpeed:Int):Void 
	{
		var vect:FlxVector = new FlxVector(1, 0);
		vect.rotateByDegrees(Angle);
		vect.x = -vect.x;
		vect.y = -vect.y;
		
		var player:Player = cast Parent;
		player.velocity.x = vect.x * 1000;
		player.velocity.y = vect.y * 800;
	}
	
	override public function collide(Bullet:FlxBullet, Other:Dynamic):Void 
	{
		if (Other != Bullet._weapon.parent)
		{
			super.collide(Bullet, Other);
			
			NEmitter.playEmitter(EMITTER, true, Std.int(Bullet.x + Bullet.width / 2),
				Std.int(Bullet.y + Bullet.height / 2), "assets/images/explosionparticle.png", 1, 0, true, 5);
			
			if (Std.is(Other, Player))
			{
				var pl:Player = cast Other;
				
				if (pl.ID != Reflect.field(Bullet._weapon.parent, "ID"))
				{
					var angle:Float = FlxAngle.getAngle(Bullet.getMidpoint(), pl.getMidpoint());
					var vect:FlxVector = new FlxVector(0, 1000);
					vect.rotateByRadians(angle);
					
					pl.velocity.x = vect.x;
					pl.velocity.y = vect.y;
				}
			}
			
			Bullet.kill();
		}
	}
}