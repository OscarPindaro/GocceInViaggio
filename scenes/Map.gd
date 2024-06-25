extends TileMap

const FEASIBLE_ID: int = 1
const FEASIBLE_LAYER: int = 1

const BOARD_ID: int = 0
const BOARD_LAYER: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_cone(cell_positon: Vector2i, cone_depth: int):
	self.clear_layer(FEASIBLE_LAYER)
	print("position ", cell_positon)
	for depth_idx in range(1, cone_depth+1):
		# since it's a cone, at depth d, the cone is large 2d+1 (from cell -d and cell+d )
		# var start_cell_x: int = cell_positon.x - depth_idx
		# var end_cell_x: int = cell_positon.x + depth_idx
		for width_idx in range(-depth_idx, +depth_idx+1):
			# check that there is a BOARD CELL in that position
			var draw_position = cell_positon + Vector2i(width_idx ,depth_idx)
			var board_cell_exists: bool = self.get_cell_source_id(BOARD_LAYER, draw_position) != -1
			# print(draw_position, board_cell_exists)
			if board_cell_exists:
				self.set_cell(FEASIBLE_LAYER, draw_position, FEASIBLE_ID, Vector2i(0,0), 0)

func compute_path(start: Vector2i, end: Vector2i):
	assert(start.y < end.y, "The start should be at an higher position in the board wrt the end")
	
	var delta_y: int = end.y - start.y
	var curr_cell: Vector2i = start + Vector2i.ZERO
	var next_cell: Vector2i = start + Vector2i.ZERO

	print("Delta y ", delta_y)
	var cell_paths: Array[Vector2i] = []
	for i in range(delta_y):

		# i need to compute if i need to move as (-1,1), (0,1) and (1,1)
		var x_add_comp : int= 0
		# if start is less, it means it's on the left, i need to move to the right (+1)
		if curr_cell.x-end.x < 0:
			x_add_comp = 1
		elif curr_cell.x -end.x > 0:
			x_add_comp = -1
		else:
			x_add_comp = 0
		next_cell = curr_cell + Vector2i(x_add_comp, 1)
		curr_cell =next_cell
		cell_paths.append(next_cell)
	return cell_paths

func convert_cells_to_positions(path_cells: Array[Vector2i]) -> Array[Vector2]:
	var path_positions: Array[Vector2] = []
	for cell in path_cells:
		path_positions.append(map_to_local(cell))
	return path_positions
