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
		var start_cell_x: int = cell_positon.x - depth_idx
		var end_cell_x: int = cell_positon.x + depth_idx
		for width_idx in range(-depth_idx, +depth_idx+1):
			# check that there is a BOARD CELL in that position
			var draw_position = cell_positon + Vector2i(width_idx ,depth_idx)
			var board_cell_exists: bool = self.get_cell_source_id(BOARD_LAYER, draw_position) != -1
			# print(draw_position, board_cell_exists)
			if board_cell_exists:
				self.set_cell(FEASIBLE_LAYER, draw_position, FEASIBLE_ID, Vector2i(0,0), 0)
