extends Node3D

var player_ref

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		player_pickup()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_ref = null
		
func player_pickup():
	if player_ref:
		var right_hand_pickup = player_ref.get_node("MeshRoot/Armature/Skeleton3D/BoneAttachment3D/RightHandPickup")
		reparent(right_hand_pickup)
		player_ref.right_hand_carrying = true
		transform = Transform3D.IDENTITY
		
