extends Control

@export var max_offset: Vector2
@export var smoothing: float = 2.0

@onready var parallax = $Parallax

func _process(delta):
	var center: Vector2 = get_viewport_rect().size / 2.0
	var dist: Vector2 = get_global_mouse_position() - center
	var offset: Vector2 = dist / center
	
	var new_pos: Vector2
	
	new_pos.x = lerp(max_offset.x, -max_offset.x, offset.x)
	new_pos.y = lerp(max_offset.y, -max_offset.y, offset.y)
	
	parallax.position.x = lerp(parallax.position.x, new_pos.x, smoothing * delta)
	parallax.position.y = lerp(parallax.position.y, new_pos.y, smoothing * delta)
