package entities;
import flixel.util.FlxTimer;
import plugins.BasePlugin;

/**
 * ...
 * @author ...
 */
class Trigger
{
	public var parent:Dynamic;
	public var ready:Bool = true;
	public var cooldown:Int;
	
	public function new(Parent:Dynamic, Cooldown:Int)
	{
		parent = Parent;
		
		var parsed:Int = Std.parseInt(parent);
		if (Std.parseInt(parent) != null)
			parent = parsed;
		
		cooldown = Cooldown;
	}
	
	public function toggle():Void
	{
		if (Std.is(parent, String))
		{
			var plugin:BasePlugin = cast Reg.plugins.get(cast parent);
			plugin.working = !plugin.working;
		}
		else
		{
			var entity:Dynamic = OgmoLoader.entities.get(parent);
			
			var entWorking:Bool = Reflect.getProperty(entity, "working");
			Reflect.setProperty(entity, "working", !entWorking);
		}
		
		ready = false;
		new FlxTimer(cooldown, function(T:FlxTimer) { ready = true; } );
	}
	
	public function activate():Void
	{
		if (Std.is(parent, String))
		{
			var plugin:BasePlugin = cast Reg.plugins.get(cast parent);
			plugin.activate();
		}
		else
		{
			var entity:Dynamic = OgmoLoader.entities.get(parent);
			
			Reflect.setProperty(entity, "working", true);
		}
		
		ready = false;
		new FlxTimer(cooldown, function(T:FlxTimer) { ready = true; } );
	}
}