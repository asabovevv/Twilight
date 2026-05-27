shader_type canvas_item;

uniform sampler2D tex : repeat_enable, filter_nearest;
uniform vec2 tile_size = vec2(32.0, 32.0);
uniform vec2 scroll_speed = vec2(5.0, 3.0);
uniform float anim_speed = 5.0;
global uniform vec2 position;

void fragment() {
    // Screen-space pixel coordinates
    vec2 screen_px = SCREEN_UV / SCREEN_PIXEL_SIZE;
    // Scroll in pixel units
    screen_px += (TIME * scroll_speed) + vec2(0.0, floor(TIME * anim_speed) * 96.0);
    // Convert to texture UVs
    vec2 uv = (screen_px + position ) / vec2(textureSize(tex, 0));

    COLOR.rgb = texture(tex, uv).rgb;
}