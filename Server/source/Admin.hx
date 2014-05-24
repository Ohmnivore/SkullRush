package ;
import flixel.FlxG;
import gevents.ConfigEvent;
import networkobj.NReg;

/**
 * ...
 * @author Ohmnivore
 */
class Admin
{
	
	static public function hookCommands():Void
	{
		FlxG.console.registerFunction("nextmap", nextMap);
		FlxG.console.registerFunction("reloadmap", reloadMap);
		FlxG.console.registerFunction("reloadconfig", reloadConfig);
		FlxG.console.registerFunction("getversion", getVersion);
		
		FlxG.console.addCommand(["setmap"], setMap, "Set map, ex: setmap Test", "", 1, -1);
	}
	
	static public function getVersion():Void
	{
		FlxG.log.add("Version: " + Assets.config.get("version"));
	}
	
	static public function nextMap():Void
	{
		Reg.map_index++;
		
		if (Reg.map_index >= Reg.maps.length)
			Reg.map_index = 0;
		
		Reg.mapname = Reg.maps[Reg.map_index];
		
		Reg.reLaunch();
	}
	
	static public function setMap(Name:String):Void
	{
		var found:Bool = false;
		var i:Int = 0;
		for (m in Reg.maps)
		{
			if (m == Name)
			{
				found = true;
				break;
			}
			
			i++;
		}
		
		if (found)
		{
			trace('Map $Name was found in the map rotation. It will continue from there.');
			Reg.map_index = i;
			
			Reg.mapname = Reg.maps[Reg.map_index];
		}
		else
		{
			trace('Map $Name was not found in the map rotation. It will continue from where the rotation was interrupted.');
			Reg.mapname = Name;
		}
		
		Reg.reLaunch();
	}
	
	public static function reloadMap():Void
	{
		Reg.reLaunch();
	}
	
	public static function reloadConfig():Void
	{
		Assets.loadConfig();
		
		Reg.gm.dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		
		trace("Loaded configs.");
	}
	
}