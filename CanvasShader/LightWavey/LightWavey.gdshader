shader_type canvas_item;

// === Opacity Controls ===
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform bool use_texture_alpha = false;
uniform bool use_dynamic_opacity = false;

// === NES Line Scroll Emulation ===
uniform bool enable_line_scroll = true;
uniform float scroll_speed : hint_range(0.0, 10.0) = 1.0;     // Speed of scroll movement
uniform float scroll_amplitude : hint_range(0.0, 0.2) = 0.05; // How far each line moves horizontally
uniform float scroll_frequency : hint_range(0.0, 100.0) = 40.0; // How dense the waves are

void fragment() {
    vec2 uv = UV;

    if (enable_line_scroll) {
        // Emulate NES scanline scroll offset
        float offset = sin(uv.y * scroll_frequency + TIME * scroll_speed) * scroll_amplitude;
        uv.x += offset;
    }

    vec4 tex = texture(TEXTURE, uv);

    float final_alpha = opacity;
    if (use_dynamic_opacity) {
        final_alpha *= (0.5 + 0.5 * sin(TIME));
    }
    if (use_texture_alpha) {
        final_alpha *= tex.a;
    }

    COLOR = vec4(tex.rgb, final_alpha);
}
