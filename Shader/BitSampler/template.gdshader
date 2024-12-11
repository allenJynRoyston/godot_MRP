shader_type canvas_item;

uniform float bit_depth : hint_range(8.0, 32.0, 1.0) = 8.0; // Range from 8-bit to 32-bit

void fragment() {
    // Get the texture color at the current UV
    vec4 tex_color = texture(TEXTURE, UV);

    // Reduce color channels based on bit_depth
    // Quantize color channels (round to the nearest step for the selected bit depth)
    tex_color.rgb = floor(tex_color.rgb * (bit_depth - 1.0)) / (bit_depth - 1.0);

    // Set the final color
    COLOR = tex_color;
}
