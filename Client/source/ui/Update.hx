package ui;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.group.FlxSpriteGroup;
import ui.update.Version;
import ui.update.UpdateUtil;

/**
 * ...
 * @author Ohmnivore
 */
class Update extends FlxUIState
{
	var texts:FlxSpriteGroup;
	
	override public function create() 
	{
		Util.initXML(this);
		super.create();
		Util.addBackBtn(this);
		
		texts = new FlxSpriteGroup();
		add(texts);
		
		var go:FlxUIButton = new FlxUIButton(10, 10, "Update", fetchUpdate);
		UIAssets.setBtnGraphic(go);
		add(go);
		
		texts.y += 10 + go.height;
	}
	
	function test(Old:String, New:String):Void
	{
		var v1:Version = new Version(Old);
		var v2:Version = new Version(New);
		trace(Old, New, v2.isMoreRecent(v1));
	}
	
	public function fetchUpdate():Void
	{
		texts.callAll("kill");
		texts.callAll("destroy");
		texts.clear();
		UpdateUtil.group = texts;
		UpdateUtil.downloadZip();
	}
	
}