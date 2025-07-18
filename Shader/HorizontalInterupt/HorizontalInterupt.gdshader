shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 50.0) = 20.0;
uniform float frequency : hint_range(0.0, 10.0) = 5.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform int step_count : hint_range(1, 128) = 8; // Fewer steps = chunkier movement

void fragment() {
    float pixel_height = SCREEN_PIXEL_SIZE.y;

    // Get the screen-space Y coordinate in pixels
    float y_px = floor(FRAGCOORD.y);

    // Create a stepped wave based on scanline
    float wave = sin(y_px * frequency * 0.01 + TIME * speed);

    // Snap to step_count levels
    float stepped_wave = floor(wave * float(step_count)) / float(step_count);

    // Horizontal offset in pixels converted to UV
    float offset = stepped_wave * (amplitude * SCREEN_PIXEL_SIZE.x);

    vec2 distorted_uv = UV + vec2(offset, 0.0);

    vec4 tex_color = texture(TEXTURE, distorted_uv);
    tex_color.a *= opacity;

    COLOR = tex_color;
}
