extends CharacterBody2D
class_name Actor

@export var speed: = Vector2(400.0, 500.0)


func _physics_process(delta: float) -> void:
	velocity.y += get_gravity().y * delta

func die() -> void:
	queue_free()
