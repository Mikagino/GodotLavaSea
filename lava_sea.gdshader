shader_type spatial;

uniform sampler2D main_noise;
uniform float emission_strength = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(main_noise, UV).rgb;
	EMISSION = ALBEDO * emission_strength * (1.0 - ALBEDO.r);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
