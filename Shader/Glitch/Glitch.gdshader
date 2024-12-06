shader_type canvas_item;

uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.1; // Default glitch intensity
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.05; // Default noise intensity
uniform float glitch_speed : hint_range(0.0, 10.0) = 5.0; // Speed of the glitch displacement

// Property for glitch interval (time between glitches in seconds)
uniform float glitch_interval : hint_range(1.0, 20.0) = 5.0; // Glitch interval in seconds

// Randomness range for glitch duration
uniform float min_glitch_duration : hint_range(0.1, 3.0) = 0.5; // Minimum duration of the glitch (seconds)
uniform float max_glitch_duration : hint_range(0.1, 3.0) = 1.0; // Maximum duration of the glitch (seconds)

// Function to generate random noise
float random_noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Generate a random glitch duration
    float glitch_duration = mix(min_glitch_duration, max_glitch_duration, random_noise(vec2(TIME + 100.0, 0.0))); // Randomize glitch duration

    // Create a periodic signal for glitch start and stop, using the fixed glitch_interval
    float glitch_time = mod(TIME, glitch_interval + glitch_duration); // Create looping time value
    float max_glitch_effect = smoothstep(0.0, 1.0, glitch_time); // Ramp from 0 to 1 during the glitch duration

    // Multiply the max_glitch_effect to the glitch intensity and noise intensity to ramp them up for 1 second
    float effective_glitch_intensity = glitch_intensity * (1.0 - max_glitch_effect); // Fade out after the glitch duration
    float effective_noise_intensity = noise_intensity * (1.0 - max_glitch_effect); // Fade out after the glitch duration

    // Ramp up the noise intensity gradually over time before the glitch happens
    // Increase the ramping period for a slower ramp-up
    float noise_ramp_up = smoothstep(glitch_interval * 0.1, glitch_interval, glitch_time); // Increase the ramp duration to 10% of the glitch interval
    effective_noise_intensity *= noise_ramp_up; // Apply the ramped noise intensity

    // Add time-based glitch displacement with scaled-down intensity for subtlety
    float displacement = sin(TIME * glitch_speed + UV.y * 100.0) * effective_glitch_intensity * 0.05;  // Further reduced displacement

    // Add random horizontal displacement for glitch effect
    vec2 uv_displaced = UV + vec2(displacement, 0.0); // Only move horizontally

    // Sample the texture with the displaced UVs
    vec4 screen_texture = texture(TEXTURE, uv_displaced);

    // Add some noise to simulate static, based on the dynamic noise intensity
    float noise = random_noise(UV + vec2(TIME * 0.1, 0.0)) * effective_noise_intensity;
    screen_texture.rgb += vec3(noise);  // Adding the noise to the RGB channels

    // Final color output
    COLOR = screen_texture;
}
