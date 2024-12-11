shader_type canvas_item;

uniform vec2 resolution = vec2(320.0, 180.0);               // Resolution for border calculation
uniform float top_bottom_border_pixels : hint_range(0.0, 100.0) = 20.0;  // Pixel width of top and bottom black borders
uniform float left_right_border_pixels : hint_range(0.0, 100.0) = 20.0;  // Pixel width of left and right black borders
uniform vec3 border_color : source_color = vec3(0.0, 0.0, 0.0); // Editable border color

void fragment() {
    // Calculate the border widths in UV space based on pixel values and resolution
    float top_bottom_border_width_uv = top_bottom_border_pixels / resolution.y;
    float left_right_border_width_uv = left_right_border_pixels / resolution.x;

    // Start by assuming we will output the original color
    vec4 final_color = texture(TEXTURE, UV);

    // Check if the current pixel is within the border region (top, left, right, bottom)
    if (UV.x < left_right_border_width_uv || UV.x > 1.0 - left_right_border_width_uv ||
        UV.y < top_bottom_border_width_uv || UV.y > 1.0 - top_bottom_border_width_uv) {
        // If within the border, set the color to the specified border color
        final_color.rgb = border_color;
    }

    // Output the final color
    COLOR = final_color;
}
