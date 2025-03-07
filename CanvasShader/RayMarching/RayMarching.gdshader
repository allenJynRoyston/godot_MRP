shader_type canvas_item;

#define iTime TIME
#define iResolution 1.0/SCREEN_PIXEL_SIZE

uniform vec3 color1 = vec3(0.5, 0.5, 0.5);
uniform vec3 color2 = vec3(0.5, 0.5, 0.5);
uniform vec3 color3 = vec3(1., 1., 1.);
uniform vec3 color4 = vec3(0., 0.1, 0.2);
uniform float grandient : hint_range(0.01, 2.0, 0.01) = 0.04;
uniform float zoom : hint_range(0, 2., 0.1) = 1.0;
uniform vec2 disp = vec2(0.0);
uniform vec2 rot_angle = vec2(1.0);
uniform float wiggle : hint_range(0.0, 5.0, 0.1) = 0.35;
uniform float speed1 : hint_range(0.0, 10.0, 0.1) = 0.2;
uniform float speed2 : hint_range(0.0, 10.0, 0.1) = 0.2;
uniform float speed3 : hint_range(0.0, 5.0, 0.1) = 0.4;


// Box sdf function
float sdBox ( vec3 p, vec3 b ) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

//Octahedron
float sdOctahedron( vec3 p, float s) {
  p = abs(p);
  return (p.x+p.y+p.z-s)*0.57735027;
}

float map(vec3 p) {
    p.z += iTime * speed3;                     // Move effect

    // Space Repetition
    p.xy = (fract(p.xy) - .5);             // Spacing by 1
    p.z = mod(p.z, .25) - 0.125;            // Spacing by .25

    float box = sdOctahedron(p, .15);       // SDF

    return box;
}

// Coloring
vec3 palette(float t) {
    vec3 a = color1;
    vec3 b = color2;
    vec3 c = color3;
    vec3 d = color4;

    return a + b * cos(6.28318 * (c * t + d));
}

// 2D Rotation
mat2 rot2D(float angle) {
    float s = sin(angle * rot_angle.x);
    float c = cos(angle * rot_angle.y);
    return mat2(vec2(c, -s), vec2(s, c));
}

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    //vec2 m = (iMouse.xy * 2. - iResolution.xy) / iResolution.y;
    vec2 m = uv;

    // Initialization
    vec3 ro = vec3(disp.x, disp.y, -0);             // Ray origin
    vec3 rd = normalize(vec3(uv, 1)) * zoom;     // Ray zoom
    vec3 col = vec3(0);

    float t = 0.0;                         // Total distance travelled

    // Default circular motion if mouse is not clicked
    m = vec2(cos(iTime * speed1), sin(iTime * speed2));

    // Raymarching
    int i;
    for (int i = 0; i < 80; i++) {
        vec3 p = ro + rd * t;             // Posiiton along the ray

        p.xy *= rot2D(t * 0.2 * m.x);      // Rotate ray around z-axis

        p.y += sin(t * (m.y + 1.) * 0.5) * wiggle;                 // Wiggle

        float d = map(p);                 // Current distance to the scene

        t += d;                           // March the rays

        col = vec3(float(i)) / 80.;

        if (d < .001 || t > 100.) break;  // Early Stop

    }

    // Coloring
    col = palette(t * grandient + float(i) * 0.005);         // Lower the float value to see further away

    COLOR = vec4(col, 1);
}