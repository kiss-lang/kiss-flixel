package kiss_flixel;

#if sys
import kiss.Prelude;
import kiss.List;
import flixel.util.FlxColor;
import lime.net.HTTPRequest;
import haxe.io.Bytes;
import kiss_flixel.KissInputText;
import flixel.FlxG;
import sys.io.File;

@:build(kiss.Kiss.build())
class FeedbackWindow extends SimpleWindow {}

#end