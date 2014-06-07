package ;

import gamemodes.CTF;
import gamemodes.FFA;
import sys.io.File;

/**
 * ...
 * @author Ohmnivore
 */

class Lvls
{
	static public function loadLVL(Name:String):String
	{
		//Write gamemodes here so that their reference is picked up by the compiler.
		//Otherwise gamemodes won't be compiled.
		FFA;
		CTF;
		
		return File.getContent("assets/maps/" + Name + ".oel");
	}
}