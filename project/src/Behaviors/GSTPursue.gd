# Calculates an acceleration to make an agent intercept another based on the
# target agent's movement.
class_name GSTPursue
extends GSTSteeringBehavior


# The target agent that the behavior is trying to intercept.
var target: GSTSteeringAgent
# The maximum amount of time in the future the behavior predicts the target's
# location.
var predict_time_max: float


func _init(
		agent: GSTSteeringAgent,
		_target: GSTSteeringAgent,
		_predict_time_max := 1.0).(agent) -> void:
	target = _target
	predict_time_max = _predict_time_max


func _calculate_steering(acceleration: GSTTargetAcceleration) -> void:
	var target_position := target.position
	var distance_squared := (target_position - agent.position).length_squared()

	var speed_squared := agent.linear_velocity.length_squared()
	var predict_time := predict_time_max

	if speed_squared > 0:
		var predict_time_squared := distance_squared / speed_squared
		if predict_time_squared < predict_time_max * predict_time_max:
			predict_time = sqrt(predict_time_squared)

	acceleration.linear = ((
			target_position + (target.linear_velocity * predict_time))-agent.position).normalized()
	acceleration.linear *= _get_modified_acceleration()

	acceleration.angular = 0


func _get_modified_acceleration() -> float:
	return agent.linear_acceleration_max
