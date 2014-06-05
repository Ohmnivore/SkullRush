package ui.update;

import cpp.vm.Thread;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import haxe.io.Path;
import flash.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import sys.io.File;
import sys.io.Process;
import openfl.events.ProgressEvent;
import haxe.io.Eof;

/**
 * ...
 * @author Ohmnivore
 */
class UpdateUtil
{
	static public var group:FlxSpriteGroup;
	
	static function myTrace(S:String):Void
	{
		var t:FlxText = new FlxText(10, group.height, 0, S);
		group.add(t);
	}
	
	static function getURL():String
	{
		var path:String = Path.join([Path.directory(Sys.executablePath()), "UpdaterURL.txt"]);
		return File.getContent(path);
	}
	
	public static function downloadZip():Void
	{
		var pageLoader:URLLoader = new URLLoader(); //make a loader that will load a page
		var pageRequest:URLRequest = new URLRequest(getURL()); //make a request with a url to page
		pageRequest.method = URLRequestMethod.GET; //set request's html request method to GET
		
		pageLoader.addEventListener(Event.COMPLETE, onPageLoaded); //listen for page load
		pageLoader.addEventListener(ProgressEvent.PROGRESS, onFileProgress); //listen for page load
		pageLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		pageLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		pageLoader.load(pageRequest); //actually load the page
		myTrace("Started version file download.");
	}
	
	static function onPageLoaded(e:Event):Void
	{
		var p:URLLoader = cast e.target;
		
		myTrace("Finished version file download.");
		interpretJSON(cast p.data);
	}
	
	static function interpretJSON(S:String):Void
	{
		var config:String = File.getContent(Path.join([Path.directory(Sys.executablePath()), "config.txt"]));
		var begin:Int = config.indexOf("version=") + 8;
		var end:Int = config.indexOf("\n", begin);
		
		var info:Dynamic = Json.parse(S);
		
		//if (isNewer(cast Reflect.field(info, "version"), config.substring(begin, end)))
		if (isNewer(config.substring(begin, end), cast Reflect.field(info, "version")))
		{
			myTrace("Started new version download: ");
			downloadFile(cast Reflect.field(info, "url"));
		}
		else
		{
			myTrace("You already have the newest version.");
		}
	}
	
	static function exit(T:FlxTimer):Void
	{
		Sys.exit(0);
	}
	
	static function downloadFile(URL:String):Void
	{
		Thread.create(function() {
			var p:Process = new Process("SkullUpdate.exe", [URL]);
		});
		
		new FlxTimer(0.2, exit);
		//Thread.create(function(){
		//var p:Process = new Process(Path.join([Path.directory(Sys.executablePath()), "aria2c.exe"]),
			//[
			//URL,
			//"-d",
			//Path.directory(Sys.executablePath()),
			//"-o",
			//Path.join([Path.directory(Sys.executablePath()), "aria2c.exe"])
			//"--check-certificate=false",
			//"--allow-overwrite=true",
			//"--auto-file-renaming=false"
			//]);
		//
		//while (true)
		//{
			//try 
			//{ 
				//myTrace(p.stdout.readLine());
			//}
			//catch(e:Eof)
			//{
				//break;
			//}
		//}
		//
		//myTrace("Began unzipping.");
		//Thread.create(unzip);
		//Sys.exit(0);
		//});
		//new Process(Path.join([Path.directory(Sys.executablePath()), "wget.exe"]), []);
		
		//var pageLoader:URLLoader = new URLLoader(); //make a loader that will load a page
		//pageLoader.dataFormat = URLLoaderDataFormat.BINARY;
		//var pageRequest:URLRequest = new URLRequest(URL); //make a request with a url to page
		
		//pageLoader.addEventListener(Event.COMPLETE, onFileLoaded); //listen for page load
		//pageLoader.addEventListener(ProgressEvent.PROGRESS, onFileProgress); //listen for page load
		//pageLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		//pageLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		//pageLoader.load(pageRequest); //actually load the page
		//pageLoader.dataFormat = URLLoaderDataFormat.BINARY;
	}
	
	static function onError(e:Dynamic)
	{
		myTrace(e);
	}
	
	static function onFileProgress(e:ProgressEvent):Void
	{
		var percentLoaded:Float = e.bytesLoaded / e.bytesTotal;
		percentLoaded = Math.round(percentLoaded * 100);
		myTrace('Version file download progress: $percentLoaded %');
	}
	
	static function onFileLoaded(e:Event):Void
	{
		var p:URLLoader = cast e.target;
		
		myTrace("Finished new version download.");
	}
	
	static function isNewer(Old:String, New:String):Bool
	{
		var old_v:Version = new Version(Old);
		
		var new_v:Version = new Version(New);
		
		return new_v.isMoreRecent(old_v);
	}
	
	//public static function unzip():Void
	//{
		//var p:Process = new Process("SkullUnzip.exe", []);
	//}
	
}