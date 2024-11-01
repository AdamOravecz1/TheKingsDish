extends Area2D

@export var inv: Inv 
@export var chest_name: String  # A unique identifier for this chest

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var cauldroninv = $CanvasLayer/CauldronInv
@onready var player = get_tree().get_first_node_in_group("Player") 
@onready var main = get_tree().current_scene
var is_open := false

func _process(delta):
	if Input.is_action_just_pressed("inventory") and is_open:
		_opened()
		

func _ready():
	close()
	if Global.chest_inv.has(chest_name):
		# Assuming Global.chest_inv[chest_name][0] is a path to the resource
		var inv_resource_path = Global.chest_inv[chest_name]
		inv = inv_resource_path
	else:
		inv.initialize_inv(4)
	cauldroninv.inv = inv
	cauldroninv._ready()
	interaction_area.interact = Callable(self, "_opened")
	
	
func _opened():
	if is_open:
		main.close()
		close()
	else:
		playerinv.position.x = 450
		main.open()
		open()
	
func _on_tree_exited():
	if inv != null:
		# Save the Inv instance to the global dictionary
		Global.chest_inv[chest_name] = inv
		
func open():
	cauldroninv.visible = true
	playerinv.visible = true
	is_open = true
	
func close():
	cauldroninv.visible = false	
	playerinv.visible = false
	is_open = false


func _on_body_exited(body):
	close()
	main.close()
