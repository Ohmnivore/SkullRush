package networkobj;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;

/**
 * ...
 * @author Ohmnivore
 */
class NReg
{
	static public var HUDS:Map<Int, FlxText>;
	static public var templates:Map<Int, NTemplate>;
	static public var sprites:Map<Int, FlxSprite>;
	static public var emitters:Map<Int, FlxEmitter>;
	static public var live_emitters:Map<Int, FlxEmitter>;
	
	static public function init():Void
	{
		HUDS = new Map<Int, FlxText>();
		templates = new Map<Int, NTemplate>();
		sprites = new Map<Int, FlxSprite>();
		emitters = new Map<Int, FlxEmitter>();
		live_emitters = new Map<Int, FlxEmitter>();
	}
}