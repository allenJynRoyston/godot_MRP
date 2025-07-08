shader_type canvas_item;

// Horizontal (Y-based scanline) controls
uniform bool enable_horizontal = true;
uniform float amplitude_h : hint_range(0.0, 50.0) = 20.0;
uniform float frequency_h : hint_range(0.0, 10.0) = 5.0;
uniform float speed_h : hint_range(0.0, 10.0) = 1.0;
uniform float opacity_h : hint_range(0.0, 1.0) = 1.0;
uniform int step_count_h : hint_range(1, 128) = 8;

// Vertical (X-based columnline) controls
uniform bool enable_vertical = true;
uniform float amplitude_v : hint_range(0.0, 50.0) = 20.0;
uniform float frequency_v : hint_range(0.0, 10.0) = 5.0;
uniform float speed_v : hint_range(0.0, 10.0) = 1.0;
uniform float opacity_v : hint_range(0.0, 1.0) = 1.0;
uniform int step_count_v : hint_range(1, 128) = 8;

void fragment() {
    float offset_x = 0.0;
    float offset_y = 0.0;

    // Horizontal distortion (Y-axis based)
    if (enable_horizontal) {
        float y_px = floor(FRAGCOORD.y);
        float wave_h = sin(y_px * frequency_h * 0.01 + TIME * speed_h);
        float stepped_wave_h = floor(wave_h * float(step_count_h)) / float(step_count_h);
        offset_x = stepped_wave_h * (amplitude_h * SCREEN_PIXEL_SIZE.x);
    }

    // Vertical distortion (X-axis based)
    if (enable_vertical) {
        float x_px = floor(FRAGCOORD.x);
        float wave_v = sin(x_px * frequency_v * 0.01 + TIME * speed_v);
        float stepped_wave_v = floor(wave_v * float(step_count_v)) / float(step_count_v);
        offset_y = stepped_wave_v * (amplitude_v * SCREEN_PIXEL_SIZE.y);
    }

    vec2 distorted_uv = UV + vec2(offset_x, offset_y);

    vec4 tex_color = texture(TEXTURE, distorted_uv);

    // Apply opacity blending
    float final_opacity = 1.0;
    if (enable_horizontal && enable_vertical) {
        final_opacity = mix(opacity_h, opacity_v, 0.5);
    } else if (enable_horizontal) {
        final_opacity = opacity_h;
    } else if (enable_vertical) {
        final_opacity = opacity_v;
    }

    tex_color.a *= final_opacity;

    COLOR = tex_color;
}
