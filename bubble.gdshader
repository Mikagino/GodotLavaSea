shader_type spatial;
render_mode shadows_disabled, unshaded, cull_back;

uniform sampler2D color_ramp;
uniform float fresnel_amount = 1.0;
uniform float emission_strength = 5.0;

instance uniform int start_time;
uniform float time;


void vertex() {
	float lifetime = (float(time) - INSTANCE_CUSTOM.r);
	VERTEX *= (0.5 + lifetime);
}


float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void fragment() {
	ALBEDO = texture(color_ramp, vec2(fresnel(fresnel_amount, NORMAL, VIEW), 0.0)).rgb;
	EMISSION = ALBEDO * emission_strength;
	ALPHA = 0.8;
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
