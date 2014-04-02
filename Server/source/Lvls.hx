package ;
import flash.utils.ByteArray;

/**
 * ...
 * @author Ohmnivore
 */

@:file("assets/maps/Test.oel") class Test extends ByteArray { }

class Lvls
{
	static public function loadLVL(Name:String):String
	{
		var lvl:Dynamic = Type.createInstance(Type.resolveClass(Name), []);
		var clvl:ByteArray = cast(lvl, ByteArray);
		return clvl.toString();
	}
}