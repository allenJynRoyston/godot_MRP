shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float alpha :hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // If the texture is black, use alpha to define areas to tint
    float final_alpha = tex_color.a * tint_color.a * alpha; // Preserve alpha for masking
    COLOR = vec4(tint_color.rgb * final_alpha, final_alpha);
}