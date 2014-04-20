package networkobj;
import haxe.Serializer;

/**
 * ...
 * @author Ohmnivore
 */
class NReg
{
	static private var _ID:Int = 0;
	static private var _templates:Map<Int, NTemplate>;
	static public var sprites:Array<NSprite>;
	static public var huds:Array<NHUD>;
	static public var timers:Array<NTimer>;
	
	static public function init():Void
	{
		_templates = new Map<Int, NTemplate>();
		sprites = new Array<NSprite>();
		huds = new Array<NHUD>();
		timers = new Array<NTimer>();
	}
	
	static public function getID():Int 
	{
		return _ID;
		_ID++;
	}
	
	static public function registerTemplate(T:NTemplate):Void
	{
		T.ID = getID();
		
		_templates.set(T.ID, T);
	}
	
	static public function exportTemplates():String
	{
		return Serializer.run(_templates);
	}
}