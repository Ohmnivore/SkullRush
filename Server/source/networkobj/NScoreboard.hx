package networkobj;
import enet.ENet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import gamemodes.BaseGamemode;
import haxe.Serializer;

/**
 * ...
 * @author Ohmnivore
 */
class NScoreboard
{
	static var X_BORDER:Int = 10;
	static var Y_SPACING:Int = 20;
	static var X_SPACING:Int;
	static var X:Int;
	static var Y:Int;
	
	public var opened:Bool = true;
	
	public var color:Int;
	public var title:String;
	public var headers:Array<String>;
	public var default_headers:Array<String>;
	private var scores:Map<Int, Dynamic>;
	public var group:FlxSpriteGroup;
	private var texts:Map<Int, Dynamic>;
	
	public var back:FlxSprite;
	
	public var ID:Int;
	
	public function new(Title:String, Headers:Array<String>, DefaultHeaders:Array<String>,
						Color:Int = 0xff000000) 
	{
		title = Title;
		headers = Headers;
		headers.unshift("Player");
		default_headers = DefaultHeaders;
		color = Color;
		
		scores = new Map<Int, Dynamic>();
		texts = new Map<Int, Dynamic>();
		group = new FlxSpriteGroup();
		group.scrollFactor.set();
		
		back = new FlxSprite(0, 0);
		back.scrollFactor.set();
		back.makeGraphic(FlxG.width, FlxG.height, 0x99000000);
		group.add(back);
		make();
		
		toggle();
		
		ID = NReg.getID();
		
		BaseGamemode.scores.addBoard(this);
	}
	
	public function toggle():Void
	{
		if (opened)
		{
			group.visible = false;
		}
		
		else
		{
			group.visible = true;
		}
		
		opened = !opened;
	}
	
	public function addPlayer(P:Player):Void
	{
		scores.set(P.ID, default_headers);
		
		var arr:Array<FlxText> = [];
		X = X_BORDER;
		
		var t:FlxText = new FlxText(X, Y, FlxG.width, P.name);
		arr.push(t);
		group.add(t);
		X += X_SPACING;
		
		for (h in default_headers)
		{
			var t:FlxText = new FlxText(X, Y, FlxG.width, Std.string(h));
			arr.push(t);
			group.add(t);
			X += X_SPACING;
		}
		
		texts.set(P.ID, arr);
		
		Y += Y_SPACING;
	}
	
	public function setPlayer(P:Player, ToSet:Array<Dynamic>):Void
	{
		var arr:Array<FlxText> = cast texts.get(P.ID);
		var i:Int = 0;
		for (t in arr)
		{
			if (i > 0)
			{
				var text:FlxText = t;
				text.text = Std.string(ToSet[i-1]);
			}
			i++;
		}
	}
	
	public function removePlayer(P:Player):Void
	{
		scores.remove(P.ID);
		
		var arr:Array<FlxText> = cast texts.get(P.ID);
		for (t in arr)
		{
			var text:FlxText = t;
			group.remove(text, true);
			text.kill();
			text.destroy();
		}
		
		texts.remove(P.ID);
		
		Y -= Y_SPACING;
	}
	
	public function announce(P:Int):Void
	{
		Msg.NewBoard.data.set("id", ID);
		Msg.NewBoard.data.set("title", title);
		Msg.NewBoard.data.set("color", color);
		Msg.NewBoard.data.set("headers", Serializer.run(headers));
		
		Msg.SetBoard.data.set("id", ID);
		Msg.SetBoard.data.set("serialized", getData());
		
		Reg.server.sendMsg(P, Msg.NewBoard.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		Reg.server.sendMsg(P, Msg.SetBoard.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	public function getData():String
	{
		var arr:Array<Dynamic> = [];
		
		for (id in texts.keys())
		{
			var arr2:Array<Dynamic> = [];
			
			var tarr:Array<FlxText> = texts.get(id);
			var i:Int = 0;
			for (s in tarr)
			{
				if (i > 0)
				{
					var text:FlxText = s;
					arr2.push(text.text);
				}
				
				else
				{
					arr2.push(id);
				}
				
				i++;
			}
			
			arr.push(arr2);
		}
		
		return Serializer.run(arr);
	}
	
	public function destroy():Void
	{
		BaseGamemode.scores.removeBoard(this);
		
		Msg.DeleteBoard.data.set("id", ID);
		
		//Reg.state.hud.remove(group, true);
		//group.kill();
		//group.destroy();
		
		for (p in Reg.server.playermap.keys())
		{
			Reg.server.sendMsg(p, Msg.DeleteBoard.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function make():Void
	{
		var tot_width:Int = Std.int(FlxG.width - (X_BORDER * 2));
		
		X_SPACING = Std.int(tot_width / headers.length);
		
		X = X_BORDER;
		Y = X_BORDER;
		
		group.add(new FlxText(X, Y, FlxG.width, title));
		
		Y += Y_SPACING;
		
		for (h in headers)
		{
			group.add(new FlxText(X, Y, FlxG.width, Std.string(h)));
			X += X_SPACING;
		}
		
		Y += Y_SPACING;
		
		group.setAll("color", color);
	}
	
}