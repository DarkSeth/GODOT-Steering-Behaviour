class_name GSTPursue
extends GSTSteeringBehavior
# Calculates acceleration to take an agent to intersect with where a target agent will be.

# # The `predict_time_max` variable represents how far ahead to calculate the intersection point.


var target: GSTSteeringAgent
var predict_time_max: float


func _init(
		agent: GSTSteeringAgent,
		target: GSTSteeringAgent,
		predict_time_max := 1.0).(agent) -> void:
	self.target = target
	self.predict_time_max = predict_time_max


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
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
	
	return acceleration


func _get_modified_acceleration() -> float:
	return agent.linear_acceleration_max
