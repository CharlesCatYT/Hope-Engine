package achievements;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import lime.app.Application;

using StringTools;

#if FILESYSTEM
import sys.FileSystem;
import sys.io.File;
#end

typedef Achievement =
{
	var name:String;
	var desc:String;
	var hint:Null<String>;
	var iconAntiAliasing:Null<Bool>;
}

typedef AchInfo =
{
	var timeGained:String;
}

/**
 * All things achievements!
 */
class Achievements
{
	public static var achievements:Array<String> = [];
	public static var achievementsGet:Map<String, AchInfo> = new Map<String, AchInfo>();

	public static var camera:FlxCamera = null;

	static var prevAchTime:Float = 0;

	public static function init():Void
	{
		#if ACHIEVEMENTS_FEATURE
		#if FILESYSTEM
		var listPath = Sys.getCwd() + Paths.achievementList();

		if (!FileSystem.exists(listPath))
			Sys.exit(0);
		else
		{
			var list = File.getContent(listPath);
			var items = list.trim().split('\n');

			for (achievement in items)
				achievements.push(achievement.trim());
		}
		#else
		if (!Assets.exists(Paths.achievementList()))
			Application.current.window.close();
		else
		{
			var list = Assets.getText(Paths.achievementList());
			var items = list.trim().split('\n');

			for (achievement in items)
				achievements.push(achievement.trim());
		}
		#end

		if (FlxG.save.data.achievementsGet == null)
			FlxG.save.data.achievementsGet = achievementsGet;

		if (!achievements.contains('cheater'))
		{
			Application.current.window.alert("..Did you really just look through the files and remove \"Cheater\" in the list to feel no guilt? Shame on you.",
				"Achievement Missing!");
			Application.current.window.close();
		}

		load();
		save();

		FlxG.log.add("Achievements initialized!");
		#end
	}

	public static function load():Void
	{
		#if ACHIEVEMENTS_FEATURE
		achievementsGet = FlxG.save.data.achievementsGet;
		FlxG.log.add("Achievements loaded!");
		#end
	}

	public static function save():Void
	{
		#if ACHIEVEMENTS_FEATURE
		FlxG.save.data.achievementsGet = achievementsGet;

		FlxG.save.flush();

		FlxG.log.add("Achievements saved!");
		#end
	}

	public static function has(achievementId:String):Bool
		return #if ACHIEVEMENTS_FEATURE achievementsGet.exists(achievementId) #else false #end;

	public static function give(achievementId:String):Void
	{
		#if ACHIEVEMENTS_FEATURE
		if (!achievementsGet.exists(achievementId))
		{
			alert(achievementId);
			achievementsGet.set(achievementId, {timeGained: Date.now().toString()});
			save();
			load();
		}
		#end
	}

	public static function take(achievementId:String):Void
	{
		#if ACHIEVEMENTS_FEATURE
		if (achievementsGet.exists(achievementId))
		{
			achievementsGet.remove(achievementId);
			save();
			load();
		}
		#end
	}

	public static function takeAll():Void
	{
		#if ACHIEVEMENTS_FEATURE
		achievementsGet.clear();
		save();
		load();
		#end
	}

	public static function alert(achID:String)
	{
		#if ACHIEVEMENTS_FEATURE
		#if FILESYSTEM
		var achFile = File.getContent(Sys.getCwd() + Paths.achievement(achID));
		#else
		var achFile = Assets.getText(Paths.achievement(achID));
		#end

		var actualAch:Achievement = cast Json.parse(achFile);

		var sprGroup = new FlxSpriteGroup();
		var sound = FlxG.sound.play(Paths.sound("titleShoot"));

		var bg = new FlxSprite().makeGraphic(448, 128, FlxColor.BLACK);
		sprGroup.add(bg);

		var iconBG = new FlxSprite(25, 25);
		iconBG.frames = Paths.getSparrowAtlas("achievementBox", "preload");
		iconBG.animation.addByPrefix("idle", "box", 24);
		iconBG.animation.play('idle');
		iconBG.setGraphicSize(Std.int(bg.height - 50));
		iconBG.updateHitbox();
		iconBG.y = (bg.height / 2) - (iconBG.height / 2);
		iconBG.antialiasing = true;
		sprGroup.add(iconBG);

		var icon = new FlxSprite().loadGraphic(Paths.image("achievements/" + achID.trim(), "preload"));
		icon.setGraphicSize(Std.int(iconBG.width));
		icon.updateHitbox();
		icon.x = iconBG.x + (iconBG.width / 2) - (icon.width / 2);
		icon.y = iconBG.y + (iconBG.height / 2) - (icon.height / 2);
		icon.antialiasing = actualAch.iconAntiAliasing != null ? actualAch.iconAntiAliasing : true;
		sprGroup.add(icon);

		var name = new FlxText(0, 0, actualAch.name);
		name.setFormat("VCR OSD Mono", 18, FlxColor.WHITE);
		name.x = icon.x + icon.width + 25;
		name.fieldWidth = bg.width - name.x - 25;
		name.y = 25;
		sprGroup.add(name);

		var desc = new FlxText(0, 0, actualAch.desc);
		desc.setFormat("VCR OSD Mono", 16, FlxColor.WHITE);
		desc.x = icon.x + icon.width + 25;
		desc.fieldWidth = bg.width - desc.x - 25;
		desc.y = name.y + name.height + 12.5;
		sprGroup.add(desc);

		var flash = new FlxSprite().makeGraphic(Std.int(sprGroup.width), Std.int(sprGroup.height), FlxColor.WHITE);
		sprGroup.add(flash);

		sprGroup.x = FlxG.width - sprGroup.width - 50;
		sprGroup.y = 50;
		sprGroup.scrollFactor.set();

		var where = FlxG.state.subState != null ? FlxG.state.subState : FlxG.state;

		where.add(sprGroup);

		if (camera != null)
			sprGroup.cameras = [camera];

		FlxTween.tween(flash, {alpha: 0}, 2, {
			onComplete: function(twn:FlxTween)
			{
				sprGroup.remove(flash);
			}
		});

		FlxTween.tween(sprGroup, {alpha: 0}, 1, {
			startDelay: (sound.length / 2000) - 2,
			onComplete: function(twn:FlxTween)
			{
				sprGroup.kill();
				sprGroup.destroy();
			}
		});
		#end
	}
}
