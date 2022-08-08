package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = "";
	var curAudio:String = "";
	var curDialogue:String = "";

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var gfPortrait:FlxSprite;
	var bfPortrait:FlxSprite;
	var spinelPortrait:FlxSprite;
	var spineldifPortrait:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var music:FlxSound;
	var SkipThisShit:FlxText;

	var dialogueSound:FlxSound;
	
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		// Dialogue song stuff
		if (PlayState.isStoryMode)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'other friends', 'unchangeable':
					music = new FlxSound().loadEmbedded(Paths.music('CUTSCENE_1', 'shared'), true, true);
					music.volume = 0;
					music.fadeIn(1, 0, 0.75);
					FlxG.sound.list.add(music);
			}
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.23, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(50, 350);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase().replace(' ','-'))
		{
			case 'other-friends':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('spinel/box');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('loudOpen', 'speech bubble loud open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24, true);
				box.animation.addByIndices('loud', 'AHH speech bubble', [4], "", 24, true);

			case 'unchangeable':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('spinel/box');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('loudOpen', 'speech bubble loud open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24, true);
				box.animation.addByIndices('loud', 'AHH speech bubble', [4], "", 24, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		if (PlayState.SONG.song.toLowerCase().replace(' ','-') == 'other-friends')
		{
			portraitLeft = new FlxSprite(-35, -67);
			portraitLeft.frames = Paths.getSparrowAtlas('spinel/portraits/spinelspritedialogue');
			portraitLeft.animation.addByPrefix('smug', 'smug', 24, false);
			portraitLeft.animation.addByPrefix('angry', 'angry', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.88));
			portraitLeft.scrollFactor.set();
			portraitLeft.antialiasing = true;
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		if (PlayState.SONG.song.toLowerCase().replace(' ','-') == 'unchangeable')
			{
				portraitLeft = new FlxSprite(-35, -67);
				portraitLeft.frames = Paths.getSparrowAtlas('spinel/portraits/stunned');
				portraitLeft.animation.addByPrefix('damn', 'stunned', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.88));
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				add(portraitLeft);
				portraitLeft.visible = false;
			}

		portraitRight = new FlxSprite(875, 170);
		portraitRight.frames = Paths.getSparrowAtlas('spinel/portraits/bf_sprite_dialogue');
		portraitRight.animation.addByPrefix('yes', 'yes', 24, false);
		portraitRight.animation.addByPrefix('excited', 'excited', 24, false);
		portraitRight.animation.addByPrefix('sarcasm', 'Sarcasm', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		portraitRight.antialiasing = true;
		add(portraitRight);
		portraitRight.visible = false;

		gfPortrait = new FlxSprite(500, 30);
		gfPortrait.frames = Paths.getSparrowAtlas('spinel/portraits/gf_sprite_dialogue');
		gfPortrait.animation.addByPrefix('normal', 'face1', 24, false);
		gfPortrait.animation.addByPrefix('upset', 'face2', 24, false);
		gfPortrait.updateHitbox();
		gfPortrait.setGraphicSize(Std.int(gfPortrait.width * 0.9));
		gfPortrait.antialiasing = true;
		gfPortrait.scrollFactor.set();
		add(gfPortrait);
		gfPortrait.visible = false;

		bfPortrait = new FlxSprite(875, 150);
		bfPortrait.frames = Paths.getSparrowAtlas('spinel/portraits/bf_sprite_dialogue');
		bfPortrait.animation.addByPrefix('shocked', 'shocked', 24, false);
		bfPortrait.animation.addByPrefix('worried', 'worried0', 24, false);
		bfPortrait.updateHitbox();
		bfPortrait.setGraphicSize(Std.int(bfPortrait.width * 0.9));
		bfPortrait.antialiasing = true;
		bfPortrait.scrollFactor.set();
		add(bfPortrait);
		bfPortrait.visible = false;

		spinelPortrait = new FlxSprite(-28, -60);
		spinelPortrait.frames = Paths.getSparrowAtlas('spinel/portraits/spinelspritedialogue');
		spinelPortrait.animation.addByPrefix('meh', 'meh', 24, false);
		spinelPortrait.setGraphicSize(Std.int(spinelPortrait.width * 0.9));
		spinelPortrait.scrollFactor.set();
		spinelPortrait.antialiasing = true;
		add(spinelPortrait);
		spinelPortrait.visible = false;

		spineldifPortrait = new FlxSprite(-37, -40);
		spineldifPortrait.frames = Paths.getSparrowAtlas('spinel/portraits/spinelspritedialogue');
		spineldifPortrait.animation.addByPrefix('angry', 'angry', 24, false);
		spineldifPortrait.setGraphicSize(Std.int(spineldifPortrait.width * 0.9));
		spineldifPortrait.scrollFactor.set();
		spineldifPortrait.antialiasing = true;
		add(spineldifPortrait);
		spineldifPortrait.visible = false;
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		if (hasDialog)
		{
			SkipThisShit = new FlxText(0, FlxG.height * 0.92, -100, "Press SPACE to skip", 32);
			SkipThisShit.font = 'Crewniverse';
			add(SkipThisShit);
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'DejaVu Sans Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'DejaVu Sans Bold';
		swagDialogue.color = 0xFF3F2021;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
		dialogueSound = new FlxSound();
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
			else if (box.animation.curAnim.name == 'loudOpen' && box.animation.curAnim.finished)
				{
					box.animation.play('loud');
					dialogueOpened = true;
				}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.SPACE && dialogueStarted == true)
		{
			if (!isEnding)
			{
				remove(dialogue);
				remove(SkipThisShit);
				dialogueSound.stop();
				music.fadeOut(2.2, 0);
				isEnding = true;
	
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					box.alpha -= 1 / 5;
					bgFade.alpha -= 1 / 5 * 0.7;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					gfPortrait.visible = false;
					bfPortrait.visible = false;
					spinelPortrait.visible = false;
					spineldifPortrait.visible = false;
					swagDialogue.alpha -= 1 / 5;
					dropText.alpha = swagDialogue.alpha;
				}, 5);
	
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
				
				super.update(elapsed);
			}
		}

		#if android

		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
			if (touch.justPressed)
				justTouched = true;
		#end

		if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.SPACE && dialogueStarted == true)
		{
			if (!isEnding)
			{
				remove(dialogue);
			}

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
					remove(SkipThisShit);
					music.fadeOut(2.2, 0);
					dialogueSound.stop();
					
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						gfPortrait.visible = false;
						bfPortrait.visible = false;
						spinelPortrait.visible = false;
						spineldifPortrait.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				if (!isEnding)
				{	
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;
	

	function startDialogue():Void
	{
		cleanDialog();

		swagDialogue.resetText(curDialogue);
		swagDialogue.start(0.04, true);
		
		if (dialogueSound != null)
			if (dialogueSound.playing)
				dialogueSound.stop();
		
		dialogueSound = new FlxSound().loadEmbedded(Paths.sound("dialogue/" + curAudio));
		dialogueSound.play();
		
		switch (curCharacter)
		{
			case 'gf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				gfPortrait.animation.play('normal');
				if (!gfPortrait.visible)
				{
					box.flipX = false;
					gfPortrait.visible = true;
				}
			case 'gfdif':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				gfPortrait.animation.play('upset');
				if (!gfPortrait.visible)
				{
					box.flipX = false;
					gfPortrait.visible = true;
				}
			case 'spinel':
				portraitRight.visible = false;
				gfPortrait.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				portraitLeft.animation.play('smug');
				if (!portraitLeft.visible)
				{
					box.flipX = true;
					portraitLeft.visible = true;
				}
			case 'woah':
				portraitRight.visible = false;
				gfPortrait.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				portraitLeft.animation.play('damn');
				if (!portraitLeft.visible)
				{
					box.flipX = true;
					portraitLeft.visible = true;
				}
			case 'spinelrage':
				portraitRight.visible = false;
				gfPortrait.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(0.8, 0.8);
				box.setPosition(-50, 263);
				box.animation.play('loudOpen');
				spineldifPortrait.animation.play('angry');
				if (!spineldifPortrait.visible)
				{
					box.flipX = true;
					spineldifPortrait.visible = true;
				}
			case 'spinellol':
				portraitRight.visible = false;
				gfPortrait.visible = false;
				bfPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				spinelPortrait.animation.play('meh');
				if (!spinelPortrait.visible)
				{
					box.flipX = true;
					spinelPortrait.visible = true;
				}
			case 'bf':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(0.8, 0.8);
				box.setPosition(-50, 263);
				box.animation.play('loudOpen');
				bfPortrait.animation.play('shocked');
				if (!bfPortrait.visible)
				{
					box.flipX = false;
					bfPortrait.visible = true;
				}
			case 'bfwor':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				bfPortrait.animation.play('worried');
				if (!bfPortrait.visible)
				{
					box.flipX = false;
					bfPortrait.visible = true;
				}
			case 'bfexc':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				portraitRight.animation.play('excited');
				if (!portraitRight.visible)
				{
					box.flipX = false;
					portraitRight.visible = true;
				}
			case 'bfyes':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(1, 1);
				box.setPosition(50, 350);
				box.animation.play('normalOpen');
				portraitRight.animation.play('yes');
				if (!portraitRight.visible)
				{
					box.flipX = false;
					portraitRight.visible = true;
				}
			case 'bfsar':
				gfPortrait.visible = false;
				portraitLeft.visible = false;
				bfPortrait.visible = false;
				spinelPortrait.visible = false;
				spineldifPortrait.visible = false;
				box.scale.set(0.8, 0.8);
				box.setPosition(-50, 263);
				box.animation.play('loudOpen');
				portraitRight.animation.play('sarcasm');
				if (!portraitRight.visible)
				{
					box.flipX = false;
					portraitRight.visible = true;
				}
		}
	}

	function cleanDialog():Void
	{
		var splitDialogue:Array<String> = dialogueList[0].split(":");
		curCharacter = splitDialogue[0];
		curAudio = splitDialogue[1];
		curDialogue = splitDialogue[2];

		trace(splitDialogue);
	}
}
