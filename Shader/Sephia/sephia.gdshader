shader_type canvas_item;

void fragment() {
    // Get the texture color at the current UV
    vec4 tex_color = texture(TEXTURE, UV);

    // Apply sepia filter
    float r = tex_color.r * 0.393 + tex_color.g * 0.769 + tex_color.b * 0.189;
    float g = tex_color.r * 0.349 + tex_color.g * 0.686 + tex_color.b * 0.168;
    float b = tex_color.r * 0.272 + tex_color.g * 0.534 + tex_color.b * 0.131;

    // Set the final color to the sepia toned color
    COLOR = vec4(r, g, b, tex_color.a);
}
