extends Area2D

signal hit

@export var speed = 400 # Determines the speed of the player (pixels/sec)
var screen_size # size of the game window

func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	# Clamp so that the sprite does not leave the screen	
	position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body: Node2D) -> void:
	hide() # Player disappears after being hit
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback
#	Disabling the area's collision shape can cause an error if it happens in the middle of the
#   engine's collision processing. Using set_deferred() tells Godot to wait to disable the shape
#   until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)
