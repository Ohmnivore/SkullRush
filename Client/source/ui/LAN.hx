package ui;
import cpp.vm.Thread;
import enet.ENet;
import flixel.addons.ui.FlxUIState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import hxudp.UdpSocket;

/**
 * ...
 * @author Ohmnivore
 */
class LAN extends FlxUIState
{
	public var s:UdpSocket;
	public var serverarr:Array<ServerInfo> = [];
	
	override public function create() 
	{
		Util.initXML(this);
		super.create();
		Util.addBackBtn(this);
		
		s = new UdpSocket();
		s.create();
		s.bind(1990);
		s.setNonBlocking(true);
		s.setEnableBroadcast(true);
		s.connect(ENet.BROADCAST_ADDRESS, 1945);
		
		new FlxTimer(0.5, sendRequest);
	}
	
	override public function update():Void 
	{
		updateS();
		
		if (FlxG.keys.justPressed.I)
		{
			sendRequest(new FlxTimer(0.1));
		}
		
		super.update();
	}
	
	public function sendRequest(T:FlxTimer):Void
	{
		s.sendAll(Bytes.ofString("get_info"));
	}
	
	public function updateST(T:FlxTimer):Void
	{
		updateS();
	}
	
	public function updateS():Void
	{
		//while (true)
		//{
		var b = Bytes.alloc(80);
		trace(s.receive(b));
		var msg:String = new BytesInput(b).readUntil(0);
		
		if (msg.length > 0)
		{
			trace(msg);
			//add(new FlxText(10, 200, 0, Std.string(Std.random(20))));
		}
		//Sys.sleep(0.05);
		//}
	}
}