shader_type canvas_item;

uniform float time_factor : hint_range(0.0, 3.0) = 1.5;
uniform float resolution : hint_range(0.01, 3.0) = 0.4;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform bool move = false;

// Basic fixed fire color gradient
vec3 firePalette(float i) {
    return vec3(
        clamp(i * 3.0, 0.0, 1.0),            // R
        clamp(i * 1.5, 0.0, 1.0),            // G
        clamp(i * 0.5, 0.0, 1.0)             // B
    );
}

// Simple 3D hash
vec3 hash33(vec3 p) {
    float n = sin(dot(p, vec3(7.0, 157.0, 113.0)));
    return fract(n * vec3(2097152.0, 262144.0, 32768.0));
}

// Basic Voronoi approximation (lower accuracy, much faster)
float fastVoronoi(vec3 p) {
    vec3 g = floor(p);
    vec3 f = fract(p);
    float d = 1.0;

    for (int i = 0; i < 4; i++) {
        vec3 b = vec3(float(i % 2), float((i / 2) % 2), float(i / 4)) - 0.5;
        vec3 r = b + hash33(g + b) - f;
        d = min(d, dot(r, r));
    }
    return d;
}

// fBm-style layering with fewer iterations
float noiseLayers(vec3 p) {
    float t = TIME * time_factor;
    float amp = 0.5;
    float total = 0.0;
    float sum = 0.0;

    for (int i = 0; i < 3; i++) { // Reduce layers from 5 to 3
        total += fastVoronoi(p + vec3(0.0, 0.0, t)) * amp;
        p *= 2.0;
        t *= 1.5;
        sum += amp;
        amp *= 0.5;
    }

    return total / sum;
}

float rand(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = (UV - 0.5) * vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
    if (move) {
        uv += vec2(sin(TIME * 0.5) * 0.25, cos(TIME * 0.5) * 0.125);
    }

    vec3 rd = normalize(vec3(uv, resolution));

    float c = noiseLayers(rd * 2.0);
    c *= c * 1.2; // Slight contrast boost

    vec3 col = firePalette(c);

    float stars = 0.0;
    if (rand(SCREEN_UV.xy / 20.0) > 0.996) {
        float r = rand(SCREEN_UV.xy);
        stars = r * (0.5 * sin(TIME * r * 2.0) + 0.5);
    }

    COLOR = vec4(clamp(col + stars, 0.0, 1.0), alpha);
}
