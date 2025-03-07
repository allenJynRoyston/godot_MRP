shader_type canvas_item;

uniform float size : hint_range(0.0, 50.0, 1.0) = 7.;
uniform float speed1 : hint_range(0.0, 20.0, 1.0) = 2.;
uniform float speed2 : hint_range(0.0, 10.0, 1.0) = 1.;
uniform vec3 color = vec3(1.0);

void fragment(){
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 R = iResolution.xy,
         v = sin( size*(FRAGCOORD.xy+FRAGCOORD.xy-R) / R.y + TIME * speed2 );
         //v = sin( 7.*(FRAGCOORD.xy+FRAGCOORD.xy-R) / R.y + TIME );
    COLOR = vec4( sin( 4.*atan(v.y,v.x) + speed1*TIME - 16.*length(v) )  - .1 );
    COLOR = .5 + COLOR/fwidth(COLOR);
	COLOR.rgb = COLOR.rgb * color;
}