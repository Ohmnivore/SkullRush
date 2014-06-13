package ;
import sys.io.Process;
import haxe.io.Path;
import haxe.io.Eof;

/**
 * ...
 * @author Ohmnivore
 */

class PortForward
{

	static public function portForward(Port:Int, DoTrace:Bool = false):Void
	{
		var curdir:String = Path.directory(Sys.executablePath());
		
		var p:Process = new Process(Path.join([curdir, "upnpc-static.exe"]), [
			"-r",
			Std.string(Port),
			"udp"
			]);
		
		if (DoTrace)
		{
			while (true)
			{
				try 
				{ 
					trace(p.stdout.readLine());
				}
				catch(e:Eof)
				{
					break;
				}
			}
		}
	}
	
	static public function portRemove(Port:Int, DoTrace:Bool = false):Void
	{
		var curdir:String = Path.directory(Sys.executablePath());
		
		var p:Process = new Process(Path.join([curdir, "upnpc-static.exe"]), [
			"-d",
			Std.string(Port),
			"udp"
			]);
		
		if (DoTrace)
		{
			while (true)
			{
				try 
				{ 
					trace(p.stdout.readLine());
				}
				catch(e:Eof)
				{
					break;
				}
			}
		}
	}
	
}