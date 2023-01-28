extends Spatial

var fired: bool = false
var target_pos: Vector3
var speed: int = 3
var exploded: bool  = false

func _physics_process(delta):
	if fired:
		self.global_transform.origin =  self.global_transform.origin.linear_interpolate(target_pos, speed * delta)
		
		if self.global_transform.origin.distance_to(target_pos) <= 0:
			self.speed = 0
			self.set_physics_process(false)


func _on_die_timer_timeout():
	self.queue_free()
