package entities;
import flixel.FlxG;
import entities.CapturePoint.PointSprite;
import haxe.xml.Fast;
import networkobj.NFlxSprite;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;

/**
 * ...
 * @author Ohmnivore
 */
class CapturePoint extends NSprite
{
	public static inline var NEUTRAL:Int = -1;
	static public var TEMPL:NTemplate;
	
	public var team:Int;
	public var teamtimers:Array<Int>;
	public var graphics:Array<String>;
	
	public function new(X:Float, Y:Float) 
	{
		team = NEUTRAL;
		teamtimers = [0, 0, 0, 0];
		graphics = [];
		setGraphic();
		
		super(X, Y, TEMPL, PointSprite);
		
		s.immovable = true;
	}
	
	public function setGraphic(Neutral:String = null, T1:String = null,
		T2:String = null, T3:String = null, T4:String = null):Void
	{
		if (Neutral == null)
			graphics[0] = "assets/images/flag_n.png";
		else
			graphics[0] = Neutral;
		
		if (T1 == null)
			graphics[1] = "assets/images/flag_g.png";
		else
			graphics[1] = T1;
		
		if (T2 == null)
			graphics[2] = "assets/images/flag_b.png";
		else
			graphics[2] = T2;
		
		if (T3 == null)
			graphics[3] = "assets/images/flag_y.png";
		else
			graphics[3] = T3;
		
		if (T4 == null)
			graphics[4] = "assets/images/flag_r.png";
		else
			graphics[4] = T3;
	}
	
	public function setTeam(T:Int):Void
	{
		team = T;
		
		teamtimers[team] = 0;
		
		setImage(0, graphics[team + 1]);
		
		Reflect.callMethod(Reg.gm, "setFlagTeam", [this, T]);
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setImage(PlayerID, graphics[team + 1]);
		
		setFields(PlayerID, ["immovable"], [true], false);
	}
	
	static public function makeFromXML(D:Fast):CapturePoint
	{
		return new CapturePoint(Std.parseInt(D.att.x), Std.parseInt(D.att.y));
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/flag_n.png", 0);
		NReg.registerTemplate(TEMPL);
	}
}

class PointSprite extends NFlxSprite
{
	public var point:CapturePoint;
	
	public function new(X:Float, Y:Float, GraphicString:String, Point:CapturePoint)
	{
		super(X, Y, GraphicString, Point);
		
		point = Point;
	}
	
	override public function update():Void 
	{
		FlxG.overlap(Reg.state.players, this, overlapPlayers);
		super.update();
		
		for (x in 0...3)
		{
			point.teamtimers[x] = point.teamtimers[x] - 1;
			
			if (point.teamtimers[x] < 0)
			{
				point.teamtimers[x] = 0;
			}
		}
	}
	
	private function overlapPlayers(P:Player, Point:PointSprite):Void
	{
		point.teamtimers[P.team] = point.teamtimers[P.team] + 2;
		
		if (point.teamtimers[P.team] >= 300 && point.team != P.team)
		{
			point.setTeam(P.team);
		}
	}
}