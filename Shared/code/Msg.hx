package ;
import enet.Message;
import enet.NetBase;

/**
 * ...
 * @author Ohmnivore
 */
class Msg
{
	//Core messages
	static public var Manifest:Message;
	static public var PlayerInfo:Message;
	static public var PlayerInfoBack:Message;
	static public var PlayerInfoAnnounce:Message;
	static public var PlayerDisco:Message;
	static public var MapMsg:Message;
	static public var PlayerInput:Message;
	static public var PlayerOutput:Message;
	
	//Chat messages
	static public var ChatToClient:Message;
	static public var ChatToServer:Message;
	//Announce message
	static public var Announce:Message;
	
	//Networked object messages
	static public var NewLabel:Message;
	static public var SetLabel:Message;
	static public var NewCounter:Message;
	static public var SetCounter:Message;
	static public var NewTimer:Message;
	static public var SetTimer:Message;
	static public var DeleteHUD:Message;
	
	static public function initMsg():Void
	{
		Manifest = new Message(1, ["url"], true);
		PlayerInfo = new Message(2, ["name", "team"], false);
		PlayerInfoBack = new Message(3, ["id", "name", "color", "graphic"], true);
		MapMsg = new Message(0, ["mapname", "mapstring"], true);
		PlayerInput = new Message(4, ["serialized"], false);
		PlayerOutput = new Message(5, ["serialized"], true);
		PlayerDisco = new Message(6, ["id"], true);
		PlayerInfoAnnounce = new Message(7, ["id", "name", "color", "graphic"], true);
		
		ChatToClient = new Message(8, ["id", "message", "color"], true);
		ChatToServer = new Message(9, ["message"], false);
		Announce = new Message(10, ["message", "markup"], true);
		
		NewLabel = new Message(11, ["id", "x", "y"], true);
		SetLabel = new Message(12, ["id", "text", "color"], true);
		DeleteHUD = new Message(13, ["id"], true);
		NewCounter = new Message(14, ["id", "base", "x", "y"], true);
		SetCounter = new Message(15, ["id", "base", "color", "count"], true);
		NewTimer = new Message(16, ["id", "base", "x", "y"], true);
		SetTimer = new Message(17, ["id", "base", "color", "count", "status"], true);
	}
	
	static public function addToHost(H:NetBase):Void
	{
		H.addMessage(Manifest);
		H.addMessage(PlayerInfo);
		H.addMessage(MapMsg);
		H.addMessage(PlayerInfoBack);
		H.addMessage(PlayerInput);
		H.addMessage(PlayerOutput);
		H.addMessage(PlayerDisco);
		H.addMessage(PlayerInfoAnnounce);
		
		H.addMessage(ChatToClient);
		H.addMessage(ChatToServer);
		H.addMessage(Announce);
		
		H.addMessage(NewLabel);
		H.addMessage(SetLabel);
		H.addMessage(NewCounter);
		H.addMessage(SetCounter);
		H.addMessage(NewTimer);
		H.addMessage(SetTimer);
		H.addMessage(DeleteHUD);
	}
}