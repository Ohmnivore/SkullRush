package ;

import cpp.Lib;
import haxe.io.Path;
import sys.io.Process;
import haxe.io.Eof;
import sys.FileSystem;

/**
 * ...
 * @author Ohmnivore
 */

class Main 
{
	
	static function main() 
	{
		downloadFile(Sys.args()[0]);
	}
	
	static function downloadFile(URL:String):Void
	{
		var p:Process = new Process(Path.join([Path.directory(Sys.executablePath()), "aria2c.exe"]),
			[
			URL,
			"-d",
			Path.directory(Sys.executablePath()),
			//"-o",
			//Path.join([Path.directory(Sys.executablePath()), "aria2c.exe"])
			"--check-certificate=false",
			"--allow-overwrite=true",
			"--auto-file-renaming=false"
			]);
		
		while (true)
		{
			try 
			{ 
				Lib.println(p.stdout.readLine());
			}
			catch(e:Eof)
			{
				break;
			}
		}
		
		Lib.println("Began unzipping.");
		unzip();
		Sys.exit(0);
	}
	
	public static function unzip():Void
	{
		var p:Process = new Process("FBZip.exe",
			[
			"-e",
			"-p",
			Path.join([Path.directory(Sys.executablePath()), "SkullClient.zip"]),
			Path.directory(Path.directory(Sys.executablePath()))
			]);
		
		while (true)
		{
			try 
			{ 
				Lib.println(p.stdout.readLine());
			}
			catch(e:Eof)
			{
				break;
			}
		}
		
		FileSystem.deleteFile(Path.join([Path.directory(Sys.executablePath()), "SkullClient.zip"]));
		
		Lib.println("");
		Lib.println("Done updating!");
		
		new Process("SkullRush.exe", []);
	}
}