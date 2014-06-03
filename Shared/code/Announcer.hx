package ;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class Announcer extends FlxGroup
{

	public function new()
	{
		super();
	}

	public function parseMsg(Text:String, MarkupString:String):Void
	{
		var t:FlxTextExt = new FlxTextExt(0, 0, FlxG.width, Text, 12, false);
		t.color = 0xffffffff;
		t.ImportMarkups(MarkupString);
		
		addText(t);
	}

	public function addMsg(Text:String, MarkupArr:Array<FlxMarkup>):Void
	{
		var t:FlxTextExt = new FlxTextExt(0, 0, FlxG.width, Text, 12, false, MarkupArr);
		t.color = 0xffffffff;
		for (m in MarkupArr.iterator())
		{
			t.markItUp(m);
		}
		
		addText(t);
	}

	public function addText(Text:FlxText):Void
	{
		Text.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
		Text.scrollFactor.set();
		Text.x = FlxG.width - Text.width;
		
		var last_text:FlxText = Text;
		for (m in members.iterator())
		{
			var t:FlxText = cast (m, FlxText);
			
			t.y += Text.height;
			
			if (t.y > last_text.y)
				last_text = t;
		}
		
		if (members.length > 5)
		{
			remove(last_text, true);
		}
		
		add(Text);
	}
}
