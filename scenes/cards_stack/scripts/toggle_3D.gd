extends CheckButton

@export var color_on: Color
@export var color_off: Color
@export var color_on_bg: Color
@export var color_off_bg: Color
@export var duration: float = 0.25

@export var cursor_normal = preload("res://scenes/shared/visuals/cursor.png")
@export var cursor_hover = preload("res://scenes/shared/visuals/cursor_hover.png")

var offset_x: float = 70.0
var pos_x_off: float = 5.0
var pos_x_on: float = 64.0
var tween_pos: Tween
var tween_squish: Tween
var tween_color: Tween

@onready var anchor: Control = $Anchor
@onready var toggle: Panel = $Anchor/Toggle
@onready var default_size: Vector2 = toggle.size
@onready var bg: Panel = $BG
@onready var bg_on: Panel = $BG/BgOn

func _ready() -> void:
	bg.self_modulate = color_off_bg
	bg_on.self_modulate = color_on_bg
	toggle.self_modulate = color_off

func _on_toggled(button_pressed: bool) -> void:
	print("Toggled: ", button_pressed)
	
	if tween_pos and tween_pos.is_running():
		tween_pos.kill()
	tween_pos = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if tween_squish and tween_squish.is_running():
		tween_squish.kill()
	tween_squish = create_tween().set_trans(Tween.TRANS_CUBIC)
	
	if tween_color and tween_color.is_running():
		tween_color.kill()
	tween_color = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	var target_pos: float = 0.0
	if button_pressed:
		target_pos = pos_x_on
	else:
		target_pos = pos_x_off
		
	tween_pos.tween_property(anchor, "position:x", target_pos, duration)
	if button_pressed:
		tween_color.tween_property(bg_on, "position:x", 0.0, duration*1.3)
		tween_color.parallel().tween_property(toggle, "self_modulate", color_on, duration)
		
		tween_squish.tween_property(anchor, "rotation_degrees", 360.0, duration)
		tween_squish.parallel().tween_interval(duration/2.0)
		tween_squish.tween_callback($Anchor/Toggle/Label.set_text.bind("3D"))
		#tween_squish.tween_property(toggle, "size", Vector2(80.0, 25.0), duration/2.0).set_ease(Tween.EASE_IN)
		#tween_squish.parallel().tween_property(toggle, "position", Vector2(80.0-56.0, (56.0-25.0)/2.0), duration/2.0).set_ease(Tween.EASE_IN)
		#tween_squish.tween_property(toggle, "size", Vector2(56.0, 56.0), duration*2.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	else:
		tween_color.tween_property(bg_on, "position:x", -bg_on.size.x, duration*1.3)
		tween_color.parallel().tween_property(toggle, "self_modulate", color_off, duration)
		
		tween_squish.tween_property(anchor, "rotation_degrees", 0.0, duration)
		tween_squish.parallel().tween_interval(duration/2.0)
		tween_squish.tween_callback($Anchor/Toggle/Label.set_text.bind("2D"))
		#tween_squish.tween_property(toggle, "size", Vector2(80.0, 25.0), duration/2.0).set_ease(Tween.EASE_IN)
		#tween_squish.parallel().tween_property(toggle, "position", Vector2(-(80.0-56.0), (56.0-25.0)/2.0), duration/2.0).set_ease(Tween.EASE_IN)
		#tween_squish.tween_property(toggle, "size", Vector2(56.0, 56.0), duration*2.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
