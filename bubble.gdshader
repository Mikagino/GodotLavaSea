shader_type spatial;
render_mode shadows_disabled, unshaded, cull_disabled, alpha_to_coverage;

uniform sampler2D color_ramp;
uniform float fresnel_amount = 1.0;
uniform float emission_strength = 5.0;
uniform float pop_to_end_time_factor = 0.7;
uniform sampler2D global_tint_noise;
uniform float global_tint_noise_scale = 0.02;
uniform float transparency = 0.8;

uniform float time;
varying float end_time;
varying float current_lifetime;

varying vec3 vertex_pos;
varying vec3 global_pos;
varying float instance_id;
varying float enabled;


void vertex() {
	enabled = INSTANCE_CUSTOM.b;
	if(INSTANCE_CUSTOM.b != 0.0){
		current_lifetime = float(time) - INSTANCE_CUSTOM.r;
		VERTEX *= pow(current_lifetime, 0.5);
		end_time = INSTANCE_CUSTOM.g;
		vertex_pos = VERTEX;
		global_pos = MODEL_MATRIX[3].xyz;
		instance_id = float(INSTANCE_ID);
	}
}


float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void fragment() {
	if(enabled != 0.0) {
		ALBEDO = texture(color_ramp, vec2(fresnel(fresnel_amount, NORMAL, VIEW), 0.0)).rgb;
		ALBEDO = mix(ALBEDO, texture(global_tint_noise, global_pos.xy * global_tint_noise_scale).rgb, 0.5);
		EMISSION = ALBEDO * emission_strength;
		ALPHA = normalize(-(vertex_pos.z + current_lifetime - pop_to_end_time_factor * end_time)) * transparency;
	}
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
