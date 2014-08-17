package ;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import haxe.Unserializer;
import ext.FlxTextExt;
import ext.FlxMarkup;

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
		Text.alpha = 0;
		FlxTween.tween(Text, { alpha:1 }, 1, {type:FlxTween.ONESHOT, ease:FlxEase.cubeIn});
		
		var last_text:FlxText = Text;
		for (m in members.iterator())
		{
			var t:FlxText = cast (m, FlxText);
			
			//t.y += Text.height;
			FlxTween.linearMotion(t, t.x, t.y, t.x, t.y + Text.height, 1, true, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn});
			
			if (t.y > last_text.y)
				last_text = t;
		}
		
		if (members.length > 5)
		{
			removeText(last_text);
		}
		
		add(Text);
	}
	
	private function removeText(T:FlxText):Void
	{
		FlxTween.linearMotion(T, T.x, T.y, T.x, T.y + T.height, 1, true, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn, complete:finalRemoveText});
		FlxTween.tween(T, { alpha:0 }, 1);
	}
	
	private function finalRemoveText(Tween:FlxTween):Void
	{
		if (members.length > 0)
		{
			remove(members[0], true);
		}
	}
}
