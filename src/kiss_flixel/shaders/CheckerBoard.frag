#pragma header

uniform vec4 color1 = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 = vec4(0.0, 0.0, 0.0, 1.0);
uniform float checkSize = 64;

void main()
{
    vec2 position = openfl_TextureCoordv * iResolution + cameraPos;
    float row = floor(position.y / checkSize);
    float col = floor(position.x / checkSize);

    bool oddRow = mod(row, 2) == 1;
    bool oddCol = mod(col, 2) == 1;

    vec4 oddColor = oddRow ? color1 : color2;
    vec4 evenColor = oddRow ? color2 : color1;

    gl_FragColor = oddCol ? oddColor: evenColor;
}