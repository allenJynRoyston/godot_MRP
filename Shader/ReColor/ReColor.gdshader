shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // If the texture is black, use alpha to define areas to tint
    float alpha = tex_color.a; // Preserve alpha for masking
    COLOR = vec4(tint_color.rgb * alpha, alpha);
}