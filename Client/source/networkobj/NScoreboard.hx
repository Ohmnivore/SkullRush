package networkobj;
import enet.ENet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import haxe.Serializer;
import haxe.Unserializer;

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
	private var scores:Map<Int, Dynamic>;
	public var group:FlxSpriteGroup;
	private var t_group:FlxSpriteGroup;
	private var texts:Map<Int, Dynamic>;
	public var sortBy:Int;
	
	public var back:FlxSprite;
	public var ID:Int;
	
	public function new(id:Int, Title:String, Headers:Array<String>,
		SortBy:Int = 0, Color:Int = 0xffffffff)
	{
		title = Title;
		headers = Headers;
		//headers.unshift("Player");
		color = Color;
		sortBy = SortBy;
		
		scores = new Map<Int, Dynamic>();
		texts = new Map<Int, Dynamic>();
		group = new FlxSpriteGroup();
		group.scrollFactor.set();
		
		back = new FlxSprite(0, 0);
		back.scrollFactor.set();
		back.makeGraphic(FlxG.width, FlxG.height, 0x99000000);
		group.add(back);
		
		t_group = new FlxSpriteGroup();
		t_group.scrollFactor.set();
		group.add(t_group);
		
		make();
		
		toggle();
		
		ID = id;
		
		Reg.state.scores.addBoard(this);
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
	
	public function clear():Void
	{
		for (t in t_group.members)
		{
			t_group.remove(t, true);
			t.kill();
			t.destroy();
		}
	}
	
	public function setData(S:String):Void
	{
		var arr:Array<Dynamic> = cast Unserializer.run(S);
		
		for (t in t_group.members)
		{
			t_group.remove(t, true);
			t.kill();
			//t.destroy();
		}
		
		Y = X_BORDER + 2 * Y_SPACING;
		
		for (arr2 in arr)
		{
			var arrt:Array<Dynamic> = cast arr2;
			
			X = X_BORDER;
			
			var t:FlxText = new FlxText(X, Y, FlxG.width, Reg.state.playermap.get(arrt[0]).name);
			t_group.add(t);
			X += X_SPACING;
			
			var i:Int = 0;
			while (i < arrt.length)
			{
				if (i > 0)
				{
					var t:FlxText = new FlxText(X, Y, FlxG.width, arrt[i]);
					t_group.add(t);
					X += X_SPACING;
				}
				i++;
			}
			
			Y += Y_SPACING;
		}
	}
	
	public function destroy():Void
	{
		Reg.state.scores.removeBoard(this);
		Reg.state.hud.remove(group, true);
		group.kill();
		group.destroy();
	}
	
	public function make():Void
	{
		var tot_width:Int = Std.int(FlxG.width - (X_BORDER * 2));
		
		X_SPACING = Std.int(tot_width / headers.length);
		
		X = X_BORDER;
		Y = X_BORDER;
		
		var tt:FlxText = new FlxText(X, Y, FlxG.width, title);
		tt.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
		group.add(tt);
		
		Y += Y_SPACING;
		
		for (h in headers)
		{
			var ht:FlxText = new FlxText(X, Y, FlxG.width, Std.string(h));
			ht.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
			group.add(ht);
			X += X_SPACING;
		}
		
		Y += Y_SPACING;
		
		group.setAll("color", color);
	}
	
}