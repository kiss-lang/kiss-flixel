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
import flixel.group.FlxGroup;
import kiss_flixel.FlxKeyShortcutHandler;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.FlxInput;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.mouse.FlxMouseEvent;

typedef ShortcutAction = Void->Void;
typedef Action = FlxSprite->Void;

@:build(kiss.Kiss.build())
class SimpleWindow extends FlxSprite {}
