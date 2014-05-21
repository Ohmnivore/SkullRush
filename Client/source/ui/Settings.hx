package ui;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;
import flixel.addons.ui.StrIdLabel;
import flixel.addons.ui.FlxUIDropDownMenu.FlxUIDropDownHeader;

/**
 * ...
 * @author Ohmnivore
 */
class Settings extends FlxUIState
{
	public var name:FlxUIInputText;
	public var color:FlxUIDropDownMenu;
	public var version:FlxUIText;
	
	public var full:FlxUICheckBox;
	public var ping:FlxUICheckBox;
	
	private var quick_apply:Bool;
	
	public function new(QuickApply:Bool = false)
	{
		super();
		
		quick_apply = QuickApply;
	}
	
	override public function create() 
	{
		Util.initXML(this);
		super.create();
		Util.addBackBtn(this);
		
		var save:FlxUIButton = new FlxUIButton(10, 0, "Save", saveSettings);
		save.y = FlxG.height - save.height - 5;
		add(save);
		
		var t:FlxUIText = new FlxUIText();
		t.x = 10;
		t.y = 30;
		t.text = "Player name: ";
		add(t);
		
		name = new FlxUIInputText();
		name.x = 90;
		name.y = 30;
		name.text = Assets.config.get("name");
		add(name);
		
		var th:FlxUIText = new FlxUIText();
		th.text = "Player color: ";
		th.x = 10;
		th.y = 50;
		add(th);
		
		var data:Array<StrIdLabel> = [new StrIdLabel("g", "Green"),
										new StrIdLabel("b", "Blue"),
										new StrIdLabel("r", "Red"),
										new StrIdLabel("y", "Yellow")];
		color = new FlxUIDropDownMenu(90, 50, data);
		switch (Assets.config.get("team"))
		{
			case "0":
				color.selectedId = "g";
			case "1":
				color.selectedId = "b";
			case "2":
				color.selectedId = "y";
			case "3":
				color.selectedId = "r";
		}
		add(color);
		
		version = new FlxUIText();
		version.text = "Version: " + Assets.config.get("version");
		version.x = 10;
		version.y = 10;
		add(version);
		
		var settings:Map<String, Dynamic> = SharedSettings.returnGraphicOptions();
		full = cast settings.get("full");
		full.x = 10;
		full.y = 120;
		full.callback = handleFull;
		switch (Assets.config.get("fullscreen"))
		{
			case "true":
				full.checked = true;
			case "false":
				full.checked = false;
		}
		handleFull();
		add(full);
		
		ping = cast settings.get("ping");
		ping.x = 10;
		ping.y = 140;
		switch (Assets.config.get("showping"))
		{
			case "true":
				ping.checked = true;
			case "false":
				ping.checked = false;
		}
		add(ping);
		
		if (quick_apply)
		{
			FlxG.switchState(new Home());
		}
	}
	
	public function handleFull():Void
	{
		if (full.checked)
		{
			SharedSettings.setFullScreen(true);
		}
		
		else
		{
			SharedSettings.setFullScreen(false);
		}
	}
	
	public function saveSettings():Void
	{
		Assets.config.set("name", name.text);
		
		Assets.config.set("fullscreen", Std.string(full.checked));
		Assets.config.set("showping", Std.string(ping.checked)); 
		
		switch (color.selectedId)
		{
			case "g":
				Assets.config.set("team", "0");
			case "b":
				Assets.config.set("team", "1");
			case "y":
				Assets.config.set("team", "2");
			case "r":
				Assets.config.set("team", "3");
		}
		
		Assets.saveConfig();
	}
	
}