shader_type canvas_item;

uniform float ramp_amount : hint_range(0.0, 1.0); // 0 = original, 1 = ramped
uniform vec3 color_orig[4]; // Original palette (e.g., NES 4-color)
uniform vec3 color_ramp[4]; // Target palette (darker version)

float color_match(vec3 a, vec3 b) {
    return step(0.01, 1.0 - length(a - b)); // 1 if nearly equal
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 color = tex_color.rgb;
    vec3 result = color;

    // Match color to palette and ramp it
    for (int i = 0; i < 4; i++) {
        if (color_match(color, color_orig[i]) > 0.5) {
            result = mix(color_orig[i], color_ramp[i], ramp_amount);
            break;
        }
    }

    COLOR = vec4(result, tex_color.a);
}
