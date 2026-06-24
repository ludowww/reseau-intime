extends VBoxContainer

func _ready() -> void:
	GameState.state_changed.connect(refresh)
	refresh()

func refresh() -> void:
	_clear()
	_add("DEBUG STATE", 18)
	var state := GameState.current_state
	_add("Contexte: %s" % JSON.stringify(GameState.context, "  "))
	_add("Global: %s" % JSON.stringify(state.get("global", {}), "  "))
	_add("Personnages: %s" % JSON.stringify(state.get("characters", {}), "  "))
	_add("Signaux passifs: %s" % JSON.stringify(state.get("passive_signals", {}), "  "))
	_add("Flags: %s" % JSON.stringify(state.get("flags", []), "  "))
	_add("Contenus débloqués: %s" % JSON.stringify(state.get("unlocked_content", []), "  "))
	_add("Route probe: %s" % JSON.stringify(DebugRouteProbe.get_route_debug(), "  "))
	if not DataLoader.load_errors.is_empty():
		_add("Load errors: %s" % JSON.stringify(DataLoader.load_errors, "  "))

func _add(text: String, size: int = 12) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	add_child(label)

func _clear() -> void:
	for child in get_children():
		child.queue_free()
