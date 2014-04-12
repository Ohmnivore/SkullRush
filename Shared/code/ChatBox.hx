package ;
import flash.text.TextFormat;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxTextField;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class ChatBox extends FlxSpriteGroup
{
	public var opened:Bool;
	
	public var text:FlxInputText;
	public var background:FlxSprite;
	
	public var callback:Void->Void;
	
	private var tot_height:Float;
	private var texts:FlxSpriteGroup;
	
	public function new() 
	{
		super(0, 0, 6);
		scrollFactor.set();
		
		opened = true;
		
		text = new FlxInputText(0, 0, FlxG.width, null, 8);
		text.callback = _call;
		text.hasFocus = true;
		
		background = new FlxSprite(0, text.height);
		background.makeGraphic(FlxG.width, Std.int(text.height * 4), 0x99000000);
		
		texts = new FlxSpriteGroup(0, text.height, 10);
		
		add(background);
		add(text);
		add(texts);
		
		tot_height = background.height + text.height;
		
		y += FlxG.height - tot_height;
		
		toggle();
	}
	
	public function addMsg(T:String, Color:Int):Void
	{
		var markup_index:Int = T.indexOf(":");
		
		var cur_text:FlxText = new FlxText(0, 0, FlxG.width, T);
		cur_text.addFormat(new FlxTextFormat(Color, 0, markup_index), 0, markup_index);
		
		var last_text:FlxText = cur_text;
		for (i in texts.members.iterator())
		{
			var t:FlxText = cast (i, FlxText);
			t.y += cur_text.height;
			
			if (t.y > last_text.y)
				last_text = t;
		}
		
		if (texts.members.length > 5)
		{
			texts.remove(last_text, true);
		}
		
		texts.add(cur_text);
	}
	
	public function _call(Text:String, Action:String):Void
	{
		if (Action == FlxInputText.ENTER_ACTION)
		{
			if (callback != null)
				callback();
		}
	}
	
	public function open():Void
	{
		if (!opened)
			toggle();
	}
	
	public function close():Void
	{
		if (opened)
			toggle();
	}
	
	public function toggle():Void
	{
		if (opened)
		{
			text.hasFocus = false;
			text.visible = false;
			y += text.height * 2;
		}
		
		else
		{
			text.hasFocus = true;
			text.visible = true;
			y -= text.height * 2;
		}
		
		opened = !opened;
	}
}