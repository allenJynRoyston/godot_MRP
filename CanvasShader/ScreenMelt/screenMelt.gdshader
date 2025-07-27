shader_type canvas_item;

uniform float transition : hint_range(0.0, 1.0) = 0.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;

	// Snap to pixel grid to stabilize randomness
	float px = float(textureSize(TEXTURE, 0).x);
	float py = float(textureSize(TEXTURE, 0).y);
	vec2 uv_snap = vec2(floor(uv.x * px) / px, floor(uv.y * py) / py);

	// Dissolve threshold
	float threshold = random(uv_snap);

	// ⚡ Glitch intensity ramps with transition
	float glitch_strength = mix(0.0, 0.15, transition);     // horizontal offset
	float vertical_jitter = mix(0.0, 0.02, transition);     // optional vertical offset
	float rgb_shift = mix(0.0, 0.03, transition);           // chromatic aberration

	// ⚡ More frequent and chaotic glitch slices
	float slice_freq = 800.0;
	float slice_chance = step(0.85, random(vec2(floor(uv.y * slice_freq), transition)));
	float h_offset = (random(vec2(uv.y * 123.0, transition)) - 0.5) * glitch_strength * slice_chance;
	float v_offset = (random(vec2(transition, uv.x * 321.0)) - 0.5) * vertical_jitter * slice_chance;

	// Apply glitch offsets
	vec2 glitch_uv = uv + vec2(h_offset, v_offset);

	// RGB shift (chromatic offset)
	vec4 col;
	col.r = texture(TEXTURE, glitch_uv + vec2( rgb_shift, 0.0)).r;
	col.g = texture(TEXTURE, glitch_uv).g;
	col.b = texture(TEXTURE, glitch_uv + vec2(-rgb_shift, 0.0)).b;
	col.a = texture(TEXTURE, glitch_uv).a;

	// Dissolve pixel based on transition threshold
	float visible = step(transition, threshold);
	COLOR = vec4(col.rgb, col.a * visible);
}
