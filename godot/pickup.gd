extends Node3D
class_name Pickup

var player_ref
var can_pickup := false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		can_pickup = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_pickup = false
		

func player_pickup():
	if player_ref:
		self.collision_layer = 0
		self.collision_mask = 0
		
		var right_hand_pickup = player_ref.get_node("MeshRoot/Armature/Skeleton3D/BoneAttachment3D/RightHandPickup")

		var target_transform: Transform3D = right_hand_pickup.global_transform

		var tween := create_tween()
		tween.tween_property(self, "global_transform", target_transform, 0.2).set_trans(Tween.TRANS_LINEAR)

		tween.finished.connect(func():
			reparent(right_hand_pickup)
			transform = Transform3D.IDENTITY
			player_ref.carrying = true
		)

func player_drop():
	self.collision_layer = 2
	self.collision_mask = 2
	player_ref.carrying = false
	reparent(get_tree().current_scene)
