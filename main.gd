extends Node

@export var mob_scene: PackedScene
var score: int

const MOB_VELOCITY_LOWER_BOUND = 150.0
const MOB_VELOCITY_UPPER_BOUND = 250.0


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game() -> void:
#	Call the queue_free function on all members of the mobs scene group. This
#   scene group was created in the Mobs scene, so all Mobs will automatically
#   get added to the scene group
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("GET READY!")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$MobTimer.start()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
#	Choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation  # The slash operator here is like a filepath, not a division sign
	mob_spawn_location.progress_ratio = randf()
	
#	Set the mob's direction to be perpendicular to the path direction, so that it will always
#   be facing into the arena
	var direction = mob_spawn_location.rotation + PI / 2
	
#	Set the mob's location to the randomly chosen location above
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity of the mob
	var velocity = Vector2(randf_range(MOB_VELOCITY_LOWER_BOUND, MOB_VELOCITY_UPPER_BOUND), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it as a child node to the Main scene
	add_child(mob)
