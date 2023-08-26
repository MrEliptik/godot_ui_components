extends Control

var tween: Tween

@onready var card = $Card
@onready var texture_rect = $Card/VBoxContainer/TextureRect
@onready var star_particles: GPUParticles2D = $Card/VBoxContainer/TextureRect/StarParticles
@onready var gpu_particles_2d = $Card/VBoxContainer/TextureRect/StarParticles
@onready var level_up = $Card/VBoxContainer/LevelUp
@onready var xp = $Card/VBoxContainer/XP
@onready var points = $Card/VBoxContainer/Points
@onready var separator = $Card/VBoxContainer/Separator
@onready var available_points = $Card/VBoxContainer/AvailablePoints
@onready var points_value = $Card/VBoxContainer/PointsValue
@onready var button = $Card/VBoxContainer/Button

func _ready():
	card.scale = Vector2.ZERO
	level_up.self_modulate.a = 0.0
	texture_rect.self_modulate.a = 0.0
	texture_rect.pivot_offset = texture_rect.size / 2.0
	texture_rect.scale = Vector2.ZERO
	xp.self_modulate.a = 0.0
	points.self_modulate.a = 0.0
	separator.self_modulate.a = 0.0
	available_points.self_modulate.a = 0.0
	points_value.self_modulate.a = 0.0
	button.self_modulate.a = 0.0
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.5)
	
	tween.tween_property(card, "scale", Vector2.ONE, 0.75).from(Vector2.ZERO)
	
	tween.tween_method(set_int_to_text.bind(xp, true), 0, 1500, 1.5)
	tween.parallel().tween_property(xp, "self_modulate:a", 1.0, 0.35)
	tween.parallel().tween_property(points, "self_modulate:a", 1.0, 0.5)
	
	tween.tween_property(level_up, "self_modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(texture_rect, "self_modulate:a", 1.0, 0.4).from(0.0)
	tween.parallel().tween_property(texture_rect, "scale", Vector2(1.0, 1.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).from(Vector2.ZERO)
	tween.tween_callback(star_particles.restart)
	var level_up_original_y: float = level_up.position.y
#	tween.parallel().tween_property(level_up, "position:y", 0.0, 0.5).from(level_up_original_y+200)

	tween.tween_property(separator, "self_modulate:a", 1.0, 0.35)
	
	tween.tween_property(available_points, "self_modulate:a", 1.0, 0.3).from(0.0)
	tween.tween_method(set_int_to_text.bind(points_value), 0, 6350, 1.5)
	tween.parallel().tween_property(points_value, "self_modulate:a", 1.0, 0.4)

	tween.tween_property(button, "self_modulate:a", 1.0, 0.8)
	
	tween.tween_interval(2.5)
	
func set_int_to_text(value: int, label: Label, add: bool = false) -> void:
	if add:
		label.text = "+" + str(value)
	else:
		label.text = str(value)
		
