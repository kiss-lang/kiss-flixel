#pragma header

uniform vec4 color1: hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2: hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float checkSize = 64.0;

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    float transparency = 1.0 - color.a;

    vec2 position = openfl_TextureCoordv * iResolution / cameraZoom + cameraPos;
    float row = floor(position.y / checkSize);
    float col = floor(position.x / checkSize);

    bool oddRow = mod(row, 2) == 1;
    bool oddCol = mod(col, 2) == 1;

    vec4 oddColor = oddRow ? color1 : color2;
    vec4 evenColor = oddRow ? color2 : color1;

    vec4 bgColor = oddCol ? oddColor: evenColor;
    gl_FragColor = color + bgColor * transparency;
}