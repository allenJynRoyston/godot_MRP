shader_type spatial;
render_mode unshaded, depth_draw_never, cull_disabled;

uniform vec4 behind_color : source_color = vec4(1.0, 0.0, 0.0, 0.4); // Red & transparent

void fragment() {
    ALBEDO = behind_color.rgb;
    ALPHA = behind_color.a;
}
