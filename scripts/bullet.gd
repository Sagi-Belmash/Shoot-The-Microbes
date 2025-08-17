extends Area2D

var linear_velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += linear_velocity * delta


func _on_body_entered(body: Node2D) -> void:
	body.hit()
	queue_free()
