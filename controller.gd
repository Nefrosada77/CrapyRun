extends AIController2D


func get_obs() -> Dictionary:
	var obstacle_pos : Vector2
	if _player.obstacle:
		obstacle_pos = to_local(_player.obstacle.global_position)
	else:
		obstacle_pos = Vector2.ZERO
	var playerPos : Vector2 = to_local(_player.global_position)
	var playerSize : Rect2 = _player.shape.get_shape().get_rect()
	var obs = [obstacle_pos.x, obstacle_pos.y, playerPos.x, playerPos.y, playerSize.size.x, playerSize.size.y]
	
	return {"obs" : obs}

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
		"jump" : {"size" : 3, "action_type" : "discrete"},}

func set_action(action) -> void:
	match int(action.jump):
		0:
			get_parent().jump = 0
		1:
			get_parent().jump = 1
		2:
			get_parent().jump = 2
