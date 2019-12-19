extends KinematicBody2D
"""
AI agent that seeks to move away from the player's location as directly as possible.
"""


onready var radius: = ($CollisionShape2D.shape as CircleShape2D).radius

onready var agent: = GSTSteeringAgent.new()
onready var accel: = GSTTargetAcceleration.new()
onready var flee: = GSTFlee.new(agent, player_agent)

var player_agent: GSTAgentLocation
var velocity: = Vector2.ZERO
var speed: float
var color: Color


func _ready() -> void:
	agent.max_linear_acceleration = speed/10
	agent.max_linear_speed = speed


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


func _physics_process(delta: float) -> void:
	if not player_agent:
		return
	
	_update_agent()
	accel = flee.calculate_steering(accel)
	
	velocity = (velocity + Vector2(accel.linear.x, accel.linear.y)).clamped(agent.max_linear_speed)
	velocity = move_and_slide(velocity)
	if velocity.length_squared() > 0:
		update()


func _update_agent() -> void:
	agent.position = Vector3(global_position.x, global_position.y, 0)