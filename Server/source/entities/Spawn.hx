package entities;
import flixel.util.FlxRandom;
import haxe.xml.Fast;

/**
 * ...
 * @author Ohmnivore
 */
class Spawn
{
	public var data:Fast;
	public var x:Int;
	public var y:Int;
	public var teams:Array<Bool>;
	
	public function new(Data:Fast) 
	{
		data = Data;
		
		x = Std.parseInt(data.att.x);
		y = Std.parseInt(data.att.y);
		
		teams = [];
		var teamtext:String = data.att.Teams;
		
		var t:Int = 0;
		while (t < teamtext.length)
		{
			if (teamtext.charAt(t) == "1")
			{
				teams.push(true);
			}
			
			else
			{
				teams.push(false);
			}
			
			t++;
		}
		
		Reg.state.spawns.push(this);
	}
	
	static public function makeFromXML(D:Fast):Spawn
	{
		return new Spawn(D);
	}
	
	static public function findSpawn(Team:Int):Spawn
	{
		while (true)
		{
			var s:Spawn = FlxRandom.getObject(Reg.state.spawns);
			
			if (s != null)
			{
				if (s.teams[Team])
					return s;
			}
		}
	}
	
	static public function init():Void
	{
		
	}
}