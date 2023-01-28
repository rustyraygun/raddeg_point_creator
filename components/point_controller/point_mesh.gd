extends MeshInstance
var wave_color
var point_index: int
onready var die_timer = get_node("Timer")
onready var anim = get_node("AnimationPlayer")
export(bool) var is_starter_point = false
func _init():
	EventsBus.connect("destroy_point_mesh", self, "_explode")


func set_timer(_index: int):
	var _time = float(_index)
	self.die_timer.start(_time )
	

func _on_Timer_timeout():
	self.anim.play("explode")


func _explode():
	if !self.is_starter_point:
		self.queue_free()

func _set_material(color):
	var material =  SpatialMaterial.new()
	material.albedo_color = color
	set_surface_material(0, material)
