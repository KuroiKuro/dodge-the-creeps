extends RigidBody2D

func set_collision_shape_by_animation(animation_name: String) -> void:
#	Unique shape and position only for fly animation
	if animation_name == "fly":
		var shape = $CollisionShape2D.shape	
		shape.radius = 52
		shape.height = 104
		$CollisionShape2D.position = Vector2(-10, 1)
		print("Set special collision shape for fly animation")
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	var animation_name = mob_types.pick_random()
	set_collision_shape_by_animation(animation_name)
	$AnimatedSprite2D.animation = animation_name
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
