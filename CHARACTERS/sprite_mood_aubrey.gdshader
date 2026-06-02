shader_type canvas_item;
render_mode unshaded;

uniform vec4 emotion = vec4(0, 0, 0, 0);
uniform vec4 bow_emotion_highlight = vec4(0, 0, 0, 0);
uniform vec4 bow_emotion_shadow = vec4(0, 0, 0, 0);
const vec4 invis = vec4(0, 0, 0, 0);

void fragment() {
	vec4 base_color = COLOR;
	
	float ol = texture(TEXTURE, vec2(UV.x-TEXTURE_PIXEL_SIZE.x, UV.y)).a;
	ol += texture(TEXTURE, vec2(UV.x+TEXTURE_PIXEL_SIZE.x, UV.y)).a;
	ol += texture(TEXTURE, vec2(UV.x, UV.y-TEXTURE_PIXEL_SIZE.y)).a;
	ol += texture(TEXTURE, vec2(UV.x, UV.y+TEXTURE_PIXEL_SIZE.y)).a;
	
	// outline color
	COLOR = mix(invis, emotion, min(ol, 1));
	COLOR = mix(COLOR, base_color, base_color.a);
	
	// bow highlight
	COLOR = mix(COLOR, bow_emotion_highlight, float( base_color.rgb==vec3(0,1,0) ) );
	// bow shadow
	COLOR = mix(COLOR, bow_emotion_shadow, float( base_color.rgb==vec3(0,0,1) ) );
}
