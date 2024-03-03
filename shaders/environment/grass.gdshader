shader_type spatial;

uniform vec2 alb1_size = vec2(1.0, 1.0);
uniform vec2 alb2_size = vec2(1.0, 1.0);
uniform sampler2D albedo_a : hint_default_black;
uniform sampler2D albedo_b : hint_default_black;

void fragment() {
	vec3 a = texture(albedo_a, UV*alb1_size).rgb;
	vec3 b = texture(albedo_b, UV*alb2_size).rgb;
	vec3 c = a * b;
	ALBEDO = c;
}