shader_type canvas_item;

uniform sampler2D noise_texture;
uniform vec2 dir = vec2(0.5, 0.5);

void fragment() {
	//COLOR.rgb = texture(noise_texture, UV + (normalize(dir) * TIME)).rgb;
	COLOR.rgb = texture(noise_texture, UV).rgb;
}

