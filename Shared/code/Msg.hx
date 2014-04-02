package ;
import enet.Message;
import enet.NetBase;

/**
 * ...
 * @author Ohmnivore
 */
class Msg
{
	static public var MapMsg:Message;
	
	static public function initMsg():Void
	{
		MapMsg = new Message(0, ["mapname", "mapstring"], true);
	}
	
	static public function addToHost(H:NetBase):Void
	{
		H.addMessage(MapMsg);
	}
}