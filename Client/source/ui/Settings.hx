package ui;
import flixel.addons.ui.FlxUIButton;
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
		t.y = 10;
		t.text = "Player name: ";
		add(t);
		
		name = new FlxUIInputText();
		name.x = 90;
		name.y = 10;
		name.text = Assets.config.get("name");
		add(name);
		
		var th:FlxUIText = new FlxUIText();
		th.text = "Player color: ";
		th.x = 10;
		th.y = 30;
		add(th);
		
		var data:Array<StrIdLabel> = [new StrIdLabel("g", "Green"),
										new StrIdLabel("b", "Blue"),
										new StrIdLabel("r", "Red"),
										new StrIdLabel("y", "Yellow")];
		color = new FlxUIDropDownMenu(90, 30, data);
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
	}
	
	public function saveSettings():Void
	{
		Assets.config.set("name", name.text);
		
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