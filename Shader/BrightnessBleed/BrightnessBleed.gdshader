shader_type canvas_item;

uniform float bleed_amount : hint_range(0.0, 1.0) = 0.5;    // Intensity of brightness bleed
uniform vec2 resolution = vec2(320.0, 180.0);               // Resolution for bleed effect
uniform float bend_amount : hint_range(0.0, 1.0) = 0.1;     // Strength of CRT bending effect
uniform float bend_offset : hint_range(0.0, 0.5) = 0.2;     // Offset for bending effect from the edges
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.5; // Intensity of scanline effect
uniform float scanline_frequency : hint_range(0.0, 1.0) = 0.1; // Frequency of scanlines (line spacing)
uniform float top_bottom_border_pixels : hint_range(0.0, 100.0) = 20.0;  // Pixel width of top and bottom black borders
uniform float left_right_border_pixels : hint_range(0.0, 100.0) = 20.0;  // Pixel width of left and right black borders


// Function to bend the image outward with an offset
vec2 crt_bend(vec2 uv, float ba, float bo) {
    vec2 offset = uv - vec2(0.5);  // Center the UV coordinates
    float radius = length(offset); // Calculate the distance from the center

    // Apply an inward offset so the bend starts away from the edges
    radius = max(radius - bo, 0.0);  // Ensure bending only happens within the region after offset

    // Apply the bend effect based on the radius and bend amount
    offset *= (1.0 + ba * radius * radius);  // Bending becomes stronger further from the center

    return offset + vec2(0.5);  // Recenter the UV coordinates
}

// Function to add the scanline effect
float scanline_effect(vec2 uv, float strength, float frequency) {
    // Create thicker scanlines by reducing the frequency and adding a wider line pattern
    float scanline = mod(floor(uv.y * frequency), 3.0); // Using "3.0" makes the scanlines thicker
    return mix(1.0, 1.0 - strength, scanline);  // Darken every 3rd line based on scanline pattern
}

void fragment() {
    // Calculate the border widths in UV space based on pixel values and resolution
    float top_bottom_border_width_uv = top_bottom_border_pixels / resolution.y;
    float left_right_border_width_uv = left_right_border_pixels / resolution.x;

    // Start by assuming we will output the original color
    vec4 final_color = texture(TEXTURE, UV);

    // Check if the current pixel is within the border region (top, left, right, bottom)
    if (UV.x < left_right_border_width_uv || UV.x > 1.0 - left_right_border_width_uv ||
        UV.y < top_bottom_border_width_uv || UV.y > 1.0 - top_bottom_border_width_uv) {
        // If within the border, set the color to black
        final_color.rgb = vec3(0.0);
    } else {
        // Apply CRT bend with offset to the UV coordinates
        vec2 bent_uv = crt_bend(UV, bend_amount, bend_offset);

        // Sample the texture with the bent UV coordinates
        vec4 screen_texture = texture(TEXTURE, bent_uv);

        // Brightness bleed effect
        vec3 bleed = vec3(0.0);
        vec2 pixel_size = 1.0 / resolution;

        // Loop through neighboring pixels to create the bleed effect
        float blur_radius = 2.0; // Size of the bleed radius
        for (int x = -2; x <= 2; x++) {
            for (int y = -2; y <= 2; y++) {
                vec2 offset = pixel_size * vec2(float(x), float(y));
                vec3 neighbor_color = texture(TEXTURE, bent_uv + offset).rgb;
                float weight = 1.0 - length(vec2(float(x), float(y))) / blur_radius;
                bleed += neighbor_color * neighbor_color * weight; // Weighted brightness emphasis
            }
        }

        bleed /= 25.0;               // Normalize the bleed effect
        bleed *= bleed_amount;       // Scale by the bleed amount

        // Apply the scanline effect
        float scanline_factor = scanline_effect(UV, scanline_strength, scanline_frequency);

        // Combine the original color, brightness bleed, and scanline effect
        final_color.rgb = (screen_texture.rgb + bleed) * scanline_factor;
    }

    // Output the final color
    COLOR = final_color;
}
