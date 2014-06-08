package ;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class WeaponHUD extends FlxSpriteGroup
{
	static public inline var PADDING:Int = 3;
	
	private var icons:Map<Int, FlxSprite>;
	private var hiders:Map<Int, FlxSprite>;
	private var background:FlxSprite;
	
	private var selector:FlxSprite;
	
	public function new(X:Float) 
	{
		super(X, 0);
		scrollFactor.set();
		
		background = new FlxSprite();
		add(background);
		selector = new FlxSprite();
		add(selector);
		icons = new Map<Int, FlxSprite>();
		hiders = new Map<Int, FlxSprite>(); 
	}
	
	public function addIcon(Slot:Int, GraphicKey:String):Void
	{
		var slot:FlxText = new FlxText(0, 0, 20, Std.string(Slot));
		slot.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
		slot.scrollFactor.set();
		
		var icon:FlxSprite = new FlxSprite(10, 0, Assets.getImg(GraphicKey));
		icon.scrollFactor.set();
		
		var hider:FlxSprite = new FlxSprite(0, 0);
		hider.makeGraphic(Std.int(icon.x + icon.width), Std.int(icon.height) + PADDING, 0x99000000);
		hider.scrollFactor.set();
		
		if (Slot > 1)
		{
			var predecessor:FlxSprite = icons.get(Slot - 1);
			slot.y = predecessor.y + slot.height - y + PADDING;
			icon.y = predecessor.y + icon.height - y + PADDING;
			hider.y = predecessor.y + hider.height - y;
		}
		
		add(slot);
		add(icon);
		add(hider);
		
		icons.set(Slot, icon);
		hiders.set(Slot, hider);
		
		background.makeGraphic(Std.int(width), Std.int(height - PADDING), 0x99000000);
		
		FlxSpriteUtil.screenCenter(this, false, true);
	}
	
	public function selectIcon(Slot:Int):Void
	{
		var icon:FlxSprite = icons.get(Slot);
		if (icon == null) return;
		
		selector.x = x;
		selector.y = icon.y;
		
		selector.makeGraphic(Std.int(icon.x + icon.width - x), Std.int(icon.height + PADDING), 0x99990000);
	}
	
	public function unhideIcon(Slot:Int):Void
	{
		var hider:FlxSprite = hiders.get(Slot);
		hider.visible = false;
	}
	
	public function hideIcon(Slot:Int):Void
	{
		var hider:FlxSprite = hiders.get(Slot);
		hider.visible = true;
	}
	
	public function hideAllIcons():Void
	{
		for (hider in hiders.iterator())
		{
			hider.visible = true;
		}
	}
	
}