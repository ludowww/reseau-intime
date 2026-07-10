extends "res://scripts/ui/PhonePrototype.gd"

# Narrow V0.81 adapter: keep the proven phone implementation intact while
# making the active Tuesday/Wednesday slice data-driven.
var status_time_label: Label
var narrative_time_by_day: Dictionary = {}

func _build_layout() -> void:
	super._build_layout()
	var time_callback := Callable(self, "_on_narrative_time_changed")
	if is_instance_valid(conversation_view) and conversation_view.has_signal("narrative_time_changed"):
		if not conversation_view.is_connected("narrative_time_changed", time_callback):
			conversation_view.connect("narrative_time_changed", time_callback)
	var state_callback := Callable(self, "_on_game_state_changed")
	if not GameState.is_connected("state_changed", state_callback):
		GameState.connect("state_changed", state_callback)

func _add_status_bar(parent: Node) -> void:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 8)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(bar)
	status_time_label = _add_label(bar, "--:--", 13)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(spacer)
	_add_label(bar, "▮▮  Wi‑Fi  82%", 12)

func _format_day_label(day_value) -> String:
	return DataLoader.get_day_display_label(day_value)

func _render_conversations(day_value) -> void:
	super._render_conversations(day_value)
	_refresh_status_time(day_value)

func _moment_metadata_by_conversation_id(day_value) -> Dictionary:
	var metadata: Dictionary = {}
	for item in DataLoader.get_conversations_for_day(day_value):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var has_available_episode := false
		for episode_id in _conversation_episode_ids(item):
			if _is_episode_available(day_value, str(episode_id)):
				has_available_episode = true
				break
		if not has_available_episode:
			continue
		var base_id := _conversation_id(item)
		if not metadata.has(base_id):
			metadata[base_id] = {"labels": [], "times": [], "transitions": []}
	for moment in DataLoader.get_moments_for_day(day_value):
		for conversation_id in moment.get("conversation_ids", []):
			var episode_id := str(conversation_id)
			if not _is_episode_available(day_value, episode_id):
				continue
			var key := _thread_id_for_conversation_id(day_value, episode_id)
			if not metadata.has(key):
				metadata[key] = {"labels": [], "times": [], "transitions": []}
			var bucket: Dictionary = metadata[key]
			_add_unique(bucket["labels"], str(moment.get("moment_label", "")))
			_add_unique(bucket["times"], str(moment.get("time_label", "")))
			_add_unique(bucket["transitions"], str(moment.get("transition_text", "")))
	return metadata

func _refresh_status_time(day_value) -> void:
	if not is_instance_valid(status_time_label):
		return
	var latest_time := DataLoader.get_day_start_time(day_value)
	for moment in DataLoader.get_moments_for_day(day_value):
		var moment_is_available := false
		for conversation_id in moment.get("conversation_ids", []):
			if _is_episode_available(day_value, str(conversation_id)):
				moment_is_available = true
				break
		if not moment_is_available:
			continue
		var moment_time := str(moment.get("time_label", ""))
		if moment_time != "":
			latest_time = moment_time
	var authored_time := str(narrative_time_by_day.get(str(day_value), ""))
	if authored_time != "":
		latest_time = authored_time
	status_time_label.text = latest_time if latest_time != "" else "--:--"

func _on_narrative_time_changed(time_label: String) -> void:
	if current_day_value == null or time_label == "":
		return
	narrative_time_by_day[str(current_day_value)] = time_label
	if is_instance_valid(status_time_label):
		status_time_label.text = time_label

func _on_game_state_changed() -> void:
	# The Reset button calls GameState.reset_state() before rebuilding the active
	# day. Clearing the authored overrides here restores the day's start/moment
	# metadata instead of keeping a previous offline-beat time.
	if GameState.context.get("day", null) == null and str(GameState.context.get("last_choice", "")) == "":
		narrative_time_by_day.clear()
