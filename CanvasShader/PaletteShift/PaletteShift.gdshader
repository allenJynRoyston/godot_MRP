shader_type canvas_item;

uniform float ramp_amount : hint_range(0.0, 1.0) = 0.0;

const int PALETTE_SIZE = 32;

const vec3 palette_start[PALETTE_SIZE] = vec3[](
    // First 16 colors — darker versions
    vec3(0.1, 0.07, 0.03), vec3(0.2, 0.1, 0.05), vec3(0.3, 0.15, 0.07), vec3(0.4, 0.2, 0.1),
    vec3(0.05, 0.05, 0.05), vec3(0.15, 0.15, 0.15), vec3(0.25, 0.25, 0.25), vec3(0.35, 0.35, 0.35),
    vec3(0.02, 0.02, 0.1), vec3(0.07, 0.07, 0.2), vec3(0.12, 0.12, 0.3), vec3(0.17, 0.17, 0.4),
    vec3(0.1, 0.1, 0.1), vec3(0.3, 0.3, 0.3), vec3(0.6, 0.6, 0.6), vec3(0.9, 0.9, 0.9),
    // Next 16 colors — darker versions
    vec3(0.15, 0.05, 0.05), vec3(0.3, 0.1, 0.1), vec3(0.45, 0.15, 0.15), vec3(0.6, 0.2, 0.2),
    vec3(0.1, 0.15, 0.05), vec3(0.2, 0.3, 0.1), vec3(0.3, 0.45, 0.15), vec3(0.4, 0.6, 0.2),
    vec3(0.05, 0.1, 0.15), vec3(0.1, 0.2, 0.3), vec3(0.15, 0.3, 0.45), vec3(0.2, 0.4, 0.6),
    vec3(0.15, 0.15, 0.3), vec3(0.3, 0.3, 0.6), vec3(0.45, 0.45, 0.9), vec3(0.6, 0.6, 1.2)
);

const vec3 palette_end[PALETTE_SIZE] = vec3[](
    // First 16 colors — original palette
    vec3(0.6, 0.4, 0.2), vec3(0.7, 0.5, 0.3), vec3(0.8, 0.6, 0.4), vec3(0.9, 0.7, 0.5),
    vec3(0.15, 0.15, 0.15), vec3(0.35, 0.35, 0.35), vec3(0.55, 0.55, 0.55), vec3(0.75, 0.75, 0.75),
    vec3(0.1, 0.1, 0.6), vec3(0.2, 0.2, 0.7), vec3(0.3, 0.3, 0.8), vec3(0.4, 0.4, 0.9),
    vec3(0.4, 0.4, 0.4), vec3(0.6, 0.6, 0.6), vec3(0.8, 0.8, 0.8), vec3(1.0, 1.0, 1.0),
    // Next 16 colors — original palette
    vec3(0.8, 0.3, 0.3), vec3(0.9, 0.4, 0.4), vec3(1.0, 0.5, 0.5), vec3(1.0, 0.6, 0.6),
    vec3(0.4, 0.8, 0.3), vec3(0.5, 0.9, 0.4), vec3(0.6, 1.0, 0.5), vec3(0.7, 1.0, 0.6),
    vec3(0.3, 0.4, 0.8), vec3(0.4, 0.5, 0.9), vec3(0.5, 0.6, 1.0), vec3(0.6, 0.7, 1.0),
    vec3(0.5, 0.5, 0.8), vec3(0.6, 0.6, 0.9), vec3(0.7, 0.7, 1.0), vec3(0.8, 0.8, 1.0)
);

int find_closest_palette_index(vec3 color) {
    float min_dist = 1000.0;
    int closest_index = 0;
    for (int i = 0; i < PALETTE_SIZE; i++) {
        float dist = distance(color, palette_end[i]);
        if (dist < min_dist) {
            min_dist = dist;
            closest_index = i;
        }
    }
    return closest_index;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 original_color = tex_color.rgb;

    float steps = 10.0;
    float stepped = floor(ramp_amount * steps) / steps;

    int idx = find_closest_palette_index(original_color);

    vec3 ramped_color = mix(palette_start[idx], palette_end[idx], stepped);

    COLOR = vec4(ramped_color, tex_color.a);
}
