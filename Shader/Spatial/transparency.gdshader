shader_type spatial;
render_mode blend_mix;

uniform sampler2D TEXTURE; // Declare the texture uniform
uniform float Frequency = 1.0;
uniform float MaxOpacity : hint_range(0, 1) = 1.0;
uniform float MinimumOpacity : hint_range(.5, 1) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float base_alpha = tex_color.a; // Use the texture's alpha channel.

    ALBEDO = tex_color.rgb; // Use texture color for the mesh
    ALPHA = base_alpha * 0.1; // Adjust opacity dynamically
}
