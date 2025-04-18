package kiss_flixel;

import kiss.Prelude;
import kiss.List;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flash.display.PNGEncoderOptions;
import flash.utils.ByteArray;
#if sys
import sys.io.File;
#end
import kiss_flixel.DebugLayer;
import kiss_flixel.SimpleWindow;

enum RelativeCoordinate {
    // Negative means to count back from the far edge
    Pixels(p:Int); // Pixels from an edge.
    Percent(p:Float); // Percent from an edge. -1 to 1
}

typedef RelativePosition = {
    x:RelativeCoordinate, 
    y:RelativeCoordinate,
    ?anchorX:RelativeCoordinate, // default Percent(0.5)
    ?anchorY:RelativeCoordinate, // default Percent(0.5)
    ?sizeX:RelativeCoordinate,
    ?sizeY:RelativeCoordinate,
    ?offsetX:Int,
    ?offsetY:Int
};

@:build(kiss.Kiss.build())
class SpriteTools {}
