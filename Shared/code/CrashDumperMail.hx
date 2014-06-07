package ;
import crashdumper.CrashDumper;
import sys.io.Process;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import haxe.io.Eof;

/**
 * ...
 * @author Ohmnivore
 */
class CrashDumperMail extends CrashDumper
{
	public var from:String;
	public var to:String;
	public var smtp_dom:String;
	public var helo_dom:String;
	
	public static inline var PATH_APPDATA:String = "%APPDATA%";		//your app's applicationStorageDirectory
	public static inline var PATH_DOC:String = "%DOCUMENTS%";		//the user's Documents directory
	
	private static var endl:String = "\n";
	private static var sl:String = "/";
	
	public function new(sessionId_:String,?path_:String,closeOnCrash_:Bool=true,?crashMethod_:CrashDumper->Void) 
	{
		super(sessionId_, path_, closeOnCrash_, crashMethod_);
	}
	
	public function setMail(To:String, SMTP_dom:String, HELO_dom:String = null, From:String = "crash@crash.com"):Void
	{
		to = To;
		smtp_dom = SMTP_dom;
		helo_dom = HELO_dom;
		from = From;
	}
	
	private function sendMail(Subject:String, Message:String):Void
	{
		var p:Process = new Process("mailsend.exe", [
			'-f',
			from,
			'-t',
			to,
			'-smtp',
			smtp_dom,
			'-d',
			helo_dom,
			'-sub',
			Subject,
			'-M',
			Message
			]);
		
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
	
	override private function onErrorEvent(e:Dynamic):Void 
	{
		var pathLog:String = path + "log" + sl;						//  path/to/log/
		var pathLogErrors:String = pathLog + sl + "errors" + sl;	//  path/to/log/errors/
		
		var errorMessage:String = 
			system.summary() + endl + 		//we separate the output into three blocks so it's easy to override them with your own customized output
			sessionStr() + endl + 
			crashStr(e.error) + endl;
		
		#if sys
			var sub:String = "Crash";
			var msg:String = "";
			
			if (!FileSystem.exists(pathLog))
			{
				FileSystem.createDirectory(pathLog);
			}
			if (!FileSystem.exists(pathLogErrors))
			{
				FileSystem.createDirectory(pathLogErrors);
			}
			
			var logdir:String = session.id + "_CRASH";							//directory name for this crash
			sub = logdir;
			
			var counter:Int = 0;
			var failsafe:Int = 999;
			while (FileSystem.exists(pathLogErrors + logdir) && failsafe > 0)
			{
				//if the session ID is not unique for some reason, append numbers until it is
				logdir = session.id + "_CRASH_" + counter;
				counter++;
				failsafe--;
			}
			
			FileSystem.createDirectory(pathLogErrors + logdir);
			
			if (FileSystem.exists(pathLogErrors + logdir))
			{
				//write out the error message
				var f:FileOutput = File.write(pathLogErrors + logdir + sl + "_error.txt");
				f.writeString(errorMessage);
				f.close();
				msg += errorMessage;
				
				//write out all our associated game session files
				for (filename in session.files.keys())
				{
					var filecontent:String = session.files.get(filename);
					if (filecontent != "" && filecontent != null)
					{
						f = File.write(pathLogErrors + logdir + sl + filename);
						f.writeString(filecontent);
						f.close();
						msg += "\n***\n";
						msg += filename + ":\n";
						msg += filecontent;
					}
				}
			}
			
			sendMail(sub, msg);
		#end
		
		if (closeOnCrash)
		{
			#if sys
				Sys.exit(1);
			#end
		}
		else
		{
			if (crashMethod != null)
			{
				crashMethod(this);
			}
		}
	}
	
}