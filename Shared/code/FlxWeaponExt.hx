package ;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxVelocity;

/**
 * ...
 * @author Ohmnivore
 */
class FlxWeaponExt extends FlxWeapon
{
	private var _inheritance:FlxPoint;
	
	public function new(Name:String, ?ParentRef:FlxSprite, ?BulletType:Class<FlxBullet>, ?BulletID:Int = 0) 
	{
		super(Name, ParentRef, BulletType, BulletID);
		
		_inheritance = new FlxPoint(0, 0);
	}
	
	public function setBulletInheritance(X:Float, Y:Float):Void
	{
		_inheritance.x = X;
		_inheritance.y = Y;
	}
	
	override private function runFire(Method:Int, X:Int = 0, Y:Int = 0, ?Target:FlxSprite, Angle:Int = 0):Bool 
	{
		if (fireRate > 0 && FlxG.game.ticks < nextFire)
		{
			return false;
		}
		
		currentBullet = getFreeBullet();
		
		if (currentBullet == null)
		{
			return false;
		}
		
		if (onPreFireCallback != null)
		{
			onPreFireCallback();
		}
		
		#if !FLX_NO_SOUND_SYSTEM
		if (onPreFireSound != null)
		{
			onPreFireSound.play();
		}
		#end

		// Clear any velocity that may have been previously set from the pool
		currentBullet.velocity.x = 0;
		currentBullet.velocity.y = 0;
		
		_lastFired = FlxG.game.ticks;
		nextFire = FlxG.game.ticks + Std.int(fireRate / FlxG.timeScale);
		
		var launchX:Float = _positionOffset.x;
		var launchY:Float = _positionOffset.y;
		
		if (_fireFromParent)
		{
			launchX += parent.x;
			launchY += parent.y;
		}
		else if (_fireFromPosition)
		{
			launchX += _fireX;
			launchY += _fireY;
		}
		
		if (_directionFromParent)
		{
			_velocity = FlxVelocity.velocityFromFacing(parent, bulletSpeed);
		}
		
		// Faster (less CPU) to use this small if-else ladder than a switch statement
		if (Method == FlxWeapon.FIRE)
		{
			currentBullet.fire(launchX, launchY, _velocity.x, _velocity.y);
		}
		else if (Method == FlxWeapon.FIRE_AT_POSITION)
		{
			currentBullet.fireAtPosition(launchX, launchY, X, Y, bulletSpeed);
		}
		else if (Method == FlxWeapon.FIRE_AT_TARGET)
		{
			currentBullet.fireAtTarget(launchX, launchY, Target, bulletSpeed);
		}
		else if (Method == FlxWeapon.FIRE_FROM_ANGLE)
		{
			currentBullet.fireFromAngle(launchX, launchY, Angle, bulletSpeed);
		}
		else if (Method == FlxWeapon.FIRE_FROM_PARENT_ANGLE)
		{
			currentBullet.fireFromAngle(launchX, launchY, Math.floor(parent.angle), bulletSpeed);
		}
		#if !FLX_NO_TOUCH
		else if (Method == FlxWeapon.FIRE_AT_TOUCH)
		{
			if (_touchTarget != null)
			currentBullet.fireAtTouch(launchX, launchY, _touchTarget, bulletSpeed);
		}
		#end
		#if !FLX_NO_MOUSE
		else if (Method == FlxWeapon.FIRE_AT_MOUSE)
		{
			currentBullet.fireAtMouse(launchX, launchY, bulletSpeed);
		}
		#end
		if (onPostFireCallback != null)
		{
			onPostFireCallback();
		}
		
		#if !FLX_NO_SOUND_SYSTEM
		if (onPostFireSound != null)
		{
			onPostFireSound.play();
		}
		#end
		
		_bulletsFired++;
		
		//Set projectile speed inheritance
		currentBullet.velocity.x += parent.velocity.x * _inheritance.x;
		currentBullet.velocity.y += parent.velocity.y * _inheritance.x;
		
		return true;
	}
}