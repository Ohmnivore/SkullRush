package ui;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIList;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.FlxG;
import haxe.Json;

/**
 * ...
 * @author Ohmnivore
 */
class Public extends FlxUIState
{
	public var url:String;
	public var loader:URLLoader;
	public var request:URLRequest;
	
	public var l:FlxUIList;
	public var servers:Array<ServerInfo> = [];
	
	override public function create() 
	{
		Util.initXML(this);
		super.create();
		Util.addBackBtn(this);
		
		url = Assets.config.get("masterserver")  + "jsoned";
		loader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, onPageLoaded);
		
		l = new FlxUIList(30, 30, FlxG.width - 60, FlxG.height - 60, FlxUIList.STACK_VERTICAL, 2);
		add(l);
		
		refresh();
	}
	
	public function onPageLoaded(E:Event):Void
	{
		var d:Dynamic = Json.parse(loader.data);
		var arr:Array<Dynamic> = cast(d, Array<Dynamic>);
		
		servers = [];
		for (s in arr)
		{
			var server:ServerInfo = new ServerInfo();
			
			server.setAttributes(Reflect.field(s, "Name"),
									Reflect.field(s, "Map"),
									Reflect.field(s, "GameMode"),
									Reflect.field(s, "Players"),
									Reflect.field(s, "MaxPlayers"),
									Reflect.field(s, "IP"));
			
			servers.push(server);
		}
		
		generateUI();
	}
	
	public function generateUI():Void
	{
		var arr:Array<IFlxUIWidget> = [];
		
		if (servers.length > 0)
		{
			for (server in servers)
			{
				var t:FlxUIButton = new FlxUIButton(10, 10, server.getString());
				t.params = [server.ip];
				t.loadGraphicSlice9(null, FlxG.width - 60, 30, null);
				t.setCenterLabelOffset(0, 15);
				l.add(cast t);
				l.refreshList();
			}
		}
		
		else
		{
			//openSubState(new NoServerAlert());
		}
	}
	
	public override function getEvent(id:String, target:Dynamic, data:Array<Dynamic>, ?params:Array<Dynamic>):Void 
	{
		if (params != null && params.length > 0) {
			if (id == "click_button") {
				var i:String = cast params[0];
				Assets.config.set("ip", i);
				Assets.saveConfig();
				FlxG.switchState(new PlayState());
			}
		}
	}
	
	public function refresh():Void
	{
		request = new URLRequest();
		request.method = URLRequestMethod.GET;
		request.url = url;
		
		fireRequest();
	}
	
	public function fireRequest():Void
	{
		loader.load(request);
	}
}