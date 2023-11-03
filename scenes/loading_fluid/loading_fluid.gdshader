shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec4 bg_color: source_color;
uniform vec4 wave_1_color: source_color;
uniform vec4 wave_2_color: source_color;
uniform float wave_seperation: hint_range(0.0, 0.3, 0.001) = 0.025;

void fragment() {
	float curve = sin((UV.x * 4.0) + (TIME * 5.0)) * (0.05);
	float curve_2 = cos((UV.x * 4.0) - (TIME * 5.0)) * (0.05);
	
	// Sine and cosine lines
	float cosine = smoothstep(1.0 - clamp(distance(curve_2 + UV.y, 1.0 - progress) * 1.0, 0.0, 1.0), 1.0, 0.999);
	float sine = smoothstep(1.0 - clamp(distance(curve + UV.y, 1.0 - progress) * 1.0, 0.0, 1.0), 1.0, 0.999);

	// Full wave
	float wave_filled = step(1.0 - progress - wave_seperation, UV.y + curve);
	float wave_2_filled = step(1.0 - progress + wave_seperation, UV.y + curve_2);

	vec3 wave_colored = (vec3(wave_filled) * wave_1_color.rgb);
	vec3 wave_2_colored = (vec3(wave_2_filled) * wave_2_color.rgb);

	vec3 waves_color = mix(wave_colored, wave_2_colored, wave_2_filled);
	
	COLOR.rgb = mix(bg_color.rgb, waves_color, max(wave_2_filled, wave_filled));
}
