shader_type canvas_item;

uniform float zoom : hint_range(0.0, 5.0) = 1.0;  // Control the zoom level, range from 0.0 to 10.0

void fragment() {
    vec2 center = vec2(0.5, 0.5); // Center of the screen (normalized coordinates)

    // Calculate the distance from the center of the screen
    vec2 uv_offset = UV - center;
    float dist = length(uv_offset);  // Distance from the center

    // Apply zoom (bending outward from the center)
    float distortion_factor = 1.0 - zoom * pow(dist, 2.0);  // Negative power for outward bending
    vec2 warped_uv = center + uv_offset * distortion_factor;  // Apply the zoom effect

    // Sample the screen texture using the distorted UVs
    vec4 screen_texture = texture(TEXTURE, warped_uv);

    // Output the color
    COLOR = screen_texture;
}
