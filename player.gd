extends CharacterBody2D


const JUMP_VELOCITY = -400.0
@export var goal : Area2D
@onready var ai_controller: Node2D = $AIController2D
@onready var shape: CollisionShape2D = $CollisionShape2D
var timeElipsed : float = 0.0
var obstacle : RigidBody2D
var jump : int = 0

func _ready() -> void:
	ai_controller.init(self)

func _physics_process(delta: float) -> void:
	if position.x != 0.0:
		position = Vector2.ZERO
		velocity = Vector2.ZERO
	if ai_controller.needs_reset:
		obstacle.queue_free()
		position = Vector2.ZERO
		velocity = Vector2.ZERO
		ai_controller.reset()
		goal.reset()

	ai_controller.reward += delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if ai_controller.heuristic == "human":
		if Input.is_action_just_pressed("smallJump") and is_on_floor():
			jump = 1
		if Input.is_action_just_pressed("bigJump") and is_on_floor():
			jump = 2

	if is_on_floor():
		match jump:
			0:
				pass
			1:
				velocity.y = JUMP_VELOCITY
			2:
				velocity.y = JUMP_VELOCITY * 1.5
	jump = 0

	move_and_slide()

func newObs(obs : RigidBody2D):
	obstacle = obs
	var obsArea : Area2D = obstacle.get_child(0)
	obsArea.connect("body_entered", reset.bind())

func reset(body: Node2D):
	if body == self:
		ai_controller.done = true
		ai_controller.needs_reset = true
