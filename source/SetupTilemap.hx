package;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class SetupTilemap
{
	// Ogmo data
	public var data:FlxOgmo3Loader;

	// Tilemap layers
	public var bg:FlxBackdrop;
	public var deco:FlxTilemap;
	public var lvl:FlxTilemap;

	public function new(lvl_id:Int = 0)
	{
		// Tilemaps Setup
		deco = new FlxTilemap();
		lvl = new FlxTilemap();

		// Load Tilemap from .json file and gets info from ogmo file
		data = new FlxOgmo3Loader(AssetPaths.tilemaps__ogmo, "assets/data/level" + lvl_id + ".json");

		var lvl_type:String = data.getLevelValue("lvl_type");

		// Load Looping Background
		bg = new FlxBackdrop("assets/images/environement/bg_" + lvl_type + ".png", X, 0, 0);
		bg.scrollFactor.x = data.getLevelValue("scroll_factor");

		// Load the Tilesets (carefull of layer names)
		deco = data.loadTilemap("assets/images/environement/deco_" + lvl_type + ".png", "Decoration");
		lvl = data.loadTilemap("assets/images/environement/tileset_" + lvl_type + ".png", "Ground");

		// Setup jump through platforms
		var plat_tiles:Array<Int> = data.getLevelValue("plat_tiles");
		for (t in plat_tiles)
		{
			lvl.setTileProperties(t, CEILING);
		}
	}
}
