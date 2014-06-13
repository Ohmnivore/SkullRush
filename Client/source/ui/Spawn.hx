package ui;
import enet.ENet;
import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUISubState;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Spawn extends FlxUISubState
{
	public var group:FlxSpriteGroup;
	
	public var deathTimer:FlxTimer;
	public var teams:Array<Team>;
	
	public var radio_g:FlxUIRadioGroup;
	public var spawnBtn:FlxUIButton;
	public var timerLabel:FlxText;
	public var chosenTeam:String = null;
	
	public static var X_BORDER:Int = 40;
	public static var Y_BORDER:Int = 40;
	public static var LAST_SELECTED:String = "0";
	
	public function new(Teams:Array<Team>, WaitTime:Int) 
	{
		super();
		
		teams = Teams;
		
		deathTimer = new FlxTimer(WaitTime);
	}
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.unload();
		
		group = new FlxSpriteGroup();
		group.scrollFactor.set();
		add(group);
		
		var chrome = new FlxUI9SliceSprite(X_BORDER / 2, Y_BORDER / 2, UIAssets.CHROME, new Rectangle(0, 0, 140, 5));
		chrome.scrollFactor.set();
		group.add(chrome);
		
		var index_arr:Array<String> = [];
		var name_arr:Array<String> = [];
		var i:Int = 0;
		if (teams != null)
		{
			for (t in teams)
			{
				var team:Team = t;
				index_arr.push(Std.string(i));
				name_arr.push(team.name);
				i++;
			}
		}
		
		radio_g = new FlxUIRadioGroup(X_BORDER, Y_BORDER, index_arr, name_arr, radioCallback);
		radio_g.scrollFactor.set();
		group.add(radio_g);
		radio_g.selectedId = LAST_SELECTED;
		
		spawnBtn = new FlxUIButton(X_BORDER, Y_BORDER + radio_g.height, "Spawn", spawn);
		spawnBtn.scrollFactor.set();
		UIAssets.setBtnGraphic(spawnBtn);
		group.add(spawnBtn);
		
		timerLabel = new FlxText(X_BORDER + radio_g.width, Y_BORDER, 100);
		timerLabel.scrollFactor.set();
		timerLabel.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000, 1, 0);
		group.add(timerLabel);
		
		chrome.resize(timerLabel.width + timerLabel.x,
						spawnBtn.height + spawnBtn.y);
		
		group.x = (FlxG.width - chrome.width - X_BORDER) / 2;
		group.y = (FlxG.height - chrome.height - Y_BORDER) / 2;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (!deathTimer.finished)
			timerLabel.text = "Respawn in: " + Std.string(Std.int(deathTimer.timeLeft));
	}
	
	override public function destroy():Void 
	{
		FlxG.mouse.load("shared/images/blank.png");
		super.destroy();
	}
	
	private function spawn():Void
	{
		Msg.SpawnRequest.data.set("team", Std.parseInt(LAST_SELECTED));
		Reg.client.send(Msg.SpawnRequest.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	private function radioCallback(S:String):Void
	{
		chosenTeam = S;
		LAST_SELECTED = S;
	}
}