extends Node2D

const bolt_scene := preload("res://Scenes/bolt.tscn")
@onready var playerinv = $CanvasLayer/PlayerInv
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var inv_type = $CanvasLayer/PlayerInv
var paused = false
var current_item: InvItem
var current_slot := 100
var dragging := false
var is_open = false

func _ready():
	var scene_name = get_tree().current_scene.name
	var entity_names: Array
	print(scene_name)
	print(Global.animal_data)
	for i in $Main/Entities.get_child_count():
		entity_names.append($Main/Entities.get_child(i))
	for i in $Main/Entities.get_child_count():
		if scene_name in Global.animal_data:
			entity_names[i].setup(Global.animal_data[scene_name][i])
		if entity_names[i].has_signal("shoot"):
			entity_names[i].connect("shoot", create_bolt)
	for i in $Main/Vega.get_child_count():
		var vega = $Main/Vega.get_child(i)
		if scene_name in Global.vega_data:
			if Global.vega_data[scene_name][i]:
				vega.harvest()

func create_bolt(pos, dir, bolt_type):
	var bolt := bolt_scene.instantiate()
	$Main/Projectiles.add_child(bolt)
	bolt.setup(pos, dir, bolt_type)


func _exit_tree():
	var current_animal_data: Array
	for entity in $Main/Entities.get_children():
		current_animal_data.append([entity.position, entity.velocity, entity.health, entity.name])
	var current_vega_data: Array
	for vega in $Main/Vega.get_children():
		current_vega_data.append(vega.harvested)
	Global.animal_data[get_tree().current_scene.name] = current_animal_data
	Global.vega_data[get_tree().current_scene.name] = current_vega_data
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if Input.is_action_just_pressed("inventory"):
		playerinv.position.x = 444.5
		if is_open:
			close()
		else:
			open()

			
func open():
	playerinv.visible = true
	is_open = true
	
func close():
	playerinv.visible = false
	is_open = false

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func get_inv(i):
	if inv_type != i and dragging:
		pass
		#inv_type.remove_slot()
	inv_type = i
	
func get_dragging(i: bool):
	dragging = i
