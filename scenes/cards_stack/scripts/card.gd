@tool
extends Button

signal put_back()

@export var color: Color:
	set(new_val):
		color = new_val
		$SubViewportContainer/SubViewport/Card.self_modulate = color
	get:
		return color

@export var threshold: float = 100.0
@export var threshold_speed: float = 200.0
@export var use_speed: bool = true

var tween_grab: Tween
var tween_movement: Tween
var picked_up: bool = false
var offset: Vector2
var is_3D: bool = false
var last_speed: float = 0.0

@onready var original_position: Vector2 = global_position

func _ready() -> void:
	set_process(false)
	pivot_offset = size / 2.0
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	global_position = get_global_mouse_position() + offset

func set_3D_rotation_x(x: float) -> void:
	$SubViewportContainer.material.set_shader_parameter("x_rot", x)
	
func set_3D_rotation_y(y: float) -> void:
	$SubViewportContainer.material.set_shader_parameter("y_rot", y)

func _on_button_down() -> void:
	if Engine.is_editor_hint(): return
	offset = global_position - get_global_mouse_position()
	picked_up = true
	set_process(true)
	if tween_grab and tween_grab.is_running():
		tween_grab.kill()
	tween_grab = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_grab.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)

func _on_button_up() -> void:
	if Engine.is_editor_hint(): return
	picked_up = false
	set_process(false)
	var dist: float = abs(original_position.y - global_position.y)
	print("Distance: ", dist)
	
	if use_speed:
		if last_speed <= -threshold_speed:
			# Go to new position
			put_back.emit()
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			if is_3D:
				tween_movement.tween_method(set_3D_rotation_x, 0.0, 360.0, 0.5)
			else:
				tween_movement.tween_property(self, "rotation_degrees", 360.0, 0.4).from(0.0)
		else:
			if tween_grab and tween_grab.is_running():
				tween_grab.kill()
			tween_grab = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_grab.tween_property(self, "scale", Vector2.ONE, 0.15)
			
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_movement.tween_property(self, "global_position", original_position, 0.3)
	else:
		if dist > threshold:
			# Go to new position
			put_back.emit()
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			if is_3D:
				tween_movement.tween_method(set_3D_rotation_x, 0.0, 360.0, 0.5)
			else:
				tween_movement.tween_property(self, "rotation_degrees", 360.0, 0.4).from(0.0)
		else:
			if tween_grab and tween_grab.is_running():
				tween_grab.kill()
			tween_grab = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_grab.tween_property(self, "scale", Vector2.ONE, 0.15)
			
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_movement.tween_property(self, "global_position", original_position, 0.3)

func _on_gui_input(event: InputEvent) -> void:
	if not picked_up: return
	if event is InputEventMouseMotion:
		print("speed: ", event.velocity)
		last_speed = event.velocity.y
			
