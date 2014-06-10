package ;

import cpp.Lib;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

/**
 * ...
 * @author Ohmnivore
 */

class Main 
{
	
	static function main() 
	{
		var p:PathInfo = readPaths(Path.join([Path.directory(Sys.executablePath()), "UpdateMapsPaths.json"]));
		
		copyMaps(p);
	}
	
	static private function readPaths(P:String):PathInfo
	{
		var arr:Array<String> = cast Json.parse(File.getContent(P));
		
		return new PathInfo(arr[0], arr[1]);
	}
	
	static private function copyMaps(P:PathInfo):Void
	{
		var sources:Array<String> = FileSystem.readDirectory(P.source);
		
		for (s in sources)
		{
			var full_path:String = Path.join([P.source, s]);
			if (!FileSystem.isDirectory(full_path))
			{
				var cont:String = File.getContent(full_path);
				File.saveContent(Path.join([P.dest, s]), cont);
			}
		}
	}
	
}

class PathInfo
{
	public var source:String;
	public var dest:String;
	
	public function new(Source:String, Dest:String)
	{
		source = Path.join([Path.directory(Sys.executablePath()), Source]);
		dest = Path.join([Path.directory(Sys.executablePath()), Dest]);
	}
}