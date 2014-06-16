package ;
import enet.ENet;
import flixel.FlxG;
import flixel.util.FlxTimer;
import gevents.ConfigEvent;
import networkobj.NReg;
import networkobj.NTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Admin
{
	static public var oldTimerStatus:Map<Int, Int>;
	
	static public function hookCommands():Void
	{
		oldTimerStatus = new Map<Int, Int>();
		
		FlxG.console.registerFunction("nextmap", nextMap);
		FlxG.console.registerFunction("reloadmap", reloadMap);
		FlxG.console.registerFunction("reloadconfig", reloadConfig);
		FlxG.console.registerFunction("getversion", getVersion);
		FlxG.console.registerFunction("localip", getIP);
		FlxG.console.registerFunction("portforward", portForward);
		FlxG.console.registerFunction("portremove", portRemove);
		FlxG.console.registerFunction("curmap", curMap);
		FlxG.console.registerFunction("stopTimers", stopTimers);
		FlxG.console.registerFunction("startTimers", startTimers);
		
		FlxG.console.addCommand(["setmap"], setMap, "Set map, ex: setmap Test", "", 1, -1);
	}
	
	static public function stopTimers():Void
	{
		for (t in NReg.timers.iterator())
		{
			oldTimerStatus.set(t.ID, t.status);
			t.setTimer(Std.int(t.count), NTimer.STOPPED);
			
			trace("Stopped timer with base: " + t.base);
		}
	}
	
	static public function startTimers():Void
	{
		for (t in NReg.timers.iterator())
		{
			if (oldTimerStatus.exists(t.ID))
			{
				t.setTimer(Std.int(t.count), oldTimerStatus.get(t.ID));
				oldTimerStatus.remove(t.ID);
				
				trace("Started timer with base: " + t.base);
			}
		}
	}
	
	static public function curMap():Void
	{
		trace("Current map is: " + Reg.state.current_map);
	}
	
	static public function portRemove():Void
	{
		PortForward.portRemove(Reg.server.port, true);
	}
	
	static public function portForward():Void
	{
		PortForward.portForward(Reg.server.port, true);
	}
	
	static public function getIP():Void
	{
		trace("Local IP: " + ENet.getLocalIP());
	}
	
	static public function getVersion():Void
	{
		trace("Version: " + Assets.config.get("version"));
	}
	
	static public function nextMap():Void
	{
		Reg.map_index++;
		
		if (Reg.map_index >= Reg.maps.length)
			Reg.map_index = 0;
		
		Reg.mapname = Reg.maps[Reg.map_index];
		
		oldTimerStatus = new Map<Int, Int>();
		FlxTimer.manager.clear();
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
		
		oldTimerStatus = new Map<Int, Int>();
		FlxTimer.manager.clear();
		Reg.reLaunch();
	}
	
	public static function reloadMap():Void
	{
		oldTimerStatus = new Map<Int, Int>();
		FlxTimer.manager.clear();
		Reg.reLaunch();
	}
	
	public static function reloadConfig():Void
	{
		Assets.loadConfig();
		
		Reg.gm.dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		
		trace("Loaded configs.");
	}
	
}