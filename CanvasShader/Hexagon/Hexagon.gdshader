shader_type canvas_item;

uniform vec3 color1: source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 color2: source_color = vec3(1.0, 1.0, 1.0);
uniform float speed1 = 2.0;
uniform float speed2 = 3.79;

float sdCircle( vec2 p, float r ) {
	return length(p) - r;
}

float sdHexagon( in vec2 p, in float r ) {
	const vec3 k = vec3(-0.866025404,0.5,0.577350269);
	p = abs(p);
	p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
	p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
	return length(p)*sign(p.y);
}

void fragment() {
	vec2 zoom = UV * 10.0;
	vec2 guv = fract(zoom) - 0.5;
	vec2 guv2 = fract(zoom) - 0.5;
	float sd = sdHexagon(guv, 0.45 - abs(sin(TIME * speed1) * 0.35));
	float c1 = smoothstep(0.05, 0.00, sd);
	COLOR.rgb = color1 * (0.25+c1*0.75);

	float sd2 = sdHexagon(guv, 0.4 + cos(TIME * speed2) * 0.2);
	float c = smoothstep(0.04, 0.0, abs(sd2));
	COLOR.rgb += color2 * c;
}
