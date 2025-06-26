shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 50.0) = 20.0;
uniform float frequency : hint_range(0.0, 10.0) = 5.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    // Get the pixel height in UV space
    float pixel_height = SCREEN_PIXEL_SIZE.y;

    // Quantize y so each "line" acts independently — like scanlines
    float line = floor(UV.y / pixel_height);

    // Create horizontal offset using sine wave
    float offset = sin(line * frequency + TIME * speed) * (amplitude * SCREEN_PIXEL_SIZE.x);

    // Apply horizontal offset to UV
    vec2 distorted_uv = UV + vec2(offset, 0.0);

    // Sample the texture with distorted UVs
    COLOR = texture(TEXTURE, distorted_uv);
}
