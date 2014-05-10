package networkobj;
import enet.ENet;
import flixel.FlxG;
import flixel.input.FlxAccelerometer;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class NScoreManager
{
	public var delta:Float = 0;
	public var scores:Array<NScoreboard>;
	
	public function new() 
	{
		scores = new Array<NScoreboard>();
	}
	
	public function update():Void
	{
		if (FlxG.keys.justPressed.TAB)
		{
			delta = 0;
			
			for (s in scores)
			{
				var sc:NScoreboard = cast s;
				sc.toggle();
			}
		}
		
		delta += FlxG.mouse.wheel * 10;
		
		if (delta > 0)
		{
			delta = 0;
		}
		
		var offset:Float = 0;
		for (s in scores)
		{
			var score:NScoreboard = s;
			score.group.y = delta + offset;
			offset += score.group.height; 
		}
	}
	
	public function addPlayerAll(P:Player):Void
	{
		for (s in scores)
		{
			var sc:NScoreboard = cast s;
			sc.addPlayer(P);
		}
	}
	
	public function removePlayerAll(P:Player):Void
	{
		for (s in scores)
		{
			var sc:NScoreboard = s;
			sc.removePlayer(P);
		}
	}
	
	public function sendAllToPlayer(P:Int):Void
	{
		for (s in scores)
		{
			var sc:NScoreboard = s;
			
			Msg.SetBoard.data.set("id", sc.ID);
			Msg.SetBoard.data.set("serialized", sc.getData());
			
			Reg.server.sendMsg(P, Msg.SetBoard.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function addBoard(S:NScoreboard):Void
	{
		scores.push(S);
	}
	
	public function removeBoard(S:NScoreboard):Void
	{
		scores.remove(S);
	}
}