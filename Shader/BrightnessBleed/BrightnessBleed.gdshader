shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float glow_radius : hint_range(0.0, 20.0) = 5.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform vec2 glow_offset = vec2(0.0); // Global offset in pixels

void fragment() {
    vec2 texel_size = vec2(1.0) / vec2(textureSize(TEXTURE, 0));

    vec4 base_color = texture(TEXTURE, UV);

    vec3 glow = vec3(0.0);
    float total = 0.0;

    for (float x = -glow_radius; x <= glow_radius; x++) {
        vec2 offset = vec2(x, 0.0) * texel_size;

        // Apply global glow offset here — shifts all samples
        glow += texture(TEXTURE, UV + offset + glow_offset * texel_size).rgb;
        total += 1.0;
    }

    glow = (glow / total) * glow_intensity;

    vec3 final_color = base_color.rgb + glow;
    COLOR = vec4(final_color, base_color.a * opacity);
}
