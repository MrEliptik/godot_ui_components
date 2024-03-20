extends Control

@export var from: Control
@export var card_scene: PackedScene
@export var card_offset_x: float = 20.0
@export var rot_max: float = 10.0
@export var anim_offset_y: float = 0.3
@export var time_multiplier: float = 2.0

var tween: Tween
var tween_animate: Tween

var time: float = 0.0
var sine_offset_mult: float = 0.0

var drawn: bool = false

func _ready():
	set_process(false)
	
	# Convert degrees to radians to use lerp_angle later
	rot_max = deg_to_rad(rot_max)
	await get_tree().create_timer(2.0).timeout
	#draw_cards(from.global_position, 10)

func _process(delta):
	time += delta
	for i in range(get_child_count()):
		var c: Button = get_child(i)
		var val: float = sin(i + (time * time_multiplier))
		#print("Child %d, sin(%d) = %f" % [i, i, val])
		c.position.y += val * sine_offset_mult

func draw_cards(from_pos: Vector2, number: int) -> void:
	drawn = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			
	for i in range(number):
		var instance: Button = card_scene.instantiate()
		add_child(instance)
		instance.global_position = from_pos
		
		# -(instance.size / 2.0) to center the card
		var final_pos: Vector2 = -(instance.size / 2.0) - Vector2(card_offset_x * (number - 1 - i), 0.0)
		# offset to the right everything has we are going to place cards to the left
		final_pos.x += ((card_offset_x * (number-1)) / 2.0)
		
		#print("Offset: ", float(i)/float(number-1))
		var rot_radians: float = lerp_angle(-rot_max, rot_max, float(i)/float(number-1))
		#print("Rot: ", rot_radians)
		#print("Card %d: , size: %s, pivot: %s" % [i, str(instance.size), str(instance.pivot_offset)])
		
		# Animate pos
		tween.parallel().tween_property(instance, "position", final_pos, 0.3 + (i * 0.075))
		tween.parallel().tween_property(instance, "rotation", rot_radians, 0.3 + (i * 0.075))
	
	tween.tween_callback(set_process.bind(true))
	tween.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)

func undraw_cards(to_pos: Vector2) -> void:
	drawn = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "sine_offset_mult", 0.0, 0.9)
	
	var child_count: int = get_child_count()
	
	for i in range(child_count-1, -1, -1):
		var c: Button = get_child(i)
		# Animate pos
		tween.parallel().tween_property(c, "global_position", to_pos, 0.3 + ((child_count - i) * 0.075))
		tween.parallel().tween_property(c, "rotation", 0.0, 0.3 + ((child_count - i) * 0.075))
	
	await tween.finished
	
	for c in get_children():
		c.queue_free()

func animate_cards() -> void:
	if tween_animate and tween_animate.is_running():
		tween_animate.kill()
	tween_animate = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_animate.set_loops()
	for i in range(get_child_count()):
		var c: Button = get_child(i)

func _on_draw_btn_pressed():
	if drawn:
		undraw_cards(from.global_position)
	else:
		draw_cards(from.global_position, 10)
