// Based on https://gist.github.com/deakcor/f9dfed4cf82cbd86b49bd1b56a6ebd9e
// by deakcor
// Ported to kiss-flixel by NQNStudios

/**
* Shadow 2D.
* License: CC0
* https://creativecommons.org/publicdomain/zero/1.0/
*/
uniform vec2 deform = vec2(2.0, 2.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec4 modulate = vec4(0.5, 0.5, 0.5, 1); // : hint_color;

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	vec2 uv = UV;
	float sizex = openfl_TextureSize.x; // float(textureSize(TEXTURE,int(ps.x)).x);
	float sizey = openfl_TextureSize.y; // float(textureSize(TEXTURE,int(ps.y)).y);
	uv.y+=offset.y*ps.y;
	uv.x+=offset.x*ps.x;
	float decalx=((uv.y-ps.x*sizex)*deform.x);
	float decaly=((uv.y-ps.y*sizey)*deform.y);
	uv.x += decalx;
	uv.y += decaly;
	vec4 shadow = vec4(modulate.rgb, texture(TEXTURE, uv).a * modulate.a);
	vec4 col = texture(TEXTURE, UV);
	COLOR = mix(shadow, col, col.a);
}