shader_type canvas_item;

void fragment() {
    // Get the texture color at the current UV
    vec4 tex_color = texture(TEXTURE, UV);

    // Convert to grayscale using a weighted average (luminance)
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Set the final color as grayscale
    COLOR = vec4(vec3(gray), tex_color.a);
}
