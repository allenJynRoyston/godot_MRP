shader_type canvas_item;

// --- Uniforms --- //
// Angle is entered in degrees but converted to radians internally
uniform float percentage: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float angle_degrees: hint_range(0.0, 180.0, 1.0) = 0.0; // Angle hint in degrees
uniform float line_width: hint_range(0.0, 1.0, 0.01) = 0.02;
uniform vec4 line_color: source_color = vec4(1.0);
uniform vec4 laser_color: source_color = vec4(1.0, 0.0, 0.0, 1.0); // Bright laser color
uniform float glow_width: hint_range(0.0, 0.1, 0.01) = 0.05; // Width of the laser glow
uniform float trail_fade: hint_range(0.0, 1.0, 0.01) = 0.5; // Intensity of trail fading

// --- Functions --- //
vec2 rotate(vec2 _pos, float _sine, float _cosine) {
    return vec2(_pos.x * _cosine + _pos.y * -_sine, _pos.x * _sine + _pos.y * _cosine);
}

void fragment() {
    // Convert angle from degrees to radians
    float angle = radians(angle_degrees);

    float sine = sin(angle);
    float cosine = cos(angle);
    float len = abs(sine) + abs(cosine);

    // Calculate distance along the rotated axis
    float dist = (rotate(((UV) - vec2(0.5)) / len, sine, cosine).y + 0.5) * (1.0 - line_width);

    // Line etching
    float line = step(percentage, dist);
    COLOR.a -= line;
    COLOR.rgb = mix(COLOR.rgb, line_color.rgb, step(percentage, dist + line_width));

    // --- Laser etching effect --- //

    // Laser glow at the leading edge
    float glow = smoothstep(percentage - glow_width, percentage, dist);

    // Trail behind the etching point
    float trail = smoothstep(percentage - trail_fade, percentage, dist);

    // Add glow and trail to the output
    vec4 laser_effect = laser_color * (glow + trail * 0.5); // Trail fades out with 50% intensity
    COLOR.rgb = mix(COLOR.rgb, laser_effect.rgb, laser_effect.a);
}
