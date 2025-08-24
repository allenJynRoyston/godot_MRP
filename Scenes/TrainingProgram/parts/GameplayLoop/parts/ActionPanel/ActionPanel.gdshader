shader_type canvas_item;

uniform vec2 tex_size; // set to your texture size in pixels
uniform float static_strength : hint_range(0.0, 1.0) = 0.3;
uniform float static_speed : hint_range(0.1, 10.0) = 3.0;

uniform vec4 trail_color : source_color = vec4(1.0, 0.9, 0.2, 1.0);
uniform float spark_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float spark_distance : hint_range(1.0, 20.0) = 10.0;
uniform float spark_density : hint_range(0.0, 1.0) = 0.5;
uniform vec2 spark_direction = vec2(-0.2, 50.0); // downward rain + slight left
uniform float spark_speed : hint_range(0.1, 5.0) = 1.0;
uniform float trail_length : hint_range(1.0, 15.0) = 6.0;
uniform int trail_steps : hint_range(1, 200) = 6;

// Edge expansion for pixels at the borders
uniform float edge_expand : hint_range(0.0, 0.1) = 0.02;

// Oscillation settings
uniform float oscillation_pixels : hint_range(0.0, 20.0) = 5.0; // max deviation in pixels
uniform float osc_speed_x : hint_range(0.0, 5.0) = 0.5;
uniform float osc_speed_y : hint_range(0.0, 5.0) = 0.8;
uniform float trail_override : hint_range(0.0, 1.0) = 0.1; // chance to continue past opaque pixels

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    // --- Expand UV outward to include edge pixels ---
    vec2 uv_expand = clamp(UV + (UV - vec2(0.5)) * edge_expand, 0.0, 1.0);
    vec4 tex = texture(TEXTURE, uv_expand);
    float alpha_center = tex.a;

    // --- TV STATIC ---
    float noise = rand(vec2(UV.x * TIME * static_speed, UV.y * TIME * static_speed));
    vec3 static_col = mix(tex.rgb, vec3(noise), static_strength);

    // --- EDGE DETECTION ---
    float px = 1.0 / tex_size.x;
    float py = 1.0 / tex_size.y;
    bool is_edge_pixel = false;
    float neighbor_threshold = 0.1;

    // Pixels at the texture border automatically considered edge
    if (UV.x <= 0.0 || UV.x >= 1.0 || UV.y <= 0.0 || UV.y >= 1.0) {
        is_edge_pixel = true;
    } else if (alpha_center < 0.5) {
        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                if (x == 0 && y == 0) continue;
                float neighbor_alpha = texture(TEXTURE, UV + vec2(float(x)*px, float(y)*py)).a;
                if (neighbor_alpha > neighbor_threshold) {
                    is_edge_pixel = true;
                    break;
                }
            }
            if (is_edge_pixel) break;
        }
    }

    // --- SPARK TRAIL ---
    vec3 spark_accum = vec3(0.0);
    vec2 dir = normalize(spark_direction);

    // --- Oscillation offset in UV space (subtle sway) ---
    vec2 osc_uv = vec2(oscillation_pixels / tex_size.x, oscillation_pixels / tex_size.y);
    vec2 dir_offset = vec2(
        sin(TIME * osc_speed_x) * osc_uv.x,
        cos(TIME * osc_speed_y) * osc_uv.y
    );

    if (is_edge_pixel) {
        for (int i = 0; i < trail_steps; i++) {
            float t = float(i) / float(trail_steps);

            // Apply the oscillation as a UV offset along the trail
            vec2 sample_uv = UV - dir * (t * spark_distance / 100.0 + TIME * spark_speed / 50.0) - dir_offset;

            float glitter = rand(floor(sample_uv * 200.0));
            glitter = step(1.0 - spark_density, glitter);

            // --- Trail continuation: mostly stops on opaque pixels, but small chance to continue ---
			float sample_alpha = texture(TEXTURE, sample_uv).a;

			// If moving into opaque pixel, reduce contribution but don't stop
			float alpha_factor = sample_alpha < 0.5 ? 1.0 : trail_override;

            float fade = exp(-t * trail_length) * (1.0 - t) * alpha_factor;

            // Ripple effect on trail color only
            float ripple = 0.8 + 0.2 * sin(TIME * 3.0 + t * 5.0);

            vec3 step_color = trail_color.rgb * spark_intensity * glitter * fade * ripple;
            spark_accum += step_color;
        }
    }

    // --- FINAL COLOR ---
    vec3 final_rgb = static_col + spark_accum;
    float final_alpha = max(alpha_center, max(spark_accum.r, max(spark_accum.g, spark_accum.b)));

    COLOR = vec4(final_rgb, final_alpha);
}
