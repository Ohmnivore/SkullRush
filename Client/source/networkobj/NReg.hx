package networkobj;

import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class NReg
{
	static public var HUDS:Map<Int, FlxText>;
	
	static public function init():Void
	{
		HUDS = new Map<Int, FlxText>();
	}
	
}