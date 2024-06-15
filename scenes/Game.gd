extends Node2D

const BOARD_LAYER: int = 0

@export var players_path: NodePath
@onready var players: Array[Node] = get_node(players_path).get_children()

@export var starting_player_path: NodePath
@onready var current_player = get_node(starting_player_path) 
var curr_player_idx: int = players.bsearch(current_player)

@onready var map: TileMap = $Map

var movement: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_position = get_local_mouse_position()
		# coordinate in the tilemap
		var cell_coords = map.local_to_map(mouse_position)
		# cell center 
		var cell_local_position = map.map_to_local(cell_coords)

		var is_empity_cell: bool = map.get_cell_source_id(BOARD_LAYER, cell_coords) == -1
		if !is_empity_cell:
			players[curr_player_idx].move_to(cell_local_position)
			curr_player_idx += 1
			curr_player_idx %= len(players)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_roll_result(roll_value:int):
	movement = roll_value
	print(movement)
