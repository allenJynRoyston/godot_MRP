shader_type canvas_item;

uniform float bleed_strength : hint_range(0.0, 1.0) = 0.3;  // Strength of the bleed effect
uniform float blur_radius : hint_range(0.0, 10.0) = 1.0;   // Amount of soft blur for the bleed

void fragment() {
    // Sample the texture at the current UV
    vec4 screen_texture = texture(TEXTURE, UV);

    // Convert the color to grayscale (luminosity method) to determine brightness
    float brightness = dot(screen_texture.rgb, vec3(0.299, 0.587, 0.114));

    // Apply the bleed effect by spreading bright regions
    vec4 bleed_color = screen_texture;
    float spread = smoothstep(0.6, 1.0, brightness);  // Smooth transition for bright areas

    // Apply a blur effect around bright regions (simple blur based on the brightness)
    vec2 offset = vec2(blur_radius / 100.0, 0.0);  // Horizontal blur direction (adjust for softness)
    vec4 blurred_texture = texture(TEXTURE, UV + offset);
    vec4 final_color = mix(bleed_color, blurred_texture, spread * bleed_strength);  // Mix blur with bleed effect

    // Output the final color
    COLOR = final_color;
}
