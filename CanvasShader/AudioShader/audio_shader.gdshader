shader_type canvas_item;

const int VU_COUNT = 30;
const float segment_count = 40.0;

uniform float audio_data[30];
uniform float time;

// Optional HSV-to-RGB conversion function
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec2 uv = UV;
    uv.y = 1.0 - uv.y;
    float vu_count = float(VU_COUNT);
    float index = floor(uv.x * vu_count);

    float flicker = 0.01 * sin(time * 80.0 + index * 1.7);
    float shifted_x = uv.x + flicker;

    vec2 cell = vec2(floor(shifted_x * vu_count) / vu_count, floor(uv.y * segment_count) / segment_count);
    float fft = audio_data[int(index)];

    // Optional wave distortion
    float wave = sin(index * 0.3 + time * 2.0) * 0.05;
    fft = clamp(fft + wave, 0.0, 1.0);

    float active = step(cell.y, fft);
    vec2 dist = fract((uv - cell) * vec2(vu_count, segment_count)) - 0.5;
    float led_core = smoothstep(0.25, 0.05, length(dist));
    float led_glow = smoothstep(0.5, 0.2, length(dist));

    // Hue cycling
    float hue = mod(time * 0.1 + cell.y + index / vu_count, 1.0);
    vec3 neon = hsv2rgb(vec3(hue, 1.0, 1.0));

    // Background flicker
    float noise = fract(sin(dot(uv * 600.0, vec2(12.9898, 78.233))) * 43758.5453);
    vec3 background = vec3(0.01 + 0.01 * noise);

    // Scanline effect
    float scanline = sin((uv.y + time * 0.2) * 300.0) * 0.05;
    float grid = step(0.01, fract(uv.x * vu_count)) * step(0.01, fract(uv.y * segment_count));

    vec3 final_color = background;
    final_color += neon * led_glow * 0.3; // aura
    final_color += neon * led_core * active * 1.2; // lit block

    // Peak dot
    float dot_y = fft + 1.0 / segment_count;
    float dot_dist = distance(uv, vec2(index / vu_count + 0.5 / vu_count, dot_y));
    if (dot_dist < 0.015) {
        final_color += neon * (1.0 - dot_dist * 50.0);
    }

    // Ripple pulse on peak
    if (fft > 0.95) {
        float ripple = 0.05 / (length(uv - vec2(index / vu_count + 0.5 / vu_count, 1.0)) + 0.01);
        final_color += ripple * neon * 0.5;
    }

    // Mirror vertically
    uv.y = abs(uv.y * 2.0 - 1.0);

    // Grid lines + scanline darkening
    final_color *= 1.0 - 0.1 * grid;
    final_color *= 1.0 - scanline;

    COLOR = vec4(final_color, 1.0);
}