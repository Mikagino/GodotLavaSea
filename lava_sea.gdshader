shader_type spatial;

uniform sampler2D main_noise;
uniform sampler2D secondary_noise;
uniform float emission_strength = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(main_noise, UV + TIME * 0.005).rgb;
	float secondary_time = TIME * 0.01;
	vec3 secondary_color = texture(secondary_noise, vec2(UV.x - secondary_time, UV.y + secondary_time)).rgb * (abs(pow(sin(TIME * 0.5), 3.0)) / 3.0 + 0.1);
	ALBEDO = mix(ALBEDO, secondary_color, 0.5);
	//ALBEDO = secondary_color;
	EMISSION = ALBEDO * emission_strength * (1.0 - ALBEDO.r);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
