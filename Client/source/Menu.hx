package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import ui.Home;

/**
 * ...
 * @author Ohmnivore
 */
class Menu extends FlxSubState
{
	static public var OPENED:Bool = false;
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.unload();
		
		OPENED = true;
		
		var backBtn:FlxButton = new FlxButton(0, 0, "Exit server", exit);
		backBtn.x = (FlxG.width - backBtn.width) / 2;
		backBtn.y = (FlxG.height - backBtn.height) / 2;
		
		var fill:FlxSprite = new FlxSprite(0, 0);
		fill.makeGraphic(FlxG.width, FlxG.height, 0x99000000);
		fill.scrollFactor.set();
		
		add(fill);
		add(backBtn);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
	}
	
	override public function destroy():Void 
	{
		OPENED = false;
		FlxG.mouse.load("shared/images/blank.png");
		
		super.destroy();
	}
	
	public function exit():Void
	{
		Reg.client.peerDisconnect(Reg.client._s_id, false);
		Reg.state.m.acquire();
		SkullClient.execute = false;
		Reg.client.poll();
		Reg.client.poll();
		Reg.client.poll();
		Reg.state.m.release();
		SkullClient.init = false;
		FlxG.switchState(new Home());
	}
}