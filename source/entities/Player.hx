package entities;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import utils.InputKeys;

class Player extends FlxSprite
{
	// Player Stats
	final SPEED:Float = 100;
	final JUMP_STRENGTH:Float = 220; // Y speed of the jump
	final GRAVITY:Float = 800;
	final JUMP_LENGTH:Float = 0.2; // Length until holding jump doesn't work anymore
	final COYOTE_LENGTH:Float = 0.15; // The amount of time where you'll still be able to jump after falling off a ledge
	final JUMP_BUFFER_LENGTH:Float = 0.1; // Time before landing where a jump press is still taken into account
	final SQUASH_SPEED:Int = 10; // Squash/stretch speed
	final FALLOFF_LENGTH:Float = 0.1; // Time where you fall through platforms

	var is_grounded:Bool = false;
	var was_grounded:Bool = false; // Grounded state from previous update cycle
	var is_jumping:Bool = false; // Not the same as !is_grounded
	var jump_timer:FlxTimer; // Timer that takes care of the jump lenght
	var coyote_time:Float; // The amount of time left before you can't coyote jump anymore
	var jump_buffer_time:Float;
	var falloff_timer:Float = 0; // Amount time left before you collide with platforms again

	public var is_falling_off:Bool = false; // Allows to check if player should fall off platform

	public function new(xPos:Float = 0, yPos:Float = 0)
	{
		super(xPos, yPos);

		// Load player graphic and setup collision box
		loadGraphic(AssetPaths.playerspr__png, true, 33, 32);
		width = 15;
		height = 20;
		offset.set(9, 12);
		origin.set(16, 32);

		// Setup for player animations
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		animation.add("idle", [6, 7, 8, 9], 6, false);
		animation.add("jump", [10], 6, false);
		animation.add("down", [11], 6, false);
		animation.add("run", [0, 1, 2, 3, 4, 5], 7, false);

		// Player physics setup
		drag.x = SPEED * 8;
		acceleration.y = GRAVITY;
		maxVelocity.set(100, GRAVITY);

		jump_timer = new FlxTimer();
	}

	function handle_movement()
	{
		// Handles Inputs
		var left:Bool = InputKeys.is_left_pressed();
		var right:Bool = InputKeys.is_right_pressed();

		// Takes care of movement, facing direction and animations
		if (right && left || !right && !left)
		{
			if (is_grounded)
			{
				animation.play("idle");
			}
		}
		else if (right || left)
		{
			facing = left ? LEFT : RIGHT;
			if (is_grounded)
			{
				if (velocity.x != 0)
				{
					animation.play("run");
				}
				else
				{
					animation.play("idle");
				}
			}
			velocity.x = left ? -SPEED : SPEED;
		}
	}

	function handle_jump(elapsed:Float)
	{
		// Checks if you're touching the floor
		is_grounded = isTouching(FLOOR);

		if (is_grounded)
		{
			// Applies the ground squash only if you just landed on the ground
			if (!was_grounded)
			{
				scale.set(1.35, 0.7);
			}

			coyote_time = COYOTE_LENGTH; // Reset coyote time when landing
		}
		else
		{
			// Handles jumping and falling animations
			if (velocity.y <= 0)
			{
				animation.play("jump");
			}
			else
			{
				animation.play("down");
			}

			coyote_time -= elapsed;
		}

		was_grounded = is_grounded; // Retrieves grounded state from last tick

		if (InputKeys.is_up_pressed(true))
		{
			jump_buffer_time = JUMP_BUFFER_LENGTH;
		}

		// Checks if you can jump, then allows it if you can
		if (jump_buffer_time >= 0)
		{
			jump_buffer_time -= elapsed;

			if (coyote_time > 0)
			{
				scale.set(0.75, 1.5);
				is_jumping = true;
				coyote_time = 0;
			}
		}

		if (is_jumping)
		{
			// Applies the jump physics but cancels them if you let go of the jump button or bump into a ceiling or the jump_timer runs out
			if (!jump_timer.active)
			{
				jump_timer.start(JUMP_LENGTH, end_jump, 1);
			}

			velocity.y = -JUMP_STRENGTH;

			if (!InputKeys.is_up_pressed() || isTouching(CEILING))
			{
				is_jumping = false;
			}
		}
		else
		{
			// Resets sprite scale from squash and stretch
			scale.x = FlxMath.lerp(scale.x, 1, SQUASH_SPEED * elapsed);
			scale.y = FlxMath.lerp(scale.y, 1, SQUASH_SPEED * elapsed);
		}
	}

	function end_jump(timer:FlxTimer)
	{
		is_jumping = false;
	}

	function handle_fall_off(elapsed:Float)
	{
		var is_down_pressed:Bool = InputKeys.is_down_pressed();

		if (is_down_pressed || falloff_timer > 0)
		{
			// Prevents player from holding key then walking onto a plateform and falling off
			if (is_grounded)
			{
				if (is_down_pressed)
				{
					falloff_timer = FALLOFF_LENGTH;
				}
				else
				{
					falloff_timer = 0;
				}
			}
			falloff_timer -= elapsed;
			is_falling_off = true; // Play will fall off platforms
		}
		else
		{
			is_falling_off = false; // Play will stay on platforms
		}
	}

	override public function update(elapsed:Float)
	{
		handle_jump(elapsed);
		handle_fall_off(elapsed);
		handle_movement();

		super.update(elapsed);
	}
}
