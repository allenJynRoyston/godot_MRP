shader_type canvas_item;

// Number of kaleidoscope segments (greater than or equal to 2)
uniform int segments = 6;

void fragment() {
    // Angle of a single segment
    float angle_step = 2.0 * PI / float(segments);
    
    // Compute the angle of the UV coordinate
    float angle = atan(UV.y - 0.5, UV.x - 0.5);
    float radius = length(UV - vec2(0.5));
    
    // Normalize the angle to fit into a single segment
    angle = mod(angle, angle_step);
    if (angle > angle_step / 2.0) {
        // Mirror the angle to create the reflection effect
        angle = angle_step - angle;
    }
    
    // Transform the polar coordinates back to UV space
    vec2 new_uv = vec2(cos(angle), sin(angle)) * radius + vec2(0.5);
    
    // Sample the texture using the modified UV coordinates
    vec4 tex_color = texture(TEXTURE, new_uv);
    
    COLOR = tex_color;
}
