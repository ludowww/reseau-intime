extends VBoxContainer

func _ready() -> void:
	custom_minimum_size = Vector2(260, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Hidden by default through PhonePrototype.debug_scroll.visible = false.
	GameState.state_changed.connect(refresh)
	refresh()

func refresh() -> void:
	_clear()
	_add("DEBUG STATE", 18)
	var state := GameState.current_state
	_add("Résumé", 14)
	_add("Jour: %s | Conversation: %s | Segment: %s" % [GameState.context.get("day", "-"), GameState.context.get("conversation_id", "-"), GameState.context.get("segment_id", "-")])
	_add("Dernier choix: %s" % GameState.context.get("last_choice", ""))
	_add_json_section("Global", state.get("global", {}))
	_add_json_section("Personnages", state.get("characters", {}))
	_add_json_section("Signaux passifs", state.get("passive_signals", {}))
	_add_json_section("Flags", state.get("flags", []))
	_add_json_section("Contenus débloqués", state.get("unlocked_content", []))
	_add_json_section("Derniers effects", GameState.context.get("last_effects", {}))
	_add_json_section("Route probe", DebugRouteProbe.get_route_debug())
	if not DataLoader.load_errors.is_empty():
		_add_json_section("Load errors", DataLoader.load_errors)

func _add_json_section(title: String, value) -> void:
	_add(title, 13)
	_add(JSON.stringify(value, "  "), 11)

func _add(text: String, size: int = 12) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(label)

func _clear() -> void:
	for child in get_children():
		child.queue_free()
