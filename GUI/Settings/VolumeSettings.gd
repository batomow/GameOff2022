extends ControlAligner

signal value_changed(value)

func set_up(settings: Dictionary):
	$MasterVolume/HScrollBar.value = settings.master_volume
	$MusicVolume/HScrollBar.value = settings.music_volume
	$SoundEffectsVolume/HScrollBar.value = settings.sound_effects_volume
	$VoiceOverVolume/HScrollBar.value = settings.voice_over_volume

func _on_volume_value_changed(value, option: String) -> void:
	var temp = {}
	temp[option] = value
	emit_signal("value_changed", temp)

func childs_size_changed(new_value):
	_childs_size_changed(new_value)
