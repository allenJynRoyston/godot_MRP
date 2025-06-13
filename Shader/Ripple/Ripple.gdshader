shader_type canvas_item;

uniform float ripple_center_x : hint_range(-1.0, 1.0) = 0.5;
uniform float ripple_center_y : hint_range(-1.0, 1.0) = 0.5;
uniform float ripple_speed : hint_range(0.0, 10.0) = 2.0; // <-- new speed control

void fragment() {
    // Create the vec2 center from the two float values
    vec2 center = vec2(ripple_center_x, ripple_center_y);

    vec4 screen_texture = texture(TEXTURE, UV);

    // Calculate the distance from the ripple center
    float dist = length(UV - center);

    // Create the ripple effect using a sine wave with adjustable speed
    float ripple = sin(dist * 5.0 - TIME * ripple_speed) * 0.2 / (dist + 0.1);

    // Distort the UV coordinates based on the ripple
    vec2 ripple_uv = UV + vec2(ripple, ripple);

    // Sample the texture with the distorted UVs
    screen_texture = texture(TEXTURE, ripple_uv);

    COLOR = screen_texture;
}
