shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;   // Intensity of glow
uniform float glow_radius : hint_range(0.0, 20.0) = 5.0;     // Radius of glow in pixels
uniform float opacity : hint_range(0.0, 1.0) = 1.0;          // Overall output opacity

void fragment() {
    // Pixel size in UV space
    vec2 texel_size = vec2(1.0) / vec2(textureSize(TEXTURE, 0));

    vec4 base_color = texture(TEXTURE, UV);

    vec3 glow = vec3(0.0);
    float total = 0.0;

    // Loop through neighboring pixels
    for (float x = -glow_radius; x <= glow_radius; x += 1.0) {
        for (float y = -glow_radius; y <= glow_radius; y += 1.0) {
            vec2 offset = vec2(x, y) * texel_size;
            glow += texture(TEXTURE, UV + offset).rgb;
            total += 1.0;
        }
    }

    glow = (glow / total) * glow_intensity;

    vec3 final_color = base_color.rgb + glow;

    COLOR = vec4(final_color, base_color.a * opacity);
}
