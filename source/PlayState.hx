package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	// Entity Related
	var player:Player;
	var gems:FlxTypedGroup<Gem>;

	// Level Related
	var tilemap:SetupTilemap;

	// UI Related
	var score:Int = 0;
	var scoreLabel:FlxText = null;
	var pausemenu:PauseMenu;
	var gameover:GameOver;

	public function new(lvl_id:Int = 0)
	{
		super();
		tilemap = new SetupTilemap(lvl_id);
	}

	override public function create()
	{
		super.create();

		// Add all tilemap layers
		add(tilemap.bg);
		add(tilemap.deco);
		add(tilemap.lvl);

		// Setup and Place level entities (from Objects layer)
		player = new Player();
		gems = new FlxTypedGroup<Gem>();
		tilemap.data.loadEntities(place_entities, "Objects");
		add(player);
		add(gems);

		// Level Setup
		bgColor = 0xFF47F3FF;
		FlxG.worldBounds.set(0, 0, tilemap.lvl.width, tilemap.lvl.height);
		FlxG.camera.setScrollBoundsRect(16, 0, tilemap.lvl.width - 32, tilemap.lvl.height);
		FlxG.camera.follow(player, PLATFORMER, 1);
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		tilemap.bg.scrollFactor.x = 0.3;

		// Scoreboard Setup
		scoreLabel = new FlxText(0, 0, FlxG.width, "Score: 0", 4);
		scoreLabel.setFormat(null, 16, FlxColor.RED, CENTER, OUTLINE, 0x131c1b);
		scoreLabel.scrollFactor.set(0, 0);
		add(scoreLabel);
	}

	function place_entities(entity:EntityData)
	{
		switch entity.name
		{
			case "Player":
				player.setPosition(entity.x, entity.y);

			case "Gems":
				gems.add(new Gem(entity.x + 1, entity.y));
		}
	}

	function collect(player:FlxObject, gem:FlxObject)
	{
		gem.kill();
		score += 1;
		scoreLabel.text = 'Score: $score'; // Update Sccore Text
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, tilemap.lvl); // Player colliding with Level
		FlxG.overlap(player, gems, collect); // Player overlaping Gems

		if (FlxG.keys.justPressed.ENTER)
		{
			pausemenu = new PauseMenu();
			openSubState(pausemenu);
		}

		if (score == gems.length)
		{
			gameover = new GameOver();
			openSubState(gameover);
		}
	}
}
