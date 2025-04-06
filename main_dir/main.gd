extends Node2D

var index: int = 0


func _on_start_button_down() -> void:
	AudioManager.play_bgm(index)


func _on_stop_button_down() -> void:
	AudioManager.stop_bgm()


func _on_next_button_down() -> void:
	index = (index + 1) % AudioManager.bgm_list.size()
	AudioManager.play_bgm(index)


func _on_rand_button_down() -> void:
	index = randi_range(0, AudioManager.bgm_list.size()-1)
	AudioManager.play_bgm(index)
