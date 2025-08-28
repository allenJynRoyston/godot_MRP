shader_type spatial;
render_mode unshaded, cull_disabled, wireframe;

uniform vec4 line_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform bool enable_wireframe = true;  // toggle wireframe
uniform bool enable_pulse = true;      // toggle color pulse

// Animation parameters
uniform float pulse_speed = 2.0;
uniform float pulse_intensity = 0.5;

void fragment() {
    if (enable_wireframe) {
        vec3 final_color = line_color.rgb;

        // --- Optional animated color pulse ---
        if (enable_pulse) {
            float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
            final_color = mix(line_color.rgb, vec3(1.0, 0.0, 1.0), pulse * pulse_intensity);
        }

        // --- Glow effect ---
        final_color *= 2.0;  // Emission-like glow

        ALBEDO = final_color;
        EMISSION = final_color;
        ALPHA = line_color.a;
    } else {
        // Wireframe disabled: fully transparent
        ALPHA = 0.0;
        ALBEDO = vec3(0.0);
        EMISSION = vec3(0.0);
    }
}
