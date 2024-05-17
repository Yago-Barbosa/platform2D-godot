extends TouchScreenButton

@onready var player := $Player as CharacterBody2D
@onready var button := $"." as TouchScreenButton 
# Called when the node enters the scene tree for the first time.
func _ready():
	player.follow_button(button)
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
