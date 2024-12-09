shader_type canvas_item;

uniform float dither_strength : hint_range(0.0, 1.0) = 0.5; // Strength of the dithering effect
uniform float dither_size : hint_range(1.0, 500.0) = 5.0;  // Size of the dither pattern (higher means finer pattern)

void fragment() {
    // Get the texture color at the current UV
    vec4 tex_color = texture(TEXTURE, UV);

    // Create a simple tiled pattern for dithering (like a checkerboard or grid)
    float pattern = mod(floor(UV.x * dither_size) + floor(UV.y * dither_size), 2.0);

    // Dither the color by modifying the brightness based on the pattern
    tex_color.rgb *= mix(1.0, 1.0 - dither_strength * pattern, step(0.5, pattern));

    // Set the final color
    COLOR = tex_color;
}
