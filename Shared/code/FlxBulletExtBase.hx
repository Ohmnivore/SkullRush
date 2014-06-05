package ;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import networkobj.NReg;

#if CLIENT

#else
import networkobj.NEmitter;
#end

/**
 * ...
 * @author Ohmnivore
 */
class FlxBulletExtBase extends FlxBullet
{
	public var emitter:FlxEmitterAuto;
	
	public function new(Weapon:FlxWeapon, WeaponID:Int)
	{
		super(Weapon, WeaponID);
	}
	
	override public function update():Void 
	{
		super.update();
		
		var pos:FlxPoint = getMidpoint();
		
		emitter.x = pos.x;
		emitter.y = pos.y;
	}
	
	override public function kill():Void 
	{
		var wep_ext:FlxWeaponExt = cast _weapon;
		wep_ext.template.kill(_weapon.parent, this);
		
		super.kill();
		
		if (emitter != null)
		{
			emitter.on = false;
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		if (emitter != null)
		{
			emitter.on = false;
		}
	}
	
	override public function fireFromAngle(FromX:Float, FromY:Float, FireAngle:Int, Speed:Int):Void
	{
		x = FromX + FlxRandom.floatRanged( -_weapon.rndFactorPosition.x, _weapon.rndFactorPosition.x);
		y = FromY + FlxRandom.floatRanged( -_weapon.rndFactorPosition.y, _weapon.rndFactorPosition.y);
		
		var newVelocity:FlxPoint = FlxVelocity.velocityFromAngle(FireAngle + FlxRandom.intRanged( -_weapon.rndFactorAngle, _weapon.rndFactorAngle), Speed + FlxRandom.intRanged( -_weapon.rndFactorSpeed, _weapon.rndFactorSpeed));
		
		if (accelerates)
		{
			acceleration.x = newVelocity.x;
			acceleration.y = newVelocity.y;
			velocity.x = newVelocity.x;
			velocity.y = newVelocity.y;
		}
		else
		{
			velocity.x = newVelocity.x;
			velocity.y = newVelocity.y;
		}
		
		var ext_w:FlxWeaponExt = cast _weapon;
		fireEmitter(ext_w);
		
		postFire();
	}
	
	public function fireEmitter(W:FlxWeaponExt):Void
	{
		
	}
}