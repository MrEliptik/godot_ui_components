extends Control

var tween_logo: Tween
var tween_page: Tween

@onready var circle: TextureRect = $Screen/VBoxContainer/Logo/Circle
@onready var star_particles: GPUParticles2D = $Screen/VBoxContainer/Logo/StarParticles
@onready var godot: TextureRect = $Screen/VBoxContainer/Logo/RotPoint/Godot
@onready var quiz: TextureRect = $Screen/VBoxContainer/Logo/RotPoint/Quiz

@onready var godot_final_pos: Vector2 = godot.position
@onready var quiz_final_pos: Vector2 = quiz.position

@onready var avatar_container = $Screen/VBoxContainer/AvatarContainer
@onready var progress_container = $Screen/VBoxContainer/ProgressContainer
@onready var button_container = $Screen/VBoxContainer/ButtonContainer

func _ready() -> void:
	circle.scale = Vector2.ZERO
	godot.self_modulate.a = 0.0
	quiz.self_modulate.a = 0.0
	star_particles.emitting = false
	
	avatar_container.modulate.a = 0.0
	progress_container.modulate.a = 0.0
	button_container.modulate.a = 0.0
	
	await get_tree().create_timer(0.8).timeout
	
	animate_logo()
	
	await get_tree().create_timer(1.5).timeout
	
	animate_page()
	
func animate_logo() -> void:
	tween_logo = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Background circle
	tween_logo.tween_property(circle, "scale", Vector2.ONE, 0.6) \
			.from(Vector2.ZERO).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	# Text
	tween_logo.tween_property(godot, "position", godot_final_pos, 0.6).from(godot_final_pos-Vector2(225, 0))
	tween_logo.parallel().tween_property(godot, "self_modulate:a", 1.0, 0.5).from(0.0)
	tween_logo.parallel().tween_property(quiz, "position", quiz_final_pos, 0.6).from(quiz_final_pos+Vector2(225, 0))
	tween_logo.parallel().tween_property(quiz, "self_modulate:a", 1.0, 0.5).from(0.0)
	tween_logo.tween_callback(star_particles.restart)

func animate_page() -> void:
	tween_page = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_page.tween_property(avatar_container, "modulate:a", 1.0, 0.5).from(0.0)
	tween_page.parallel().tween_property(progress_container, "modulate:a", 1.0, 0.5).from(0.0)
	tween_page.parallel().tween_property(button_container, "modulate:a", 1.0, 0.5).from(0.0)
