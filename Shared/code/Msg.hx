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
	static public var AnnounceTemplates:Message;
	static public var NewSprite:Message;
	static public var SetSprite:Message;
	static public var UpdateSprite:Message;
	static public var DeleteHUD:Message;
	static public var DeleteSprite:Message;
	static public var PlaySound:Message;
	static public var PlayMusic:Message;
	static public var StopMusic:Message;
	static public var NewBoard:Message;
	static public var SetBoard:Message;
	static public var DeleteBoard:Message;
	static public var BoardRequest:Message;
	
	static public var Teams:Message;
	static public var SpawnRequest:Message;
	static public var DeathInfo:Message;
	static public var SpawnConfirm:Message;
	static public var SetAppearance:Message;
	
	static public var EmitterAnnounce:Message;
	static public var EmitterNew:Message;
	static public var EmitterDelete:Message;
	static public var EmitterPause:Message;
	static public var EmitterResume:Message;
	
	static public var AnnounceGuns:Message;
	
	static public var SetSpriteFields:Message;
	static public var SetSpriteImage:Message;
	
	static public var GrantGun:Message;
	
	static public var LineNew:Message;
	static public var LineToggle:Message;
	
	static public var ArrowNew:Message;
	static public var ArrowToggle:Message;
	static public var ArrowDelete:Message;
	
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
		AnnounceTemplates = new Message(22, ["serialized"], true);
		NewSprite = new Message(18, ["id", "x", "y", "template_id"], true);
		SetSprite = new Message(19, ["id", "field", "value"], true);
		UpdateSprite = new Message(20, ["id", "x", "y", "velocity.x", "velocity.y"], true);
		DeleteSprite = new Message(21, ["id"], true);
		PlaySound = new Message(23, ["assetkey"], true);
		PlayMusic = new Message(24, ["assetkey"], true);
		StopMusic = new Message(25, [], true);
		NewBoard = new Message(26, ["id", "title", "color", "headers"], true);
		SetBoard = new Message(30, ["id", "serialized"], true);
		DeleteBoard = new Message(28, ["id"], true);
		BoardRequest = new Message(29, [], false);
		
		Teams = new Message(31, ["serialized"], true);
		SpawnRequest = new Message(32, ["team"], false);
		DeathInfo = new Message(33, ["timer"], true);
		SpawnConfirm = new Message(34, ["color", "graphic"], true);
		SetAppearance = new Message(35, ["id", "color", "graphic"], true);
		
		EmitterAnnounce = new Message(36, ["serialized"], true);
		EmitterNew = new Message(37, ["id", "id2", "x", "y", "graphic", "collide", "rotationFrames",
			"explode", "quantity"], true);
		EmitterDelete = new Message(38, ["id"], true);
		EmitterPause = new Message(42, ["id"], true);
		EmitterResume = new Message(43, ["id"], true);
		
		AnnounceGuns = new Message(39, ["serialized"], true);
		
		SetSpriteFields = new Message(40, ["id", "fields", "values"], true);
		SetSpriteImage = new Message(41, ["id", "graphic"], true);
		
		GrantGun = new Message(44, ["slot"], true);
		
		LineNew = new Message(45, ["id", "x", "y", "length", "angle"], true);
		LineToggle = new Message(46, ["id", "visible"], true);
		
		ArrowNew = new Message(47, ["parentid", "color"], true);
		ArrowToggle = new Message(48, ["parentid", "on"], true);
		ArrowDelete = new Message(49, ["parentid"], true);
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
		H.addMessage(NewSprite);
		H.addMessage(SetSprite);
		H.addMessage(UpdateSprite);
		H.addMessage(DeleteSprite);
		H.addMessage(AnnounceTemplates);
		H.addMessage(PlaySound);
		H.addMessage(PlayMusic);
		H.addMessage(StopMusic);
		H.addMessage(NewBoard);
		H.addMessage(SetBoard);
		H.addMessage(DeleteBoard);
		H.addMessage(BoardRequest);
		
		H.addMessage(Teams);
		H.addMessage(SpawnRequest);
		H.addMessage(DeathInfo);
		H.addMessage(SpawnConfirm);
		H.addMessage(SetAppearance);
		
		H.addMessage(EmitterAnnounce);
		H.addMessage(EmitterNew);
		H.addMessage(EmitterDelete);
		H.addMessage(EmitterPause);
		H.addMessage(EmitterResume);
		
		H.addMessage(AnnounceGuns);
		
		H.addMessage(SetSpriteFields);
		H.addMessage(SetSpriteImage);
		
		H.addMessage(GrantGun);
		
		H.addMessage(LineNew);
		H.addMessage(LineToggle);
		
		H.addMessage(ArrowNew);
		H.addMessage(ArrowToggle);
		H.addMessage(ArrowDelete);
	}
}