extends Spatial
export(PackedScene) var bullet
onready var muzzle = get_node("muzzle")
onready var point_controller = get_node("../radius_point_controller")


func shoot():
	if !point_controller.wave_in_creation and EventsBus.all_points.size() > 0:
		for i in EventsBus.all_points.size() -1:
			if point_controller.wave_in_creation:
				break
			blast(EventsBus.all_points[i])
			yield(get_tree().create_timer(0.2), "timeout")
		
func blast(target_vec: Vector3):
	var b = bullet.instance()
	add_child(b)
	b.global_transform.origin = muzzle.global_transform.origin
	b.target_pos = target_vec
	b.fired = true
	


func _on_blast_timer_timeout():
	shoot()

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	shoot()
