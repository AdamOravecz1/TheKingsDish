extends Area2D

@export var inv: Inv 
@export var chest_name: String  # A unique identifier for this chest

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var dogInv = $CanvasLayer/DogInv
@onready var player = get_tree().get_first_node_in_group("Player") 
@onready var main = get_tree().current_scene
var is_open := false
var all_strings := true

func _process(delta):
	if is_open:
		if inv.slots[0].item:
			inv.initialize_inv(1)
			play_animation()
			$Eating.play()
		

func _ready():
	monitoring = false
	if Global.chests_load:
		if Global.chest_inv.has(chest_name):
			# Assuming Global.chest_inv[chest_name][0] is a path to the resource
			var inv_resource_path = Global.chest_inv[chest_name]
			if typeof(inv_resource_path) == TYPE_ARRAY:
				var all_strings = inv_resource_path.all(func(item): return typeof(item) == TYPE_STRING)
			if not all_strings:
				inv = inv_resource_path
		else:
			inv.initialize_inv(1)
	dogInv.inv = inv
	dogInv._ready()
	interaction_area.interact = Callable(self, "_opened")

func initialize():
	inv.initialize_inv(1)

func _opened():
	if is_open:
		main.close()
		close()
	else:
		playerinv.position.x = 450
		main.open()
		open()
		
func open():
	monitoring = true
	dogInv.visible = true
	main.open()
	is_open = true
	
func close():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	dogInv.visible = false
	main.close()
	is_open = false
	set_deferred("monitoring", false)
	
func play_animation():
	$Head.play("eat")
	
func _on_body_exited(body):
	close()

func _on_head_animation_finished():
	$Head.play("sleep")
