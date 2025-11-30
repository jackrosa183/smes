extends Node3D

var can_pickup: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_pickup = true
		print("player entered") # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_pickup = false	
		print("player exited") 
