class_name GSTSeek
extends GSTSteeringBehavior
# Calculates acceleration to take an agent to a target agent's position as directly as possible


var target: GSTAgentLocation


func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent) -> void:
	self.target = target


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.linear = (
			(target.position - agent.position).normalized() * agent.linear_acceleration_max)
	acceleration.angular = 0
	
	return acceleration
