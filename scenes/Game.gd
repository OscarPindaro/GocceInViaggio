extends Node2D

const BOARD_LAYER: int = 0
const FEASIBLE_LAYER: int = 1

@export var players_path: NodePath
@onready var players: Array[Node] = get_node(players_path).get_children()

@export var starting_player_path: NodePath
@onready var current_player = get_node(starting_player_path) 
var curr_player_idx: int = players.bsearch(current_player)

@onready var map: TileMap = $Map
@onready var roll_button: Button = $DiceButton

var movement: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in players:
		player = player as Player
		player.finished_movement.connect(self.check_end_movement)



func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_position: Vector2 = get_local_mouse_position()
		# coordinate in the tilemap
		var cell_coords: Vector2i = map.local_to_map(mouse_position)
		# cell center 
		var cell_local_position: Vector2 = map.map_to_local(cell_coords)

		var is_empity_cell: bool = map.get_cell_source_id(FEASIBLE_LAYER, cell_coords) == -1
		var old_player_cell: Vector2i = map.local_to_map(current_player.position)
		if !is_empity_cell:
					# first of all, let's clear the layer
			map.clear_layer(FEASIBLE_LAYER)
			# let's compute the path
			var path_cells: Array[Vector2i] = map.compute_path(old_player_cell, cell_coords)
			print(path_cells)
			var path_positions: Array[Vector2] = map.convert_cells_to_positions(path_cells)
			# convert from Vector2i to Vector2
			
			# move player
			# current_player.move_to(cell_local_position)
			current_player.move_along_path(path_positions)
			var n_cells_moved = cell_coords.y - old_player_cell.y
			# remove the number of cells
			print("n_cells_moved ", n_cells_moved)
			print("movement before ", movement)
			movement -= n_cells_moved
			print("movement after ", movement)
			# if movement is negative, big bug
			assert(movement>=0, "Movement can't be negative")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_end_movement():
	assert(movement>=0, "Movement can't be negative")
	if movement == 0:
		self.end_turn()
		roll_button.disabled = false
	else:
		var player_cell = map.local_to_map(current_player.position)
		map.draw_cone(player_cell, movement)

func end_turn():
	curr_player_idx += 1
	curr_player_idx %= len(players)
	current_player = players[curr_player_idx]

func get_player_cell(player: Player, map: TileMap)->Vector2i:
	var cell_coords = map.local_to_map(player.position)
	return cell_coords


func _on_button_roll_result(roll_value:int):
	movement = roll_value
	print(movement)

	# now we know where the player can go
	var player_cell = get_player_cell(current_player, map)
	map.draw_cone(player_cell, movement)


	
