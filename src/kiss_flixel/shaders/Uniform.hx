package kiss_flixel.shaders;

enum Uniform {
    Boolean;
    AnyInt;
    IntRange(min:Int, max:Int);
    IntRangeStep(min:Int, max:Int, step:Int);
    AnyFloat;
    FloatRange(min:Float, max:Float);
    FloatRangeStep(min:Float, max:Float, step:Float);
    ColorSolid;
    ColorWithAlpha;
    Vector2;
    Vector3;
    Vector4;
}
