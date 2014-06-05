package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.Eof;
import haxe.io.Path;
import haxe.Json;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Uncompress;
import openfl.events.ProgressEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.text.TextField;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import sys.io.Process;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.errors.IllegalOperationError;
//import openfl.net.URLStream;

/**
 * ...
 * @author Ohmnivore
 */

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
		
		downloadZip();
		//unzip();
	}
	
	public static function myTrace(S:Dynamic):Void
	{
		cpp.Lib.println(S);
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
		pageLoader.load(pageRequest); //actually load the page
		myTrace("Started version file download");
	}
	
	static function onPageLoaded(e:Event):Void
	{
		var p:URLLoader = cast e.target;
		
		myTrace("Finished version file download");
		interpretJSON(cast p.data);
	}
	
	static function interpretJSON(S:String):Void
	{
		var config:String = File.getContent(Path.join([Path.directory(Sys.executablePath()), "config.txt"]));
		var begin:Int = config.indexOf("version=") + 8;
		var end:Int = config.indexOf("\n", begin);
		
		var info:Dynamic = Json.parse(S);
		
		if (isNewer(cast Reflect.field(info, "version"), config.substring(begin, end)))
		{
			myTrace("Started new version download");
			downloadFile(cast Reflect.field(info, "url"));
		}
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
				myTrace(p.stdout.readLine());
			}
			catch(e:Eof)
			{
				break;
			}
		}
		
		myTrace("unzipping");
		unzip();
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
		myTrace(percentLoaded);
	}
	
	static function onFileLoaded(e:Event):Void
	{
		var p:URLLoader = cast e.target;
		
		myTrace("Finished new version download");
		myTrace(p.bytesLoaded);
		myTrace(p.bytesTotal);
	}
	
	static function isNewer(Old:String, New:String):Bool
	{
		var old_v:Version = new Version(Old);
		
		var new_v:Version = new Version(New);
		
		return new_v.isMoreRecent(old_v);
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
				myTrace(p.stdout.readLine());
			}
			catch(e:Eof)
			{
				break;
			}
		}
		
		FileSystem.deleteFile(Path.join([Path.directory(Sys.executablePath()), "SkullClient.zip"]));
		myTrace("done");
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
