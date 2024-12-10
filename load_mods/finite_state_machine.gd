class_name FiniteStateMachine extends Node
## Máquina de estados finitos.
##
## @experimental


## Se emite cuando [member current_state] cambia.
## [param before] estado anterior, [param current] estado actual.
signal current_state_changed(before: String, current: String)


## Estado inicial.
const STATE_START: StringName = "START"


## Estado actual.
var current_state: StringName = STATE_START :
	set=set_current_state


func set_current_state(new_state: String) -> void:
	if new_state == current_state:
		return

	var previous_state: String = current_state
	current_state = new_state

	if Engine.is_editor_hint():
		return

	if is_inside_tree():
		current_state_changed.emit(previous_state, current_state)
		_current_state_changed(previous_state, current_state)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_process_state(delta)


## Método virtual, sobreescribir para dar funcionalidad.
## [codeblock]
## func _process_state(state:String, delta: float) -> void:
##     match current_state:
##         MY_STATE:
##             # código ejecutado en estado MY_STATE
## [/codeblock]
@warning_ignore("unused_parameter")
func _process_state(delta: float) -> void:
	pass


## Método virtual, sobreescribir para dar funcionalidad.
@warning_ignore("unused_parameter")
func _current_state_changed(
	previous_state: String,
	new_state: String
) -> void:
	pass
