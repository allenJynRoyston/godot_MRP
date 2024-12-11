shader_type canvas_item;

uniform float bend_amount : hint_range(0.0, 1.0) = 0.1;     // Strength of CRT bending effect
uniform float bend_offset : hint_range(0.0, 0.5) = 0.2;     // Offset for bending effect from the edges

// Function to bend the image outward with an offset
vec2 crt_bend(vec2 uv, float ba, float bo) {
    vec2 offset = uv - vec2(0.5);  // Center the UV coordinates
    float radius = length(offset); // Calculate the distance from the center

    // Apply an inward offset so the bend starts away from the edges
    radius = max(radius - bo, 0.0);  // Ensure bending only happens within the region after offset

    // Apply the bend effect based on the radius and bend amount
    offset *= (1.0 + ba * radius * radius);  // Bending becomes stronger further from the center

    return offset + vec2(0.5);  // Recenter the UV coordinates
}

void fragment() {
    // Apply CRT bend with offset to the UV coordinates
    vec2 bent_uv = crt_bend(UV, bend_amount, bend_offset);

    // Sample the texture with the bent UV coordinates
    vec4 final_color = texture(TEXTURE, bent_uv);

    // Output the final color
    COLOR = final_color;
}