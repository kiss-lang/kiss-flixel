// Based on https://www.youtube.com/watch?v=x_s0LmQgjfU
// by June Rain
// Ported to kiss-flixel by NQNStudios

uniform float amount = 40.0;
uniform vec3 color = vec3(1.0);

void fragment() {
	float a = fract(sin(dot(UV, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.9;
	vec4 col = vec4(color, 1.0);
	col.a *= pow(a, amount);
	COLOR = col;
}