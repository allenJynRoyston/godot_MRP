shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float zoom : hint_range(0.1, 10.0) = 3.0;
uniform float line_thickness : hint_range(0.001, 0.05) = 0.02;
uniform float glow_strength : hint_range(0.0, 2.0) = 0.5;
uniform vec3 line_color : source_color = vec3(0.0, 1.0, 1.0); // Cyan
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform bool moving = true;

// Angle in radians to rotate the grid
uniform float angle : hint_range(0.0, 6.2831853) = 0.0;

void fragment() {
	vec2 uv = (UV - 0.5) * 2.0;
	uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

	// Rotate UV by angle
	float cos_a = cos(angle);
	float sin_a = sin(angle);
	vec2 rotated_uv = vec2(
		uv.x * cos_a - uv.y * sin_a,
		uv.x * sin_a + uv.y * cos_a
	);

	float time_offset = moving ? TIME * speed : 0.0;

	// Fake 3D perspective ray using rotated UV
	vec3 ray = vec3(rotated_uv * zoom, 1.0);

	// Intersect with plane at z=0 (ground plane)
	float t = -1.0 / ray.z;
	vec2 pos = ray.xy * t;

	// Scroll grid forward
	pos.y += time_offset;

	// Distance to nearest grid line
	vec2 grid = abs(fract(pos) - 0.5);

	// Minimum distance to a grid line
	float line = min(grid.x, grid.y);

	// Glow effect around lines
	float glow = pow(1.0 - smoothstep(0.0, line_thickness, line), 2.0) * glow_strength;

	vec3 color = line_color * glow;

	COLOR = vec4(color, alpha);
}
