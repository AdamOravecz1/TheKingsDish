extends gen_shop

func _on_shop_button_pressed():
	$NinePatchRect/VBoxContainer.hide()
	$NinePatchRect/Dialoge.hide()
	$NinePatchRect/GridContainer.show()
	$NinePatchRect/Back.show()
	
func _on_back_pressed():
	$NinePatchRect/VBoxContainer.show()
	$NinePatchRect/Dialoge.show()
	$NinePatchRect/GridContainer.hide()
	$NinePatchRect/Back.hide()


func _on_dialoge_button_1_pressed():
	$NinePatchRect/Dialoge.text = "Good morning"
