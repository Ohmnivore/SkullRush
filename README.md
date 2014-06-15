# SkullRush
SkullRush is an open-source (GPLv3) 2D online multiplayer shooter. Think of it as Quake meets Mario.

This is my attempt at making the game I have been envisioning for a long time. While there exist
other games of the same type, I've found none to be particularly alike to the experience I wanted.
Most importantly, SkullRush can be extensively modded. In short, the client acts as a canvas of sorts, and the server has almost complete control over the game's graphics, sounds, and logic. This means that there's out of the box support for custom game modes, custom game entities, custom graphics (that can even override the default game graphics if you want) and much more. Mod it enough and you can make into a completely different game, which is a good thing of course.

At the moment the client source code is a mess. I'll clean it up one day.

### Links:
* [Website](http://ohmnivore.github.io/)
* [Download](http://skullrush.elementfx.com/smf/index.php?topic=2.0)
* [Forums, Guides, and tutorials](http://skullrush.elementfx.com/smf/index.php)
* [Server browser](http://ms.skullrush.elementfx.com/)

![alt text](https://github.com/Ohmnivore/SkullRush/raw/master/SCREENSHOT.png "")

# Graphic assets by:
* Eris from [OpenGameArt](http://opengameart.org/content/sci-fi-platform-tiles): https://github.com/Ohmnivore/SkullRush/blob/master/Shared/assets/images/indoor_tileset.png and https://github.com/Ohmnivore/SkullRush/blob/master/Shared/assets/images/background.png
* Sam Driver from [Salt Games](http://www.saltgames.com/): https://github.com/Ohmnivore/SkullRush/blob/master/Shared/assets/images/outdoor_tileset.png
* Myself

# Powered by:
* [Haxe](http://haxe.org/)
* [HaxeNet](https://github.com/Ohmnivore/HaxeNet)
* [HaxeFlixel](http://haxeflixel.com/)
* [flixel-addons](https://github.com/HaxeFlixel/flixel-addons)
* [flixel-ui](https://github.com/HaxeFlixel/flixel-ui)
* [lime](https://github.com/openfl/lime)
* [openfl](http://www.openfl.org/)
* [msignal](https://github.com/massiveinteractive/msignal)
* [mloader](https://github.com/massiveinteractive/mloader)
* [crashdumper](https://github.com/larsiusprime/crashdumper)
* [FlashDevelop](http://www.flashdevelop.org/)
* [Ogmo Editor](http://www.ogmoeditor.com/)
* [TileSetter](https://github.com/Ohmnivore/TileSetter)
* [aria2](https://github.com/tatsuhiro-t/aria2)
* [FBZip](http://www.freebyte.com/fbzip/)


# TODO:

## Engine:
* Plugins
* Spectate
* Interactive events:
 * Meteorite strike
 * Destruction events
 * Lasers
 * Radiation
 * Levers


## Gameplay:
* New maps
* custom tiles (spikes and such things)


## Bugs:
* Fix annoying LAN server discovery bug


## Assets:
* Make background more dynamic
* Find music and sounds


## Masterserver:
* route through HTTPS
* use params instead of url variables
* CSS styling and background
