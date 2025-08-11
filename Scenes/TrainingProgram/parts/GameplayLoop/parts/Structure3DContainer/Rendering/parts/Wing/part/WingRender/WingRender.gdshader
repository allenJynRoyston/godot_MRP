shader_type spatial;
render_mode unshaded, depth_draw_never, cull_disabled;

uniform vec4 base_color : source_color = vec4(1.0, 0.0, 0.0, 0.6); // Red & semi-transparent
uniform float speed = 2.0;
uniform float thickness = 0.02; // Width of the box line

void fragment() {
    // Centered UV (0,0 in middle)
    vec2 centered_uv = UV * 2.0 - 1.0;
    float max_dist = max(abs(centered_uv.x), abs(centered_uv.y)); // Box shape
    float wave = fract(max_dist - TIME * 0.2 * speed); // Animate outward waves

    // Create a thin ring using smoothstep
    float border = smoothstep(thickness, 0.0, abs(wave - 0.5)); // 0 at center, 1 at wave

    // Pulse alpha with time for extra effect
    float pulse = 0.5 + 0.5 * sin(TIME * 4.0);

    ALBEDO = base_color.rgb;
    ALPHA = base_color.a * border * pulse;
}
