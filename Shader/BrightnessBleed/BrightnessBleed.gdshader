shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;          // Intensity of the neon glow
uniform float glow_radius : hint_range(0.0, 10.0) = 5.0;            // Glow blur radius

void fragment() {
    // Sample the base color
    vec4 base_color = texture(TEXTURE, UV);

    // Automatically get resolution from SCREEN_SIZE
    vec2 resolution = SCREEN_SIZE.xy;

    // Approximate a glow effect by sampling offsets
    vec3 glow = vec3(0.0);
    vec2 pixel_size = 1.0 / resolution;

    // Sampling four adjacent pixels to create a pseudo-glow effect
    glow += texture(TEXTURE, UV + vec2(pixel_size.x * glow_radius, 0.0)).rgb;
    glow += texture(TEXTURE, UV - vec2(pixel_size.x * glow_radius, 0.0)).rgb;
    glow += texture(TEXTURE, UV + vec2(0.0, pixel_size.y * glow_radius)).rgb;
    glow += texture(TEXTURE, UV - vec2(0.0, pixel_size.y * glow_radius)).rgb;

    // Average the glow contributions
    glow /= 4.0;

    // Scale by glow intensity
    glow *= glow_intensity;

    // Combine the base color with the glow
    vec3 final_color = base_color.rgb + glow;

    // Output the final color
    COLOR = vec4(final_color, base_color.a);
}
