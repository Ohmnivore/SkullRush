package ;

import flash.display.BitmapData;
import flash.utils.ByteArray;
import flixel.FlxSprite;
import haxe.io.Bytes;
import haxe.io.Path;
import mloader.ImageLoader;
import mloader.Loader;
import mloader.LoaderQueue;
import mloader.HttpLoader;
import mloader.JsonLoader;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

/**
 * ...
 * @author Ohmnivore
 */
class Downloader
{
	public var whenfinished:Void->Void;
	public var subm_loaded:Int = 0;
	public var subm_toload:Int;
	
	public var queue:LoaderQueue;
	public var subqueue:LoaderQueue;
	public var manifestloader:JsonLoader<Dynamic>;
	
	public var manifestroot:String;
	public var manifestarray:Array<String>;
	
	public function new(ManifestURL:String) 
	{
		//setup queue
		queue = new LoaderQueue();
		queue.ignoreFailures = false;
		queue.autoLoad = true;
		
		//Start manifest download
		manifestroot = ManifestURL.split("manifest.json")[0];
		manifestloader = new JsonLoader<Dynamic>(ManifestURL);
		queue.add(manifestloader);
		queue.loaded.add(manifestloaded);
	}
	
	function manifestloaded(event)
	{
		switch (event.type)
		{
			case LoaderEventType.Fail(error):
				Reg.state.downloadError(error);

			case LoaderEventType.Complete:
				//Start sub-manifest downloading
				manifestarray = Json.parse(manifestloader.loader.data);
				
				startSubManifests(manifestarray);

			default:
		}
	}
	
	public function startSubManifests(Arr:Array<String>):Void
	{
		subm_toload = Arr.length;
		
		queue.loaded.removeAll();
		subqueue = new LoaderQueue();
		subqueue.ignoreFailures = false;
		subqueue.autoLoad = true;
		
		for (s in Arr)
		{
			var manifestloader:JsonLoader<Dynamic> = new JsonLoader<Dynamic>(manifestroot + s + ".json");
			manifestloader.info = s;
			subqueue.add(manifestloader);
		}
		
		subqueue.loaded.add(submanifestloaded);
	}
	
	function submanifestloaded(event)
	{
		switch (event.type)
		{
			case LoaderEventType.Fail(error):
				Reg.state.downloadError(error);
				

			case LoaderEventType.Complete:
				//Start assets downloading
				var s:String = event.target.info;
				if (FileSystem.exists("downloads/" + s + "/version.txt")) //Already have folder structure
				{
					var v:Int = event.target.data[0];
					
					var myv:Int = Std.parseInt(File.getContent(Path.addTrailingSlash("downloads") +
													Path.addTrailingSlash(s) + "version.txt"));
					
					if (myv != v) //Re-download if different version
					{
						var w:FileOutput = File.write(Path.addTrailingSlash("downloads") +
														Path.addTrailingSlash(s) + "version.txt", false);
						w.prepare(20);
						w.writeString(Std.string(v));
						w.flush();
						w.close();
						startAssets(event.target.data[1], s);
					}
					else //Load existing assets
					{
						loadAssets(event.target.data[1], s);
					}
				}
				else //Create folder structure and download
				{
					FileSystem.createDirectory(Path.addTrailingSlash("downloads") + s);
					FileSystem.createDirectory(Path.addTrailingSlash("downloads") +
												Path.addTrailingSlash(s) +
												"images");
					var w:FileOutput = File.write(Path.addTrailingSlash("downloads") +
													Path.addTrailingSlash(s) + "version.txt", false);
					w.prepare(20);
					w.writeString(Std.string(event.target.data[0]));
					w.flush();
					w.close();
					startAssets(event.target.data[1], s);
				}

			default:
		}
	}
	
	public function loadAssets(Manifest:Dynamic, FolderName:String):Void
	{
		//Casting from Dynamic to Array<String>
		var arr:Array<Dynamic> = cast (Manifest, Array<Dynamic>);
		var Arr:Array<String> = [];
		for (d in arr)
		{
			Arr.push(d);
		}
		
		for (s in Arr)
		{
			var bytes:ByteArray = ByteArray.readFile("downloads/" + FolderName + s);
			
			var bit:BitmapData = BitmapData.loadFromBytes(bytes);
			
			Assets.images.set("assets" + s, bit);
		}
		
		subm_loaded++;
		
		if (subm_loaded >= subm_toload)
		{
			if (whenfinished != null)
			{
				whenfinished();
			}
		}
	}
	
	//public function startAssets(Arr:Array<String>):Void
	public function startAssets(D:Dynamic, FolderName:String):Void
	{
		//Casting from Dynamic to Array<String>
		var arr:Array<Dynamic> = cast (D, Array<Dynamic>);
		var Arr:Array<String> = [];
		for (d in arr)
		{
			Arr.push(d);
		}
		
		var assetqueue = new LoaderQueue();
		assetqueue.ignoreFailures = false;
		assetqueue.autoLoad = true;
		
		for (s in Arr)
		{
			var filetype:String = s.substr(s.length - 3, 3);
			
			if (filetype == "png")
			{
				var imgloader:ImageLoader = new ImageLoader(manifestroot + s);
				imgloader.info = new Array<Dynamic>();
				imgloader.info[0] = filetype;
				imgloader.info[1] = "assets" + s;
				imgloader.info[2] = FolderName;
				assetqueue.add(imgloader);
			}
		}
		
		assetqueue.loaded.add(assetloaded);
	}
	
	function assetloaded(event)
	{
		switch (event.type)
		{
			case LoaderEventType.Fail(error):
				Reg.state.downloadError(error);
				

			case LoaderEventType.Complete:
				//Add asset to asset map
				if (event.target.info[0] == "png")
				{
					var key:String = event.target.info[1];
					
					Assets.images.set(key, event.target.data);
					
					var image:BitmapData = event.target.data;
					var b:ByteArray = image.encode("png", 1);
					
					trace(Path.addTrailingSlash("downloads") +
							event.target.info[2] +
							key.substring(6),
							true);
					
					var fo:FileOutput = sys.io.File.write(Path.addTrailingSlash("downloads") +
															event.target.info[2] +
															key.substring(6),
															true);
					fo.writeString(b.toString());
					fo.flush();
					fo.close();
				}
				
				if (event.target.progress >= 1)
				{
					subm_loaded++;
					
					if (subm_loaded >= subm_toload)
					{
						if (whenfinished != null)
						{
							whenfinished();
						}
					}
				}

			default:
		}
	}
}