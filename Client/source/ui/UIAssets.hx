package ui;

import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIDropDownMenu.FlxUIDropDownHeader;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUITypedButton.FlxUITypedButton;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxStringUtil;

/**
 * ...
 * @author Ohmnivore
 */

class UIAssets
{
	static public var CHROME:String = "assets/images_ui/chrome.png";
	static public var BUTTON:String = "assets/images_ui/button.png";
	static public var BUTTON_THIN:String = "assets/images_ui/button_thin.png";
	static public var TAB:String = "assets/images_ui/tab.png";
	static public var TAB_BACK:String = "assets/images_ui/tab_back.png";
	
	static public function setBtnGraphic(Btn:FlxUIButton):Void
	{
		Btn.loadGraphicSlice9([UIAssets.BUTTON], 80, 20, []);
		Btn.resize(80, 20);
		Btn.label.color = 0xffffffff;
		Btn.over_color = 0xffffffff;
		Btn.down_color = 0xffffffff;
		Btn.up_color = 0xffffffff;
		Btn.label.setBorderStyle(FlxText.BORDER_OUTLINE);
		Btn.label.borderColor = 0xff000000;
	}
	
	static public function createHeader(Width:Int = 120):FlxUIDropDownHeader
	{
		var btn:FlxUISpriteButton;
		btn = new FlxUISpriteButton(0, 0, new FlxSprite(0, 0, FlxUIAssets.IMG_DROPDOWN));
		btn.loadGraphicSlice9([UIAssets.BUTTON_THIN], 80, 20, 
								[FlxStringUtil.toIntArray(FlxUIAssets.SLICE9_BUTTON)],
								FlxUI9SliceSprite.TILE_NONE, -1, false, FlxUIAssets.IMG_BUTTON_SIZE, FlxUIAssets.IMG_BUTTON_SIZE);
		return new FlxUIDropDownHeader(Width, null, null, btn);
	}
	
	static public function getStepperPlus():FlxUITypedButton<FlxSprite>
	{
		var ButtonPlus:FlxUITypedButton<FlxSprite> = new FlxUITypedButton<FlxSprite>(0, 0);
		ButtonPlus.loadGraphicSlice9([UIAssets.BUTTON_THIN], 21, 21, [FlxStringUtil.toIntArray(FlxUIAssets.SLICE9_BUTTON_THIN)], FlxUI9SliceSprite.TILE_NONE, -1, false, FlxUIAssets.IMG_BUTTON_SIZE, FlxUIAssets.IMG_BUTTON_SIZE);
		ButtonPlus.label = new FlxSprite(0, 0, FlxUIAssets.IMG_PLUS);
		
		return ButtonPlus;
	}
	
	static public function getStepperMinus():FlxUITypedButton<FlxSprite>
	{
		var ButtonPlus:FlxUITypedButton<FlxSprite> = new FlxUITypedButton<FlxSprite>(0, 0);
		ButtonPlus.loadGraphicSlice9([UIAssets.BUTTON_THIN], 21, 21, [FlxStringUtil.toIntArray(FlxUIAssets.SLICE9_BUTTON_THIN)], FlxUI9SliceSprite.TILE_NONE, -1, false, FlxUIAssets.IMG_BUTTON_SIZE, FlxUIAssets.IMG_BUTTON_SIZE);
		ButtonPlus.label = new FlxSprite(0, 0, FlxUIAssets.IMG_MINUS);
		
		return ButtonPlus;
	}
	
	static public function getTabBackground():FlxUI9SliceSprite
	{
		return new FlxUI9SliceSprite(0, 0, UIAssets.CHROME, new Rectangle(0, 0, 200, 200));
	}
	
	static public function getTab(Name:String):FlxUIButton
	{
		var fb:FlxUIButton = new FlxUIButton(0, 0, Name);
		
		//default style:
		fb.up_color = 0xffffff;
		fb.down_color = 0xffffff;
		fb.over_color = 0xffffff;
		fb.up_toggle_color = 0xffffff;
		fb.down_toggle_color = 0xffffff;
		fb.over_toggle_color = 0xffffff;
		
		fb.label.color = 0xFFFFFF;
		fb.label.setBorderStyle(FlxText.BORDER_OUTLINE);
		
		fb.id = Name;
		
		//load default graphics
		var graphic_ids:Array<String> = [UIAssets.TAB_BACK, UIAssets.TAB_BACK, UIAssets.TAB_BACK, UIAssets.TAB, UIAssets.TAB, UIAssets.TAB];
		var slice9tab:Array<Int> = FlxStringUtil.toIntArray(FlxUIAssets.SLICE9_TAB);
		var slice9_ids:Array<Array<Int>> = [slice9tab, slice9tab, slice9tab, slice9tab, slice9tab, slice9tab];
		fb.loadGraphicSlice9(graphic_ids, 0, 0, slice9_ids, FlxUI9SliceSprite.TILE_NONE, -1, true);
		
		return fb;
	}
}