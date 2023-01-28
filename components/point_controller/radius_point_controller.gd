extends Spatial
var points = []
var push: float = 0.003
export(PackedScene) var pointer_mesh 
var all_points: Array
var points_mesh = []
var current_point: int = 0 
onready var _target = get_node("../point_mesh")
var wave_color: Color
export(int) var total_degrees = 360
export(int) var point_degree = 15
export(int) var wave_count = 5
export(float) var wave_radius = 0.09
var wave_in_creation: bool = false

func _init():
	EventsBus.connect("create_point_wave", self, "create_point_wave")
	
func _ready():
	self.all_points = EventsBus.all_points
	create_point_wave(5, 0.09)
	
func create_points(radius, target: Spatial):
	points = [] #vec3

	#360 degrees total, add a point every 'point degrees'
	for i in range(0,total_degrees, point_degree):
		var angle = deg2rad(i)
		var x = (target.global_transform.origin.x ) + radius * cos(angle)
		var y =  target.global_transform.origin.y + radius * sin(angle)
		points.append(Vector3(x, y, 0))
	return points

	
func make_point_mesh():
	var spacer =  Vector3(0,0,0)

	for _i in points.size():

		var new_pt= pointer_mesh.instance()
		
		add_child(new_pt)
		new_pt.global_transform.origin = self.global_transform.origin + spacer
		new_pt.point_index = _i
		new_pt._set_material(wave_color) 
		all_points.append(self.global_transform.origin + spacer)
		points_mesh.append(new_pt)

		spacer += Vector3( points[_i][0], points[_i][1], points[_i][2])

	


#Vector3( points[_i][0], points[_i][1], points[_i][2])
var speed: float = 2.5


	
	
func create_point_wave(waves: int, radius: float):
	
	wave_in_creation = true
	current_point = 0
	var rad = radius
	points_mesh.clear() #mesh instances
	all_points.clear()
	for i in waves:

		create_points(rad, _target)	
		wave_color = Color(rand_range(0, 2), rand_range(0, 3), rand_range(0, 3))

		rad += 0.03
		print("rad: " + str(rad))
		make_point_mesh()
		yield(get_tree().create_timer(0.5), "timeout")
#	print("All Points Size: " + str(all_points.size()))
#	print("All Points: " + str(all_points))
	
	for pts in points_mesh.size() -1:
		points_mesh[pts].set_timer(pts)
	wave_in_creation = false
	
func _move_object(object_to_move: Spatial, _delta):
	
	if all_points.size() > 0:
		object_to_move.global_transform.origin = object_to_move.global_transform.origin.linear_interpolate(all_points[current_point], speed * _delta)
	


func _process(delta):

	_move_object($planet, delta)



func _on_Timer_timeout():
	if $planet.global_transform.origin.distance_to(all_points[current_point]) < 1:
		if current_point < all_points.size() -1:
			current_point += 1
		elif current_point == all_points.size() -1:
			create_point_wave(round(rand_range(3,9)), 0.09)
		else: current_point = 0

#func _unhandled_input(event):
#	if event.is_action_pressed("make_wave") and wave_in_creation:
#		return
#	else:
#		EventsBus.emit_signal("destroy_point_mesh")
#		create_point_wave(wave_count, wave_radius)
