shader_type canvas_item;

const int AUDIO_SAMPLES = 30;
uniform float audio_data[AUDIO_SAMPLES];
uniform float time;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1., 2./3., 1./3., 3.);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Convert to grayscale
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Calculate average audio intensity
    float audio_sum = 0.0;
    for (int i = 0; i < AUDIO_SAMPLES; i++) {
        audio_sum += audio_data[i];
    }
    float audio_avg = audio_sum / float(AUDIO_SAMPLES);

    // Neon color based on time + UV
    float hue = fract(time * 0.3 + UV.x + UV.y);
    vec3 neon_color = hsv2rgb(vec3(hue, 1.0, 1.0));

    // Mix grayscale with neon color depending on audio intensity (pulsing)
    float pulse = 0.5 + 0.5 * sin(time * 10.0);
    vec3 final_color = mix(vec3(gray), neon_color, pulse * audio_avg);

    COLOR = vec4(final_color, tex_color.a);
}
