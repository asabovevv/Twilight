//Repeat = enabled && Scale = repeat_amount

shader_type canvas_item;

uniform vec2 repeat_amount = vec2(2, 1);

void fragment() {
	COLOR = texture(TEXTURE, UV * repeat_amount);
}
