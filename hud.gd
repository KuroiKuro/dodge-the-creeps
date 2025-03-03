extends CanvasLayer

# Notifies Main Scene that the button has been pressed
signal start_game

const WELCOME_MESSAGE = "DODGE LES CREEPS"
const GAME_OVER_MESSAGE = "GAME OVER!"

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over() -> void:
	show_message(GAME_OVER_MESSAGE)
	await $MessageTimer.timeout
	
	$Message.text = WELCOME_MESSAGE
	$Message.show()
	
#	Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
