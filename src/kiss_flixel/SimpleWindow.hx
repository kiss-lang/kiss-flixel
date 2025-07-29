package kiss_flixel;

import kiss.Prelude;
import kiss.List;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.ui.FlxButton;
import kiss_flixel.KissInputText;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import kiss_flixel.FlxKeyShortcutHandler;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.FlxInput;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.mouse.FlxMouseEvent;
import kiss_flixel.KissExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import hx.strings.Strings;

using haxe.io.Path;
using StringTools;

typedef ShortcutAction = Void->Void;
typedef Action = FlxSprite->Void;
typedef ConstructorArgs = {
	?title:String,
	?bgColor:FlxColor,
	?textColor:FlxColor,
	?percentWidth:Float,
	?percentHeight:Float,
	?xButton:Bool,
	?xKey:String,
	?leftKey:String,
	?rightKey:String,
	?upKey:String,
	?downKey:String,
	?enterKey:String,
	?onClose:ShortcutAction,
	?selectionMarker:FlxSprite,
	?screenReaderAudioFolder:String
};

@:build(kiss.Kiss.build())
class SimpleWindow extends FlxSprite {}
