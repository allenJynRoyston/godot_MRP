shader_type canvas_item;

float square(in vec2 p, in float s) {
    vec2 d = abs(p) - s;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.);
}

void fragment() {
  vec2 iResolution = (1.0 / SCREEN_PIXEL_SIZE);
  vec2 uv = (FRAGCOORD.xy * 2.0 - iResolution.xy) / iResolution.y;
  vec2 uv0 = uv;
  uv *= 0.75;
  vec3 col = vec3(0);

  for (float i = 1.; i < 4.; i++) {
    uv = fract(uv * 2.) - 0.5;

    float d = square(uv, 1.);
    d *= length(uv0); // to see the squares, comment this line
    d = cos(d * 8. - TIME * i * 0.3);
    d = abs(d);

    col += smoothstep(1. / iResolution.y, 0., d - 0.2);
  }

  COLOR = vec4(col, 1.0);

}