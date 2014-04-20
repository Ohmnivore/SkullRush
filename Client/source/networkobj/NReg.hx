package networkobj;

import flixel.text.FlxText;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class NReg
{
	static public var HUDS:Map<Int, FlxText>;
	static public var templates:Map<Int, NTemplate>;
	static public var sprites:Map<Int, FlxSprite>;
	
	static public function init():Void
	{
		HUDS = new Map<Int, FlxText>();
		templates = new Map<Int, NTemplate>();
		sprites = new Map<Int, FlxSprite>();
	}
	
}