extends Node

@onready var bgm_audio: AudioStreamPlayer2D = $BGMAudio
@onready var sfx_audio: AudioStreamPlayer2D = $SFXAudio

@export var bgm_list: Array[AudioStreamMP3] = []
@export var sfx_list: Array[AudioStreamMP3] = []

var tween: Tween

func _ready() -> void:
	bgm_audio.volume_db = -80

func play_bgm(bgm_index) -> void:
	if bgm_index > bgm_list.size()-1:
		return
	
	if bgm_audio.playing:
		tween = create_tween()
		tween.tween_property(bgm_audio, "volume_db", -80.0, 2.0)
		await tween.finished
		bgm_audio.stop()
		
	bgm_audio.stream = bgm_list[bgm_index]
	bgm_audio.play()
	
	tween = create_tween()
	tween.tween_property(bgm_audio, "volume_db", 0, 2.0)

func stop_bgm() -> void:
	if bgm_audio.playing:
		tween = create_tween()
		tween.tween_property(bgm_audio, "volume_db", -80.0, 2.0)
		await tween.finished
		bgm_audio.stop()

func _on_bgm_audio_finished() -> void:
	var index = randi_range(0, bgm_list.size()-1)
	play_bgm(index)

func play_sfx(sfx_index) -> void:
	if sfx_index > sfx_list.size()-1:
		return
	
	var new_sfx_audio: AudioStreamPlayer2D = sfx_audio.duplicate() as AudioStreamPlayer2D
	new_sfx_audio.stream = sfx_list[sfx_index]
	new_sfx_audio.finished.connect(clear_sfx_sudio.bind(new_sfx_audio))
	self.add_child(new_sfx_audio)
	new_sfx_audio.play()

func clear_sfx_sudio(sudio_player: AudioStreamPlayer2D) -> void:
	sudio_player.queue_free()
	
