extends Area2D

var direction: Vector2
var speed: int
var damage: int
var force: float

func setup(pos, dir, type):
	type = int(type)  # biztosítsuk, hogy int típusú

	position = pos + Vector2(0, -4)
	direction = dir.normalized()

	if type == Global.weapons.CROSSBOW:
		var weapon_info = Global.weapon_data[type]
		$Sprite2D.texture = weapon_info["texture"]
		speed = weapon_info["speed"]
		damage = weapon_info["damage"]
		force = weapon_info["knockback"]

	if dir.x < 0:
		$Sprite2D.flip_h = true
	
func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body is TileMap:
		speed = 0
		$CollisionShape2D.queue_free()
	if "hit" in body:
		body.hit(damage, global_position, force)
		queue_free()
	if "stagger" in body:
		body.stagger()
		queue_free()
		

func _on_kill_timer_timeout():
	queue_free()


