package networkobj;

/**
 * ...
 * @author Ohmnivore
 */
class NHUD
{
	public var local:Bool;
	public var player:Int;
	
	public function new() 
	{
		
	}
	
	public function announce(PlayerID:Int = 0):Void
	{
		if (PlayerID == 0)
		{
			NReg.huds.push(this);
		}
	}
	
	public function delete():Void
	{
		if (player == 0)
		{
			NReg.huds.remove(this);
		}
	}
}