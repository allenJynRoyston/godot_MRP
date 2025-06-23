shader_type canvas_item;

const int VU_COUNT = 30;
const float SEGMENT_COUNT = 30.0;

uniform float audio_data[30];
uniform float time;

// Convert HSV to RGB (for hue cycling)
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec2 uv = UV * 2.0 - 1.0; // [-1, 1] range (centered)
	float r = length(uv);     // distance from center
	float a = atan(uv.y, uv.x); // angle from center
	if (a < 0.0) a += 6.2831853; // [0, 2π]

	// Convert angle to index
	float angle_per_band = 6.2831853 / float(VU_COUNT);
	int index = int(floor(a / angle_per_band));
	index = clamp(index, 0, VU_COUNT - 1);

	// Get FFT level
	float fft = audio_data[index];

	// Glow and thickness settings
	float inner_radius = 0.4;
	float bar_width = 0.04;
	float bar_length = 0.4;

	// Determine how far the bar extends
	float bar_end = inner_radius + fft * bar_length;

	// Bar mask (within angular slice + radius)
	float within_band = step(inner_radius, r) * step(r, bar_end);
	float angle_center = (float(index) + 0.5) * angle_per_band;
	float angle_diff = abs(a - angle_center);
	angle_diff = min(angle_diff, 6.2831853 - angle_diff); // wraparound
	float within_angle = smoothstep(angle_per_band * 0.5, angle_per_band * 0.2, angle_diff);

	// Combine masks
	float mask = within_band * within_angle;

	// Glow edge
	float edge = smoothstep(bar_end + 0.01, bar_end, r);

	// Color cycling
	float hue = mod(float(index) / float(VU_COUNT) + time * 0.05, 1.0);
	vec3 color = hsv2rgb(vec3(hue, 1.0, 1.0));

	vec3 final_color = color * (0.3 * edge + 0.7 * mask);

	// Optional soft center
	final_color += vec3(0.02) * (1.0 - smoothstep(0.0, inner_radius, r));

	COLOR = vec4(final_color, 1.0);
}
