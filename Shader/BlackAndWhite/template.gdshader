shader_type canvas_item;

const int AUDIO_SAMPLES = 30;
uniform float audio_data[AUDIO_SAMPLES];
uniform float time;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Grayscale luminance from texture
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Map UV.x to pick audio frequency index (wrap safely)
    int idx = int(floor(UV.x * float(AUDIO_SAMPLES)));
    idx = clamp(idx, 0, AUDIO_SAMPLES - 1);

    // Get audio intensity at that index
    float intensity = audio_data[idx];

    // Use UV.y to create a vertical gradient for saturation or brightness
    float brightness = smoothstep(0.0, 1.0, UV.y);

    // Generate hue cycling over time + position for smooth shifting colors
    float hue = fract(time * 0.2 + float(idx) / float(AUDIO_SAMPLES));

    // Convert HSV to RGB with saturation controlled by audio intensity and brightness by vertical UV
    vec3 color = hsv2rgb(vec3(hue, intensity, brightness));

    // Mix grayscale base with the colored glow scaled by audio intensity
    vec3 final_color = mix(vec3(gray), color, intensity);

    COLOR = vec4(final_color, tex_color.a);
}
