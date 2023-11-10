extends Control

@export var show_position: float = -95
@export var hide_position: float = 121

var tween: Tween

@onready var colors: Control = $Button/Colors
@onready var label: Label = $Button/Label
@onready var panel: Panel = $Panel

func _ready() -> void:
	for c in colors.get_children():
		c.position.y = c.size.y

func show_colors() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	for i in range(colors.get_child_count()):
		var c = colors.get_child(i)
		tween.parallel().tween_property(c, "position:y", 0.0, 0.3 + (i * randf_range(0.08, 0.15)))
	
	tween.parallel().tween_property(label, "self_modulate", Color("#333333"), 0.45)
	tween.parallel().tween_property(panel.get("theme_override_styles/panel"), "border_color", Color("#4c4c4f"), 0.45)
	
func hide_colors() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		
	for i in range(colors.get_child_count()-1, -1, -1):
		print("Child idx: ", i)
		var c = colors.get_child(i)
		tween.parallel().tween_property(c, "position:y", c.size.y, 0.7 - (i * randf_range(0.05, 0.1)))

	tween.parallel().tween_property(label, "self_modulate", Color("#676767"), 0.85)
	tween.parallel().tween_property(panel.get("theme_override_styles/panel"), "border_color", Color("#a9a9ac"), 0.85)

func _on_button_mouse_entered() -> void:
	print("Enter")
	show_colors()

func _on_button_mouse_exited() -> void:
	print("Leave")
	hide_colors()
