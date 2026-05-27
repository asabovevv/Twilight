shader_type canvas_item;

uniform float off = 0.45;

void fragment() {
	float p = TIME*0.3;
	float p_off = TIME*0.3+off;
	
	float threshold = 1.0 + float( mod(p_off,1.0)>off );
	float bools = float(UV.x < mod(p_off,1.0)) + float(UV.x > mod(p,1.0));
	COLOR.a = mix(0.0, float(threshold <= bools), COLOR.a);
	
	//if mod(p_off)<off: (threshold == 1 or 2)
	//if uv<mod(p_off) || uv>mod(p):   (==1 or 2 success)
	//		draw
	//else:
	//	if uv<mod(p_off) && uv>mod(p): (== 2 success)
	//		draw
}