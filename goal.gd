extends Area2D

@export var obstacleList : Array[PackedScene]
@export var pointLabel : Label
@export var player : CharacterBody2D
@export var big : Marker2D
@export var small : Marker2D

var points : int = 0

func _ready() -> void:
	createObstacle()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacle"):
		#print(body.name + " Entered " + name)
		player.ai_controller.reward += 10
		points += 1
		pointLabel.text = str(points)
		createObstacle()
		await get_tree().create_timer(0.75).timeout
		body.queue_free()

func createObstacle():
		var newObs : RigidBody2D = obstacleList.pick_random().instantiate()
		match newObs.name:
			"SMALL":
				newObs.position = small.position
			"BIG":
				newObs.position = big.position
		get_parent().call_deferred("add_child", newObs)
		player.newObs(newObs)

func reset():
	points = 0
	pointLabel.text = str(points)
	createObstacle()
