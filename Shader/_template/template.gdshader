shader_type canvas_item;

uniform float blur_radius : hint_range(0.0, 20.0) = 6.0;
uniform vec2 blur_direction = vec2(1.0, 0.0); // Set per pass

void fragment() {
    vec2 texel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
    vec2 direction = normalize(blur_direction) * texel_size * blur_radius;

    float weights[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

    vec4 color = texture(TEXTURE, UV) * weights[0];

    for (int i = 1; i < 5; i++) {
        vec2 offset = direction * float(i);
        color += texture(TEXTURE, UV + offset) * weights[i];
        color += texture(TEXTURE, UV - offset) * weights[i];
    }

    COLOR = color;
}
