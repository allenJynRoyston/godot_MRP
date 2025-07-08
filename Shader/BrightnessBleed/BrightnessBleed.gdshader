shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float glow_radius : hint_range(0.0, 20.0) = 5.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform float glow_offset_strength : hint_range(0.0, 10.0) = 1.0; // controls how far inward samples are pulled

void fragment() {
    vec2 texel_size = vec2(1.0) / vec2(textureSize(TEXTURE, 0));
    vec4 base_color = texture(TEXTURE, UV);

    vec3 glow = vec3(0.0);
    float total = 0.0;

    // Direction toward center from current fragment
    vec2 center = vec2(0.5);
    vec2 to_center = normalize(center - UV);

    for (float x = -glow_radius; x <= glow_radius; x++) {
        // Pull each sample inward toward center
        vec2 offset = to_center * x * texel_size.x * glow_offset_strength;
        glow += texture(TEXTURE, UV + offset).rgb;
        total += 1.0;
    }

    glow = (glow / total) * glow_intensity;
    vec3 final_color = base_color.rgb + glow;

    COLOR = vec4(final_color, base_color.a * opacity);
}
