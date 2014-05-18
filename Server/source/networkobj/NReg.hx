package networkobj;
import haxe.Serializer;
import flixel.FlxSprite;
import networkobj.NEmitter;

/**
 * ...
 * @author Ohmnivore
 */
class NReg
{
	static private var _ID:Int = 0;
	static private var _templates:Map<Int, NTemplate>;
	static public var sprites:Map<Int, NSprite>;
	static public var huds:Array<NHUD>;
	static public var timers:Array<NTimer>;
	
	static public function init():Void
	{
		_templates = new Map<Int, NTemplate>();
		sprites = new Map<Int, NSprite>();
		huds = new Array<NHUD>();
		timers = new Array<NTimer>();
	}
	
	static public function getID():Int 
	{
		_ID++;
		return _ID;
	}
	
	static public function resetReg():Void
	{
		_templates = new Map<Int, NTemplate>();
		//for (s in sprites.iterator())
		//{
			//s.delete();
		//}
		//sprites = new Map<Int, NSprite>();
		for (h in huds)
		{
			h.delete();
		}
		huds = [];
		for (t in timers)
		{
			t.delete();
		}
		timers = [];
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