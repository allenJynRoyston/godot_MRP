shader_type canvas_item;

uniform int size = 64; // amount of dots
uniform float dot_size = 2.0; // dots are multiplied by dot_size
uniform float value_multiplier = 1.0; // reduce or increase value, useful when it's too bright
uniform bool invert = false;
uniform vec4 dot_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Selectable color (RGBA)

vec3 rgb2hsv(vec3 tex) {
	vec3 hsv;
	vec3 c = tex;
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void fragment() {
	float fSize = float(size);
	vec2 ratio = vec2(1.0, TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y);
	vec2 pixelated_uv = floor(UV * fSize * ratio) / (fSize * ratio);

	float dots = length(fract(UV * fSize * ratio) - vec2(0.5)) * dot_size;
	float value = rgb2hsv(texture(TEXTURE, pixelated_uv).rgb).z;

	dots = mix(dots, 1.0 - dots, float(invert));
	dots += value * value_multiplier;
	dots = pow(dots, 5.0);
	dots = clamp(dots, 0.0, 1.0);

	COLOR.rgb = dot_color.rgb * dots;
	COLOR.a = texture(TEXTURE, UV).a * dot_color.a; // Optional: modulate alpha too
}
