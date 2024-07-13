#pragma header

uniform bool invert = true;
uniform int test_int = 0;
uniform int test_range_int: hint_range(0, 20) = 0;
uniform int test_step_int: hint_range(0, 20, 2) = 0;
uniform float test_step_float: hint_range(0, 1, 0.1) = 0;

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = invert ? vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a,   color.a) : color;
}