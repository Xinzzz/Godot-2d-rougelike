extends Area2D

@export var speed = 50
var direction = Vector2.RIGHT

func _process(delta: float) -> void:
	translate(direction * speed * delta)

func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_visible_screen_exited() -> void:
	queue_free()
