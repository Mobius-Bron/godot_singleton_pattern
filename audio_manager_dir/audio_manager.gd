extends Node

@onready var bgm_audio: AudioStreamPlayer2D = $BGMAudio
@onready var sfx_audio: AudioStreamPlayer2D = $SFXAudio

var bgm_list: Array[AudioStreamMP3] = []
var tween: Tween

# 获取指定文件夹下的所有 MP3 文件路径（不检查子文件夹）
func get_mp3_files(folder_path: String) -> Array:
	var paths = []
	
	# 打开目录
	var dir_access = DirAccess.open(folder_path)
	if dir_access == null:
		print("无法打开文件夹:", folder_path)
		return []
	
	# 遍历文件
	dir_access.list_dir_begin()
	var file_name = dir_access.get_next()
	while file_name != "":
		# 跳过特殊目录（. 和 ..）
		if file_name == "." or file_name == "..":
			file_name = dir_access.get_next()
			continue
		
		# 获取扩展名并转为小写
		var file_ext = file_name.get_extension().to_lower()
		if file_ext == "mp3":
			# 生成完整路径（如 res://audio/song.mp3）
			var full_path = folder_path.path_join(file_name)
			paths.append(full_path)
		
		file_name = dir_access.get_next()
	dir_access.list_dir_end()

	return paths

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

# 在场景加载时执行
func _ready():
	var folder_path = "res://music_res_dir"
	var paths = get_mp3_files(folder_path)
	
	# 加载所有 MP3 文件为 AudioStreamMP3 对象
	for path in paths:
		var stream = load(path) as AudioStreamMP3
		if stream:
			bgm_list.append(stream)
		else:
			print("加载失败：无效的 MP3 文件路径:", path)
