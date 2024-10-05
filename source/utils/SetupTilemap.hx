package utils;

import entities.Gem;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;
import states.PlayState;

class SetupTilemap
{
	public var terrain:FlxTilemap; // Level Terrain
	public var platforms:FlxTilemap;

	var curr_state:PlayState;
	var plat_tiles:Array<Int>;

	public function new(state:PlayState, lvl_id:Int = 0)
	{
		// Load Tilemap from .json file and gets level data from ogmo file
		var data:FlxOgmo3Loader = new FlxOgmo3Loader(AssetPaths.tilemaps__ogmo, "assets/data/level" + lvl_id + ".json");

		// Get level data
		var lvl_type:String = data.getLevelValue("lvl_type");
		var scroll_fact:Float = data.getLevelValue("scroll_factor");

		// Load Looping Background and Tilesets (Carefull of Layer Names)
		var bg:FlxBackdrop = new FlxBackdrop("assets/images/environement/bg_" + lvl_type + ".png", X, 0, 0);
		var deco:FlxTilemap = new FlxTilemap();
		terrain = new FlxTilemap();
		platforms = new FlxTilemap();
		deco = data.loadTilemap("assets/images/environement/deco_" + lvl_type + ".png", "Decoration");
		terrain = data.loadTilemap("assets/images/environement/tileset_" + lvl_type + ".png", "Ground");
		platforms = data.loadTilemap("assets/images/environement/tileset_" + lvl_type + ".png", "Platforms");

		// Load all level entities and apply some settings
		curr_state = state;
		data.loadEntities(place_entities, "Objects");
		platforms.allowCollisions = FlxDirectionFlags.CEILING;
		bg.scrollFactor.x = scroll_fact;

		// Add tilemaps and entities
		state.add(bg);
		state.add(deco);
		state.add(terrain);
		state.add(platforms);
		state.add(state.player);
		state.add(state.gems);
	}

	function place_entities(entity:EntityData)
	{
		switch entity.name
		{
			case "Player":
				curr_state.player.setPosition(entity.x, entity.y);

			case "Gems":
				curr_state.gems.add(new Gem(entity.x + 1, entity.y));
		}
	}
}
