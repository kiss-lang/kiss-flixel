#pragma header

uniform bool invert = true;

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = invert ? vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a,   color.a) : color;
}