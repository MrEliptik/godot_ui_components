extends Control

@onready var background_particles = $BackgroundParticles
@onready var wing_particles = $WingParticles
@onready var wing_particles_2 = $WingParticles2

@onready var title = $Title
@onready var rays = $Anchor/Rays
@onready var shield = $Anchor/Shield
@onready var level = $Anchor/Shield/Level
@onready var level_nb = $Anchor/Shield/LevelNb
@onready var wing_r = $Anchor/Shield/WingR
@onready var wing_l = $Anchor/Shield/WingL
@onready var level_up = $Anchor/LevelUp
@onready var ribbon = $Ribbon
@onready var rewards = $Ribbon/Rewards
@onready var buttons_container = $ButtonsContainer

var tween: Tween
var tween2: Tween
var tween_ray: Tween
var tween_buttons: Tween

func _ready() -> void:
	background_particles.emitting = false
	wing_particles.emitting = false
	wing_particles_2.emitting = false
	
	title.self_modulate.a = 0.0
	rays.scale = Vector2.ZERO
	shield.scale = Vector2.ZERO
	level.self_modulate.a = 0.0
	level_nb.self_modulate.a = 0.0
	level_nb.text = "0"
	wing_r.scale = Vector2.ZERO
	wing_l.scale = Vector2.ZERO
	level_up.self_modulate.a = 0.0
	ribbon.scale.x = 0.0
	rewards.self_modulate.a = 0.0
	
	for child in buttons_container.get_children():
		child.modulate.a = 0.0
	
	animate()
	
func animate() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_ray = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween2 = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween_ray.set_loops()
	tween_ray.tween_property(rays, "rotation_degrees", 360.0, 8.0).from(0.0)
	
	tween.tween_interval(0.4)
	tween.tween_property(title, "self_modulate:a", 1.0, 0.8)
	# Rays & shield
	tween.parallel().tween_callback(background_particles.restart)
	tween.parallel().tween_property(rays, "scale", Vector2.ONE, 0.45).from(Vector2.ZERO)
	tween.parallel().tween_property(shield, "scale", Vector2.ONE, 1.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(shield.material, "shader_parameter/y_rot", 180.0, 1.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	# Labels
	tween.parallel().tween_property(level, "self_modulate:a", 1.0, 1.5)
	tween.parallel().tween_property(level_nb, "self_modulate:a", 1.0, 1.5)
	tween.tween_method(count_up.bind(level_nb), 0, 10, 1.5)
	
	tween.tween_property(level_up, "self_modulate:a", 1.0, 0.45)
	tween.parallel().tween_property(level_up, "position:y", level_up.position.y, 0.7).from(level_up.position.y-100)
	
	# Wings
	tween2.tween_interval(1.2)
	tween2.tween_property(wing_r, "position:x", wing_r.position.x, 0.15).from(wing_r.position.x - 150)
	tween2.parallel().tween_property(wing_l, "position:x", wing_l.position.x, 0.15).from(wing_l.position.x + 150)
	tween2.parallel().tween_property(wing_r, "scale", Vector2.ONE, 0.9).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween2.parallel().tween_property(wing_l, "scale", Vector2.ONE, 0.9).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween2.tween_callback(wing_particles.restart)
	tween2.tween_callback(wing_particles_2.restart)
	
	# Ribbon
	tween.tween_property(ribbon, "scale:x", 1.0, 0.65).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(rewards, "self_modulate:a", 0.75, 1)
	
	for child in buttons_container.get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.15)
		tween.parallel().tween_property(child, "position:y", position.y, 0.7).from(position.y+200)
		tween.tween_interval(0.05)
	
	tween.tween_callback(start_buttons_loop)
	
#	tween.tween_interval(10.0)
#	tween.tween_callback(get_tree().quit)

func start_buttons_loop() -> void:
	tween_buttons = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_buttons.set_loops()
	for child in buttons_container.get_children():
		tween_buttons.tween_property(child, "scale", Vector2(1.1, 1.1), 0.2)
		tween_buttons.tween_property(child, "scale", Vector2.ONE, 0.2)
	tween_buttons.tween_interval(0.4)

func count_up(value: int, label: Label) -> void:
	label.text = str(value)
