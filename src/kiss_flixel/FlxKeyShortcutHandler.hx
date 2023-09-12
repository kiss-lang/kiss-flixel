#if flixel

package kiss_flixel;

import kiss.Prelude;
import kiss.List;
import kiss_tools.KeyShortcutHandler;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.FlxInput;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepad;

@:build(kiss.Kiss.build())
class FlxKeyShortcutHandler<T> extends KeyShortcutHandler<T> {}
#end
