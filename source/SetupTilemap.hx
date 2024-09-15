package;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class SetupTilemap
{
	// Ogmo data
	public var data:FlxOgmo3Loader;

	// Tilemap layers
	public var bg:FlxTilemap;
	public var deco:FlxTilemap;
	public var lvl:FlxTilemap;

	public function new(lvl_id:Int = 0)
	{
		// Tilemaps Setup
		bg = new FlxTilemap();
		deco = new FlxTilemap();
		lvl = new FlxTilemap();

		// Load Tilemap from .json file and gets info from ogmo file
		data = new FlxOgmo3Loader(AssetPaths.tilemaps__ogmo, "assets/data/level" + lvl_id + ".json");

		switch lvl_id
		{
			case 1:
				// Load the Tilesets (carefull of layer names)
				bg = data.loadTilemap(AssetPaths.bg_sunny__png, "BackgroundFar");
				deco = data.loadTilemap(AssetPaths.deco_sunny__png, "BackgroundClose");
				lvl = data.loadTilemap(AssetPaths.tileset_sunny__png, "Ground");
				lvl.setTileProperties(7, CEILING);
				lvl.setTileProperties(11, CEILING);
		}
	}
}
