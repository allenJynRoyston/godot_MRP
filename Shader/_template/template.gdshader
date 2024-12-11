shader_type canvas_item;

void fragment() {
    // Get the texture color at the current UV
    vec4 tex_color = texture(TEXTURE, UV);

    // Set the final color
    COLOR = tex_color;
}
