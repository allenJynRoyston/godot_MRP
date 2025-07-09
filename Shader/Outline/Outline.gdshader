shader_type canvas_item;

uniform float outline_thickness : hint_range(0.0, 10.0) = 1.0;
uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0); // Default outline color (black)

void fragment() {
    // Fetch the current texture color
    vec4 tex_color = texture(TEXTURE, UV);

    // Default the output color to the texture color
    vec4 output_color = tex_color;

    // Proceed only if the pixel is opaque
    if (tex_color.a > 0.1) {
        // Use TEXTURE_PIXEL_SIZE for UV space calculations
        vec2 texel_size = TEXTURE_PIXEL_SIZE * outline_thickness;

        // Check surrounding pixels for transparency (to detect edges)
        bool is_edge = false;
        is_edge = is_edge || (texture(TEXTURE, UV + vec2(-texel_size.x, 0.0)).a < 0.1);
        is_edge = is_edge || (texture(TEXTURE, UV + vec2(texel_size.x, 0.0)).a < 0.1);
        is_edge = is_edge || (texture(TEXTURE, UV + vec2(0.0, -texel_size.y)).a < 0.1);
        is_edge = is_edge || (texture(TEXTURE, UV + vec2(0.0, texel_size.y)).a < 0.1);

        // If it's an edge pixel, use the specified outline color
        if (is_edge) {
            output_color = outline_color;
        }
    } else {
        // If the pixel is fully transparent, set it to transparent
        output_color = vec4(0.0, 0.0, 0.0, 0.0);
    }

    // Apply the output color
    COLOR = output_color;
}
