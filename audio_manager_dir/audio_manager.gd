extends Node

@onready var bgm_audio: AudioStreamPlayer2D = $BGMAudio
@onready var sfx_audio: AudioStreamPlayer2D = $SFXAudio

@export var bgm_list: Array[AudioStreamMP3] = []
var tween: Tween

func play_bgm(index) -> void:
	if index > bgm_list.size()-1:
		return
	
	if bgm_audio.playing:
		tween = create_tween()
		tween.tween_property(bgm_audio, "volume_db", -80.0, 1.0)
		await tween.finished
		bgm_audio.stop()
		
	bgm_audio.stream = bgm_list[index]
	bgm_audio.play()
	
	tween = create_tween()
	tween.tween_property(bgm_audio, "volume_db", 0, 1.0)

func stop_bgm() -> void:
	if bgm_audio.playing:
		tween = create_tween()
		tween.tween_property(bgm_audio, "volume_db", -80.0, 1.0)
		await tween.finished
		bgm_audio.stop()

func _on_bgm_audio_finished() -> void:
	var index = randi_range(0, bgm_list.size()-1)
	play_bgm(index)
