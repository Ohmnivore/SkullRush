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
	public var scores:Map<Int, NScoreboard>;
	
	public function new() 
	{
		scores = new Map<Int, NScoreboard>();
	}
	
	public function update():Void
	{
		if (FlxG.keys.justPressed.TAB)
		{
			delta = 0;
			
			Reg.client.send(Msg.BoardRequest.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			for (s in scores.iterator())
			{
				var sc:NScoreboard = cast s;
				sc.toggle();
				
				sc.clear();
			}
		}
		
		delta += FlxG.mouse.wheel * 10;
		
		if (delta > 0)
		{
			delta = 0;
		}
		
		var offset:Float = 0;
		for (s in scores.iterator())
		{
			var score:NScoreboard = s;
			score.group.y = delta + offset;
			offset += score.group.height; 
		}
	}
	
	public function addBoard(S:NScoreboard):Void
	{
		scores.set(S.ID, S);
	}
	
	public function removeBoard(S:NScoreboard):Void
	{
		scores.remove(S.ID);
	}
}