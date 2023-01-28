extends CanvasLayer
onready var controller = get_node("../radius_point_controller")
var _wave_count: int = 5
var _wave_radius: float = 0.12

func _on_wave_count_edit_text_entered(new_text):
	var txt = str(new_text)
	if txt.is_valid_integer():
		_wave_count = int(new_text)
		EventsBus.emit_signal("destroy_point_mesh")
		EventsBus.emit_signal("create_point_wave", _wave_count,_wave_radius )
#		EventsBus.emit_signal("update_wave_count", int(new_text))
	else: 
		print("invalid input")
	


func _on_radius_edit_text_entered(new_text):
	var _txt = str(new_text)
	if _txt.is_valid_float():
		_wave_radius = float(new_text)
		EventsBus.emit_signal("destroy_point_mesh")
		EventsBus.emit_signal("create_point_wave", _wave_count,_wave_radius )
#		EventsBus.emit_signal("update_radius", int(new_text))
	else: 
		print("invalid input")


func _unhandled_input(event):
	if event.is_action_pressed("make_wave") and !controller.wave_in_creation:
		EventsBus.emit_signal("destroy_point_mesh")
		EventsBus.emit_signal("create_point_wave", _wave_count,_wave_radius )
		
	
		



func _on_wave_count_edit_text_changed(new_text):
	var _text =  new_text
	_wave_count = int(_text)


func _on_radius_edit_text_changed(new_text):
	var text =  new_text
	_wave_radius = float(text)
