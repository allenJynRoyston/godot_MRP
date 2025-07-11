shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float zoom : hint_range(0.1, 10.0) = 3.0;
uniform float line_thickness : hint_range(0.001, 0.05) = 0.02;
uniform float glow_strength : hint_range(0.0, 2.0) = 0.5;
uniform vec3 line_color : source_color = vec3(0.0, 1.0, 1.0); // Cyan
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform bool moving = true;
uniform float angle : hint_range(0.0, 6.2831853) = 0.0;

// Radius around center that fades out grid lines
uniform float center_falloff_radius : hint_range(0.0, 2.0) = 0.7;
uniform float center_falloff_softness : hint_range(0.001, 1.0) = 0.3;

void fragment() {
	vec2 uv = (UV - 0.5) * 2.0;
	uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

	// Rotate UV coordinates
	float cos_a = cos(angle);
	float sin_a = sin(angle);
	vec2 rotated_uv = vec2(
		uv.x * cos_a - uv.y * sin_a,
		uv.x * sin_a + uv.y * cos_a
	);

	float time_offset = moving ? TIME * speed : 0.0;

	vec3 ray = vec3(rotated_uv * zoom, 1.0);
	float t = -1.0 / ray.z;
	vec2 pos = ray.xy * t;
	pos.y += time_offset;

	vec2 grid = abs(fract(pos) - 0.5);
	float line = min(grid.x, grid.y);
	float glow = pow(1.0 - smoothstep(0.0, line_thickness, line), 2.0) * glow_strength;

	// Opacity falloff from center
	float dist_from_center = length(uv);
	float center_fade = smoothstep(center_falloff_radius, center_falloff_radius + center_falloff_softness, dist_from_center);

	vec3 color = line_color * glow;
	COLOR = vec4(color, alpha * center_fade);
}
