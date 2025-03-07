shader_type canvas_item;

uniform float hue: hint_range(0.0, 360.0, 1.0) = 0.0;
uniform float saturation: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float value: hint_range(0.0, 10.0, 0.1) = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float vsu = value * saturation * cos(hue * PI / 180.0);
	float vsw = value * saturation * sin(hue * PI / 180.0);
	vec3 ret;
    ret.r = (.299 * value + .701 * vsu + .168 * vsw) * color.r
        +   (.587 * value - .587 * vsu + .330 * vsw) * color.g
        +   (.114 * value - .114 * vsu - .497 * vsw) * color.b;
    ret.g = (.299 * value - .299 * vsu - .328 * vsw) * color.r
        +   (.587 * value + .413 * vsu + .035 * vsw) * color.g
        +   (.114 * value - .114 * vsu + .292 * vsw) * color.b;
    ret.b = (.299 * value - .300 * vsu + 1.25 * vsw) * color.r
        +   (.587 * value - .588 * vsu - 1.05 * vsw) * color.g
        +   (.114 * value + .886 * vsu - .203 * vsw) * color.b;
	COLOR = vec4(ret, color.a);
}