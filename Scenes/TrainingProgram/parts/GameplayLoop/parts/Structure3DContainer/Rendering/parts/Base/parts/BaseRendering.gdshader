shader_type spatial;

// Enable actual wireframe rendering
render_mode wireframe, unshaded;

uniform vec3 wire_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
    ALBEDO = wire_color; // Wireframe color
}
