shader_type canvas_item;

uniform float blur_radius : hint_range(0.0, 20.0) = 4.0;
uniform vec2 blur_direction = vec2(1.0, 0.0); // Horizontal by default

void fragment() {
    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 texel_size = 1.0 / size;

    // 1D Gaussian weights for 9 samples (symmetrical)
    float weights[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

    vec4 color = texture(TEXTURE, UV) * weights[0];

    for (int i = 1; i < 5; i++) {
        vec2 offset = blur_direction * texel_size * float(i) * blur_radius;
        color += texture(TEXTURE, UV + offset) * weights[i];
        color += texture(TEXTURE, UV - offset) * weights[i];
    }

    COLOR = color;
}
