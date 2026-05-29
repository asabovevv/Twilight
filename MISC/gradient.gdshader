shader_type canvas_item;

uniform vec4 color1;
uniform vec4 color2;

void fragment() {
	COLOR = mix(color1, color2, UV.y);
}
