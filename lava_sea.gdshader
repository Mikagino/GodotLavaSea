shader_type spatial;


uniform sampler2D main_noise;
uniform float main_noise_scale = 0.08;
uniform sampler2D secondary_noise;
uniform float secondary_noise_scale = 1.0;
uniform float move_speed = 0.02;
uniform sampler2D wave_noise;
uniform float wave_texture_scale = 1.0;
uniform float wave_strength = 1.0;
uniform float emission_strength = 1.0;

varying vec3 position;


void vertex() {
	position = VERTEX;
}

// Blending methods
// based on: https://github.com/jamieowen/glsl-blend
float linear_burn_f(float base, float blend) {
	return base + blend - 1.0;
}

vec3 linear_burn(vec3 base, vec3 blend) {
	return vec3(linear_burn_f(base.r, blend.r), linear_burn_f(base.g, blend.g),linear_burn_f(base.b, blend.b));
}


float linear_dodge_f(float base, float blend) {
	return base + blend;
}

vec3 linear_dodge(vec3 base, vec3 blend) {
	return vec3(linear_dodge_f(base.r, blend.r), linear_dodge_f(base.g, blend.g), linear_dodge_f(base.b, blend.b));
}


float linear_light_f(float base, float blend) {
	return blend<0.5?linear_burn_f(base,(2.0*blend)):linear_dodge_f(base,(2.0*(blend-0.5)));
}

vec3 linear_light(vec3 base, vec3 blend) {
	return vec3(linear_light_f(base.r,blend.r), linear_light_f(base.g,blend.g), linear_light_f(base.b,blend.b));
}

vec3 linear_light(vec3 base, vec3 blend, float opacity) {
	return (linear_light(base, blend) * opacity + base * (1.0 - opacity));
}


void fragment() {
	float secondary_time = TIME * 0.01;
	vec3 final_position = linear_light(position * main_noise_scale, texture(wave_noise, vec2(position.x - secondary_time, position.y - secondary_time) * wave_texture_scale).rgb, wave_strength);
	vec3 main_color = texture(main_noise, final_position.xy + TIME * move_speed).rgb;
	ALBEDO = main_color;
	vec3 secondary_color = texture(secondary_noise, secondary_noise_scale * vec2(position.x - secondary_time, position.y + secondary_time)).rgb * (abs(pow(sin(TIME * 0.5), 3.0)) / 2.0 + 0.1);
	ALBEDO = mix(ALBEDO, secondary_color, 0.5);
	ALBEDO = ALBEDO * main_color.r;
	EMISSION = ALBEDO * emission_strength * (1.0 - ALBEDO.r);
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
