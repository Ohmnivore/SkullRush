package gevents;

import flixel.util.FlxPoint;
import networkobj.NWeapon;

class HurtInfo
{
	public var attacker:Int;
	public var victim:Int;
	public var dmg:Int;
	public var dmgsource:FlxPoint;
	public var weapon:NWeapon;
	public var type:Int = 0;
	
	public function new()
	{
		
	}
}