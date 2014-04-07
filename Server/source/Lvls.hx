package ;
import flash.utils.ByteArray;
import sys.io.File;

/**
 * ...
 * @author Ohmnivore
 */

@:file("assets/maps/Test.oel") class Test extends ByteArray { }

class Lvls
{
	static public function loadLVL(Name:String):String
	{
		return File.getContent("assets/maps/" + Name + ".oel");
	}
}