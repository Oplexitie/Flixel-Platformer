package states;

import entities.Gem;
import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import states.substates.GameOver;
import states.substates.PauseMenu;
import ui.PlayUI;
import utils.SetupTilemap;

class PlayState extends FlxState
{
	// Entity Related
	public var player:Player;
	public var gems:FlxTypedGroup<Gem>;

	// Level Related
	var curr_level:Int = 0;
	var tilemap:SetupTilemap;

	// UI Related
	var ui:PlayUI;

	// SubStates
	var pausemenu:PauseMenu;
	var gameover:GameOver;

	public function new(lvl_id:Int = 0)
	{
		super();
		curr_level = lvl_id;
	}

	override public function create()
	{
		super.create();

		// Setup entities and tilemaps
		player = new Player();
		gems = new FlxTypedGroup<Gem>();
		tilemap = new SetupTilemap(this, curr_level);

		// Level Setup
		FlxG.worldBounds.set(0, 0, tilemap.terrain.width, tilemap.terrain.height);
		FlxG.camera.setScrollBoundsRect(16, 0, tilemap.terrain.width - 32, tilemap.terrain.height);
		FlxG.camera.follow(player, PLATFORMER, 1);
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		// UI Setup
		ui = new PlayUI();
		add(ui);
	}

	function col_platform()
	{
		if (!player.is_falling_off)
		{
			FlxG.collide(player, tilemap.platforms); // Player colliding with Platforms
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, tilemap.terrain); // Player colliding with Level
		col_platform();
		FlxG.overlap(player, gems, ui.collect); // Player overlaping Gems

		if (FlxG.keys.justPressed.ENTER)
		{
			pausemenu = new PauseMenu();
			openSubState(pausemenu);
		}

		if (ui.score == gems.length)
		{
			gameover = new GameOver(curr_level);
			openSubState(gameover);
		}
	}
}
