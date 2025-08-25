shader_type spatial;

uniform vec4 override_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

render_mode unshaded, depth_draw_always, cull_disabled;

void fragment() {
    ALBEDO = override_color.rgb;
    ALPHA = override_color.a;

    // Ignore fog and lighting completely
    EMISSION = override_color.rgb; 
}
