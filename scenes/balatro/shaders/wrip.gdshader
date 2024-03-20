shader_type canvas_item;

const vec2 center =  vec2(0.5,0.5);
uniform float intensity : hint_range(0.0, 20.0) = 9.14159265359;
varying float angle;
varying float time;
uniform float radius : hint_range(0.0, 1.0) = 0.5;

//loops through the sprite top to bottom, left to right pixel by pixel
void fragment(){
    // Get the current UV coordinates
    vec2 uv = UV;

	//Ignoring the outbound zone
	if(length(center - uv) > radius ) {
		COLOR = texture(TEXTURE, UV);
		}

	//Real work section
	else{
		time  = abs( cos(TIME * 1.0) );
		//Wrip effect making the angle relative to the distance to the center
		angle = intensity * (length(center - uv) - sqrt(0.5)) * time;

	    // Rotate the UV coordinates around the center of the sprite
	    uv -= vec2(0.5, 0.5);
	    uv = vec2(
	        uv.x * cos(angle) - uv.y * sin(angle),
	        uv.x * sin(angle) + uv.y * cos(angle)
	    );
	    uv += vec2(0.5, 0.5);

	    // Output the result pixel from the original texture
	    COLOR = texture(TEXTURE, uv);
	}

}