package ui;
import haxe.Json;

/**
 * ...
 * @author Ohmnivore
 */
class ServerInfo
{
	public var name:String;
	public var map:String;
	public var gm:String;
	public var players:Int;
	public var players_max:Int;
	public var ip:String;
	
	public function new()
	{
		
	}
	
	public function setAttributes(Name:String, MapName:String, GameMode:String,
									Players:Int, MaxPlayers:Int, IP:String):Void
	{
		name = Name;
		map = MapName;
		gm = GameMode;
		players = Players;
		players_max = MaxPlayers;
		ip = IP;
	}
	
	public function unserializeLAN(S:String):Void
	{
		var arr:Array<Dynamic> = cast (Json.parse(S), Array<Dynamic>);
		
		setAttributes(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5]);
	}
	
	public function unserializeBrowser(S:String):Void
	{
		
	}
}