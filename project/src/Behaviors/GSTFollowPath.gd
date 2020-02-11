# Produces a linear acceleration that moves the agent along the specified path.
class_name GSTFollowPath
extends GSTArrive


# The path to follow and travel along.
var path: GSTPath
# The distance along the path to generate the next target position.
var path_offset := 0.0

# Whether to use `GSTArrive` behavior on an open path.
var is_arrive_enabled := true
# The amount of time in the future to predict the owning agent's position along
# the path. Setting it to 0.0 will force non-predictive path following.
var prediction_time := 0.0


func _init(
		agent: GSTSteeringAgent,
		_path: GSTPath,
		_path_offset := 0.0,
		_prediction_time := 0.0).(agent, null) -> void:
	path = _path
	path_offset = _path_offset
	prediction_time = _prediction_time


func _calculate_steering(acceleration: GSTTargetAcceleration) -> void:
	var location := (
			agent.position if prediction_time == 0
			else agent.position + (agent.linear_velocity * prediction_time))

	var distance := path.calculate_distance(location)
	var target_distance := distance + path_offset
	
	if prediction_time > 0 and path.is_open:
		if target_distance < path.calculate_distance(agent.position):
			target_distance = path.length

	var target_position := path.calculate_target_position(target_distance)
	
	if is_arrive_enabled and path.is_open:
		if path_offset >= 0:
			if target_distance > path.length - deceleration_radius:
				_arrive(acceleration, target_position)
				return
		else:
			if target_distance < deceleration_radius:
				_arrive(acceleration, target_position)
				return

	acceleration.linear = (target_position - agent.position).normalized()
	acceleration.linear *= agent.linear_acceleration_max
	acceleration.angular = 0
