shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float size = 20.0;       // pixel size of squares
uniform float speed_x = 0.5;     // horizontal speed (UV units per second)
uniform float speed_y = 0.2;     // vertical speed (UV units per second)
uniform float rotation_speed = 0.5; // radians per second

void fragment() {
    // Node-relative UV coordinates
    vec2 uv = UV * (size); // scale to control number of squares

    // Center UVs for rotation
    vec2 centered = uv - vec2(0.5 * size);

    // Rotate over time
    float angle = TIME * rotation_speed;
    float c = cos(angle);
    float s = sin(angle);
    mat2 rot = mat2(vec2(c, -s), vec2(s, c));
    centered = rot * centered;

    // Apply drifting speed
    vec2 offset = vec2(speed_x, speed_y) * TIME;
    uv = centered + vec2(0.5 * size) + offset;

    // Checkerboard pattern
    float checker = mod(floor(uv.x) + floor(uv.y), 2.0);
    COLOR = mix(color1, color2, checker);
}
