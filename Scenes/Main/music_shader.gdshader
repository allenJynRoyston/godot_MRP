shader_type canvas_item;

uniform float audio_data[10];

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1e-10;
	return vec3(abs((q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0 / 3.0, 2.0 / 3.0)) * 6.0 - 3.0);
	return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float bass = audio_data[0];
	float mid = (audio_data[3] + audio_data[4] + audio_data[5]) / 3.0;
	float treble = audio_data[9];

	vec3 hsv = rgb2hsv(tex.rgb);
	hsv.x += mid * 0.3;           // Hue shifts with mid frequencies
	hsv.z *= 1.0 + bass * 0.5;    // Brightness reacts to bass
	hsv.y *= 1.0 + treble * 0.3;  // Saturation reacts to treble

	COLOR = vec4(hsv2rgb(hsv), tex.a);
}
