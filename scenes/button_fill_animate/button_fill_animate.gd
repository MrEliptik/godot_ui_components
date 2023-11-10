extends Control

@export var show_position: float = -95

var tween: Tween

@onready var color_rect: ColorRect = $Button/Orange
@onready var label: Label = $Button/Label
@onready var panel: Panel = $Panel

func _ready() -> void:
	color_rect.position.y = color_rect.size.y

func show_colors() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "position:y", show_position, 0.4)
	tween.parallel().tween_property(label, "self_modulate", Color("#333333"), 0.45)
	tween.parallel().tween_property(panel.get("theme_override_styles/panel"), "border_color", Color("#4c4c4f"), 0.45)
	
func hide_colors() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "position:y", color_rect.size.y, 0.8)
	tween.parallel().tween_property(label, "self_modulate", Color("#676767"), 0.85)
	tween.parallel().tween_property(panel.get("theme_override_styles/panel"), "border_color", Color("#a9a9ac"), 0.85)

func _on_button_mouse_entered() -> void:
	show_colors()

func _on_button_mouse_exited() -> void:
	hide_colors()
