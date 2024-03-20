@tool
extends RichTextEffect
class_name RichTextRotation

# Syntax: [rotation rot=15.0][/rotation]

# Define the tag name
var bbcode = "rotation"

func _process_custom_fx(char_fx: CharFXTransform):
	# Get parameters, or use the provided default value if missing.
	var angle = deg_to_rad(char_fx.env.get("rot", 0.0))
	# TODO: Find a way to get the total amount of glyph without 
	# having to inpute it ourself 
	var char_count = char_fx.env.get("char_count", 1)

	var offset: float = char_fx.relative_index / char_count
	#print("Offset: ", offset)
	#print("Glyph count: ", char_fx.glyph_count )

	var desired_angle: float = lerp_angle(-angle, angle, offset) #+ char_fx.elapsed_time
	char_fx.transform = char_fx.transform.rotated_local(desired_angle)
	return true
