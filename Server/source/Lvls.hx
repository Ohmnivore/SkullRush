package ;
import flash.utils.ByteArray;
import gamemodes.CTF;
import gamemodes.FFA;
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
		FFA;
		CTF;
		
		return File.getContent("assets/maps/" + Name + ".oel");
	}
}