shader_type canvas_item;

uniform float edge_threshold : hint_range(0.0, 1.0) = 0.05; // Threshold for edge detection
uniform float dither_strength : hint_range(0.0, 1.0) = 0.5; // Strength of the dithering effect

void fragment() {
    // Get the texture color at the current UV
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Get the distance from the center of the texture
    float edge_distance = min(UV.x, min(UV.y, min(1.0 - UV.x, 1.0 - UV.y)));
    
    // Apply dithering effect at the edges based on distance
    if (edge_distance < edge_threshold) {
        // Add noise/dithering based on the edge distance
        float noise = fract(sin(UV.x * 12.9898 + UV.y * 78.233) * 43758.5453);
        noise = (noise - 0.5) * 2.0; // Scale the noise to the range of [-1, 1]
        
        // Blend the dithering effect with the tex_color based on the strength
        tex_color.rgb *= mix(1.0, 1.0 - dither_strength * noise, step(0.0, noise));
    }

    // Set the final color
    COLOR = tex_color;
}
