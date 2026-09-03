shader_type spatial;
render_mode shadows_disabled, unshaded, cull_disabled, alpha_to_coverage;

uniform sampler2D color_ramp;
uniform float fresnel_amount = 1.0;
uniform float emission_strength = 5.0;
uniform float pop_to_end_time_factor = 0.7;

instance uniform float start_time;
uniform float time;
varying float end_time;
varying float current_lifetime;

varying vec3 vertex_pos;

void vertex() {
	current_lifetime = (float(time) - INSTANCE_CUSTOM.r);
	VERTEX *= pow(current_lifetime, 0.5);
	end_time = INSTANCE_CUSTOM.g;
	vertex_pos = VERTEX;
}


float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void fragment() {
	ALBEDO = texture(color_ramp, vec2(fresnel(fresnel_amount, NORMAL, VIEW), 0.0)).rgb;
	EMISSION = ALBEDO * emission_strength;
	ALPHA = 0.8;
	float pop_to_start_time_factor = 1.0 - pop_to_end_time_factor;
	ALPHA = normalize(-(vertex_pos.z + current_lifetime - pop_to_end_time_factor * end_time)) * 0.8;
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
