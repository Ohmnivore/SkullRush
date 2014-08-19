package ;

import gamemodes.BOX;
import gamemodes.CTF;
import gamemodes.FFA;
import gamemodes.KOTH;

import plugins.SysMeteor;
import plugins.SysGravity;
import plugins.Welcomer;

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
		KOTH;
		BOX;
		
		//Write plugins here so that their reference is picked up by the compiler.
		//Otherwise plugins won't be compiled.
		SysMeteor;
		SysGravity;
		Welcomer;
		
		return File.getContent("assets/maps/" + Name + ".oel");
	}
}