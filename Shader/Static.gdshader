shader_type canvas_item;

uniform float noise_strength : hint_range(0.0, 1.0) = 1.0;
uniform float speed : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    // Generate pseudo-random noise using screen coordinates and time
    vec2 uv = UV;
    float time_factor = TIME * speed;

    // Simple hash function for noise
    float noise = fract(sin(dot(uv * time_factor, vec2(12.9898, 78.233))) * 43758.5453);

    // Adjust noise intensity
    noise = mix(0.5, noise, noise_strength);

    // Output grayscale noise
    COLOR = vec4(vec3(noise), 1.0);
}
