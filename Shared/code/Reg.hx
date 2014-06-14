package;

import enet.NetBase;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import networkobj.NReg;

#if SERVER
import gamemodes.BaseGamemode;
#end

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	#if CLIENT
	/**
	 * Static client reference
	 */
	static public var client:SkullClient;
	
	static public var pre_state:PreGame;
	
	static public var playermap:Map<Int, Player>;
	
	static public var playerID:Int;
	#end
	
	#if SERVER
	/**
	 * Static server reference
	 */
	static public var server:SkullServer;
	
	/**
	 * Current gamemode instance
	 */
	static public var gm:BaseGamemode;
	
	/**
	 * Current map rotation
	 */
	static public var maps:Array<String>;
	
	/**
	 * Current map index
	 */
	static public var map_index:Int = 0;
	
	/**
	 * Current map's name
	 */
	static public var mapname:String;
	
	/**
	 * Used for stopping threading
	 */
	static public var shutdown:Bool = false;
	
	static public function reLaunch():Void
	{
		if (FlxG.debugger.visible)
		{
			FlxG.debugger.visible = false;
		}
		
		NReg.resetReg();
		new FlxTimer(1, reLaunchWithTimer);
	}
	
	static private function reLaunchWithTimer(T:FlxTimer):Void
	{
		FlxG.switchState(new PlayState());
	}
	
	static public function parseMaps():Array<String>
	{
		var s:String = Assets.config.get("maps");
		
		var maps:Array<String> = s.split(",");
		
		var r:Array<String> = [];
		
		var x:Int = 0;
		for (m in maps)
		{
			m = StringTools.trim(m);
			if (m.charAt(m.length - 1) == ",")
			{
				m = m.substr(0, m.length - 1);
			}
			r.push(m);
			x++;
		}
		
		return r;
	}
	
	static public var should_render:Bool = false;
	#end
	
	/**
	 * Static host reference
	 */
	static public var host:NetBase;
	
	/**
	 * Chat box reference
	 */
	static public var chatbox:ChatBox;
	
	/**
	 * Announcer reference
	 */
	static public var announcer:Announcer;
	
	/**
	 * Current playstate
	 */
	static public var state:PlayState;
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
}