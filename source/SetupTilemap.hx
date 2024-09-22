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

		switch lvl_id
		{
			case 1:
				// Load Looping Background
				bg = new FlxBackdrop(AssetPaths.bg_sunny__png, X, 0, 0);
				bg.scrollFactor.x = 0.3;
				// Load the Tilesets (carefull of layer names)
				deco = data.loadTilemap(AssetPaths.deco_sunny__png, "Decoration");
				lvl = data.loadTilemap(AssetPaths.tileset_sunny__png, "Ground");
				// Setup jump through platforms
				lvl.setTileProperties(7, CEILING);
				lvl.setTileProperties(11, CEILING);
			case 2:
				// Load Looping Background
				bg = new FlxBackdrop(AssetPaths.bg_forest__png, X, 0, 0);
				bg.scrollFactor.x = 0.2;
				// Load the Tilesets (carefull of layer names)
				deco = data.loadTilemap(AssetPaths.deco_forest__png, "Decoration");
				lvl = data.loadTilemap(AssetPaths.tileset_forest__png, "Ground");
				// Setup jump through platforms
				for (t in [24, 32, 33, 34, 35, 36])
				{
					lvl.setTileProperties(t, CEILING);
				}
		}
	}
}
