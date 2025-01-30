shader_type canvas_item;

uniform float frequency = 20.0; // Number of waves across the screen
uniform float amplitude = 0.3;  // Height of the wave
uniform float speed = 3.0;      // Speed of animation
uniform float thickness = 0.03; // Thickness of the line

void fragment() {
    vec2 uv = UV;

    // Use a more complex wave function for a plasma-like squiggly effect
    float wave = sin(uv.x * frequency + TIME * speed) * amplitude +
                 sin(uv.x * frequency * 0.5 + TIME * speed * 1.5) * amplitude * 0.5 +
                 cos(uv.x * frequency * 0.8 + TIME * speed * 2.0) * amplitude * 0.3;

    // Center the wave in the texture rect
    float line_y = 0.5 + wave;

    // Control the thickness of the line
    float alpha = smoothstep(thickness, 0.0, abs(uv.y - line_y));

    // Add a plasma-like color variation using sin waves
    float red = 0.5 + 0.5 * sin(TIME * 3.0 + uv.x * frequency * 1.5);
    float green = 0.5 + 0.5 * sin(TIME * 2.0 + uv.x * frequency * 2.0);
    float blue = 0.5 + 0.5 * cos(TIME * 2.0 + uv.x * frequency * 2.0);

    // Set the final color: dynamic plasma-like line with red, green, and blue on a transparent background
    COLOR = vec4(red, green, blue, alpha);
}
