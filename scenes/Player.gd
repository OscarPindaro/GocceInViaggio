extends CharacterBody2D
class_name Player


signal finished_movement()

@export var movement_duration: float = 1
@export var mov_transition: Tween.TransitionType = Tween.TRANS_LINEAR
var mov_tween: Tween




# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0

# # Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	pass


func move_to(target_position: Vector2):
	if mov_tween:
		mov_tween.kill()
	mov_tween = create_tween()
	mov_tween.tween_property(self, "position", target_position, movement_duration).set_trans(mov_transition).set_ease(Tween.EASE_OUT)
	mov_tween.tween_callback(on_mov_tween_end)

func on_mov_tween_end():
	finished_movement.emit()
