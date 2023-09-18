package;

<<<<<<< HEAD
import editors.CreditsEditor;
=======
>>>>>>> upstream
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
<<<<<<< HEAD
#if FILESYSTEM
import sys.FileSystem;
import sys.io.File;
#end

typedef CreditCategory =
{
	var categoryName:String;
	var categoryItems:Array<Credit>;
}

typedef Credit =
{
	var name:String;
	var desc:String;
	@:optional var link:Null<String>;
	@:optional var tint:Null<String>;
	@:optional var icon:Null<String>;
	@:optional var iconAntialiasing:Null<Bool>;
	@:optional @:noCompletion var funnyMod:String;
}
=======
>>>>>>> upstream

class CreditsState extends MusicBeatState
{
	var alphabets:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var allTheShit:Array<Array<String>> = [];

	var descBackground:FlxSprite;
	var descriptionShit:FlxText;
	var menuBG:FlxBackdrop;

	override function create()
	{
<<<<<<< HEAD
		if (Paths.priorityMod != "hopeEngine")
		{
			if (Paths.exists(Paths.state("CreditsState")))
			{
				Paths.setCurrentMod(Paths.priorityMod);
				FlxG.switchState(new CustomState("CreditsState", CREDITS));

				DONTFUCKINGTRIGGERYOUPIECEOFSHIT = true;
				return;
			}
		}

		if (Paths.priorityMod == "hopeEngine")
			Paths.setCurrentMod(null);
		else
			Paths.setCurrentMod(Paths.priorityMod);

=======
>>>>>>> upstream
		#if desktop
		DiscordClient.changePresence("Credits", null);
		#end

		#if FILESYSTEM
		Paths.destroyCustomImages();
		Paths.clearCustomSoundCache();
		#end

<<<<<<< HEAD
		menuBG = new FlxBackdrop(Paths.image('credBG'), Y);
=======
		menuBG = new FlxBackdrop(Paths.image('credBG'), 1, 1, false);
>>>>>>> upstream
		menuBG.screenCenter(X);
		menuBG.antialiasing = true;
		menuBG.color = 0xff3e3040;
		add(menuBG);

		alphabets = new FlxTypedGroup<Alphabet>();
		add(alphabets);

		descBackground = new FlxSprite().makeGraphic(Std.int((FlxG.width * 0.85) + 8), 72, 0xFF000000);
		descBackground.alpha = 0.6;
		descBackground.screenCenter(X);
		descBackground.visible = false;
		add(descBackground);

		descriptionShit = new FlxText(0, FlxG.height - 80, FlxG.width * 0.85, " ");
		descriptionShit.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionShit.screenCenter(X);
		descriptionShit.borderSize = 3;
		add(descriptionShit);

		descBackground.setPosition(descriptionShit.x - 4, descriptionShit.y - 4);

<<<<<<< HEAD
		var credits:Array<CreditCategory> = cast Json.parse(Assets.getText(Paths.json('credits')));
		var creditsGet:Array<CreditCategory> = [];

		var prevMod = Paths.currentMod;

		#if (FILESYSTEM && MODS_FEATURE)
		for (mod in FileSystem.readDirectory('mods'))
		{
			Paths.setCurrentMod(mod);

			if (Paths.checkModLoad(mod) && Paths.exists(Paths.modJson('credits')))
			{
				var cred:Array<CreditCategory> = cast Json.parse(File.getContent(Paths.json('credits')));


				for (cat in cred)
				{
					for (info in cat.categoryItems)
						info.funnyMod = mod;

					creditsGet.push(cat);
				}
			}
		}
		#end

		Paths.setCurrentMod(null);
		creditsGet.reverse();

		for (cat in creditsGet)
			credits.insert(0, cat);
=======
		var credits:Array<Dynamic> = Json.parse(Assets.getText(Paths.json('credits')));
>>>>>>> upstream

		for (i in 0...credits.length)
		{
			var curCategory = credits[i];

			var catLabel:Alphabet = new Alphabet(0, 0, curCategory.categoryName, true);
			catLabel.isMenuItem = true;
			catLabel.targetY = alphabets.members.length - 1;
			catLabel.y = catLabel.getTargetY();
			catLabel.screenCenter(X);
			alphabets.add(catLabel);

			allTheShit.push([curCategory.categoryName, "", ""]);

<<<<<<< HEAD
			for (i2 in 0...curCategory.categoryItems.length)
=======
			var catItems:Array<Dynamic> = curCategory.categoryItems;
			for (i2 in 0...catItems.length)
>>>>>>> upstream
			{
				var curCredit = curCategory.categoryItems[i2];

				var credLabel:Alphabet = new Alphabet(0, 0, curCredit.name, false);
				credLabel.isMenuItem = true;
				credLabel.targetY = alphabets.members.length - 1;
				credLabel.y = credLabel.getTargetY();
				credLabel.screenCenter(X);
				alphabets.add(credLabel);

<<<<<<< HEAD
				if (curCredit.icon != null)
				{
					Paths.setCurrentMod(null);
					if (curCredit.funnyMod != null)
						Paths.setCurrentMod(curCredit.funnyMod);
					var icon = new FlxSprite().loadGraphic(Paths.image("creditIcons/" + curCredit.icon));
					icon.x = credLabel.width + 25;
					icon.y = (credLabel.height / 2) - (icon.height / 2);
					icon.antialiasing = true;
					credLabel.add(icon);

					credLabel.screenCenter(X);
				}

=======
>>>>>>> upstream
				allTheShit.push([
					curCredit.name,
					(curCredit.desc == null ? "" : curCredit.desc),
					(curCredit.link == null ? "" : curCredit.link),
<<<<<<< HEAD
					(curCredit.tint == null ? "3e3040" : curCredit.tint),
					(curCredit.icon == null ? "" : curCredit.icon),
=======
					(curCredit.tint == null ? "3e3040" : curCredit.tint)
>>>>>>> upstream
				]);
			}
		}

<<<<<<< HEAD
		Paths.setCurrentMod(prevMod);

=======
>>>>>>> upstream
		changeSelection();
		if (alphabets.members[curSelected].isBold)
			changeSelection(1);

		super.create();
	}

	var bgTargetY:Float = 0;

<<<<<<< HEAD
	var DONTFUCKINGTRIGGERYOUPIECEOFSHIT:Bool = false;

	override function update(elapsed:Float)
	{
		if (DONTFUCKINGTRIGGERYOUPIECEOFSHIT)
			return;
		
=======
	override function update(elapsed:Float)
	{
>>>>>>> upstream
		super.update(elapsed);

		menuBG.y = FlxMath.lerp(menuBG.y, bgTargetY, Helper.boundTo(elapsed * 9.6, 0, 1));

<<<<<<< HEAD
		if (FlxG.keys.justPressed.SEVEN)
			CustomTransition.switchTo(new editors.CreditsEditor());

		if (controls.UI_UP_P)
=======
		if (controls.UP_P)
>>>>>>> upstream
		{
			changeSelection(-1);
			if (alphabets.members[curSelected].isBold)
				changeSelection(-1);
		}

<<<<<<< HEAD
		if (controls.UI_DOWN_P)
=======
		if (controls.DOWN_P)
>>>>>>> upstream
		{
			changeSelection(1);
			if (alphabets.members[curSelected].isBold)
				changeSelection(1);
		}

<<<<<<< HEAD
		if (controls.UI_ACCEPT)
=======
		if (controls.ACCEPT)
>>>>>>> upstream
		{
			if (allTheShit[curSelected][2] != "")
				fancyOpenURL(allTheShit[curSelected][2]);
		}

<<<<<<< HEAD
		if (controls.UI_BACK)
		{
			CustomTransition.switchTo(new MainMenuState());
=======
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
>>>>>>> upstream
		}
	}

	function changeSelection(change:Int = 0)
	{
<<<<<<< HEAD
		if (change != 0)
			FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
=======
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
>>>>>>> upstream

		curSelected += change;

		if (curSelected < 0)
			curSelected = alphabets.length - 1;
		if (curSelected >= alphabets.length)
			curSelected = 0;

		bgTargetY = -120 * 0.2 * curSelected;

		if (allTheShit[curSelected][1] != "")
		{
			descriptionShit.text = allTheShit[curSelected][1];
			descriptionShit.y = (FlxG.height * 0.9) - (descriptionShit.height / 2);
			descriptionShit.visible = true;

			descBackground.setGraphicSize(Std.int(descriptionShit.width + 20), Std.int(descriptionShit.height + 20));
			descBackground.screenCenter(X);
			descBackground.y = (FlxG.height * 0.9) - (descBackground.height / 2);
			descBackground.visible = true;
		}
		else
		{
			descBackground.visible = false;
			descriptionShit.visible = false;
			descriptionShit.text = "";
		}

		if (Settings.flashing)
		{
			FlxTween.cancelTweensOf(menuBG, ["color"]);
			FlxTween.color(menuBG, 0.5, menuBG.color, FlxColor.fromString("#" + allTheShit[curSelected][3]));
		}

		var bullShit:Int = 0;

		for (item in alphabets.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!item.isBold)
				item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}
