extends Button

@export var min_value: int = 1
@export var max_value: int = 6

signal roll_result(roll_value: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(min_value > 0)
	assert(max_value > 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var roll_value =  randi_range(min_value,max_value)
	roll_result.emit(roll_value)
