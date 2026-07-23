extends Control

class_name GalleryScreen

signal photo_requested(item_id: String)

const DEMO_DATA := preload("res://scripts/ui/gallery/GalleryDemoData.gd")
const CHARACTER_TABS_SCRIPT := preload("res://scripts/ui/gallery/CharacterTabs.gd")
const GALLERY_TILE_SCRIPT := preload("res://scripts/ui/gallery/GalleryTile.gd")
const NARROW_WIDTH_THRESHOLD := 500.0
const TILE_ASPECT_RATIO := 0.75
const GRID_GAP := 10.0

var PORTRAIT_THEME = preload("res://scripts/ui/PortraitShellTheme.gd").new()
var fixtures: Dictionary = {}
var character_order: Array[String] = []
var selected_character_id := "marie"
var title_label: Label
var count_label: Label
var character_tabs
var grid_scroll: ScrollContainer
var grid: GridContainer
var empty_state: CenterContainer
var tile_buttons: Array[Button] = []
var photo_request_count := 0
var last_photo_restore_origin_scroll := -1

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	fixtures = DEMO_DATA.fixtures().duplicate(true)
	character_order = DEMO_DATA.character_order()
	_build()
	select_character(selected_character_id)
	resized.connect(_queue_layout_refresh)

func select_character(character_id: String) -> void:
	if not fixtures.has(character_id):
		return
	selected_character_id = character_id
	character_tabs.select_character(character_id)
	_rebuild_content()

func focus_selected_tab() -> void:
	character_tabs.focus_selected_tab()

func focus_first_tile() -> void:
	if not tile_buttons.is_empty():
		tile_buttons[0].grab_focus()
		grid_scroll.ensure_control_visible(tile_buttons[0])

func focus_tile(index: int) -> void:
	if index >= 0 and index < tile_buttons.size():
		tile_buttons[index].grab_focus()
		grid_scroll.ensure_control_visible(tile_buttons[index])

func activate_first_tile() -> void:
	if not tile_buttons.is_empty():
		tile_buttons[0].emit_signal("pressed")

func viewer_sequence_for_selected_character() -> Array[Dictionary]:
	var sequence: Array[Dictionary] = []
	var character: Dictionary = fixtures.get(selected_character_id, {})
	var items: Array = character.get("items", []).duplicate(true)
	items.sort_custom(func(a: Dictionary, b: Dictionary): return int(a.get("sort_key", 0)) < int(b.get("sort_key", 0)))
	for item in items:
		sequence.append({
			"photo_id": str(item.get("item_id", "")),
			"visual_ref": str(item.get("full_ref", "")),
			"source_kind": "gallery",
			"character_id": selected_character_id,
			"display_name": str(character.get("display_name", "")),
			"accent_color": character.get("accent_color", PORTRAIT_THEME.GALLERY_ACCENT),
			"context_label": "Galerie · %s" % str(item.get("thumbnail_label", "Photo démo")),
			"timestamp": "",
			"caption": "",
		})
	return sequence

func viewer_index_for_item(item_id: String) -> int:
	var sequence := viewer_sequence_for_selected_character()
	for index in range(sequence.size()):
		if str(sequence[index].get("photo_id", "")) == item_id:
			return index
	return -1

func viewer_origin_for_item(item_id: String) -> Dictionary:
	return {
		"source_kind": "gallery",
		"selected_character_id": selected_character_id,
		"item_id": item_id,
		"grid_scroll_position": grid_scroll.scroll_vertical,
	}

func focus_item(item_id: String, ensure_visible: bool) -> bool:
	for tile in tile_buttons:
		if str(tile.item_id) == item_id:
			tile.grab_focus()
			if ensure_visible:
				grid_scroll.ensure_control_visible(tile)
			return true
	return false

func restore_after_photo_viewer(provenance: Dictionary, current_photo_id: String, focus_target: Variant) -> void:
	if str(provenance.get("selected_character_id", "")) != selected_character_id:
		return
	await get_tree().process_frame
	grid_scroll.scroll_vertical = int(provenance.get("grid_scroll_position", 0))
	await get_tree().process_frame
	last_photo_restore_origin_scroll = grid_scroll.scroll_vertical
	var photo_changed := current_photo_id != str(provenance.get("item_id", ""))
	if not focus_item(current_photo_id, photo_changed):
		if focus_target is Control and is_instance_valid(focus_target) and focus_target.is_visible_in_tree():
			focus_target.grab_focus()

func column_count_for_width(width: float) -> int:
	if width < NARROW_WIDTH_THRESHOLD:
		return 2
	return 3

func describe_state() -> Dictionary:
	var presentation: Dictionary = fixtures.get(selected_character_id, {})
	var focused_tile_id := ""
	for tile in tile_buttons:
		if tile.has_focus():
			focused_tile_id = str(tile.item_id)
			break
	return {
		"selected_character_id": selected_character_id,
		"selected_character_name": str(presentation.get("display_name", "")),
		"tab_count": character_tabs.tab_count(),
		"tile_count": tile_buttons.size(),
		"counter_text": count_label.text,
		"grid_visible": grid_scroll.visible,
		"empty_state_visible": empty_state.visible,
		"column_count": grid.columns,
		"selected_tab_has_focus": character_tabs.selected_tab_has_focus(),
		"focused_tile_id": focused_tile_id,
		"content_bounds": get_global_rect(),
		"tab_bounds": character_tabs.tab_bounds(),
		"grid_bounds": grid_scroll.get_global_rect(),
		"has_horizontal_crop": _has_horizontal_crop(),
		"tab_minimum_height": character_tabs.tab_minimum_height(),
		"minimum_tile_target": _minimum_tile_target(),
		"tile_ratios_consistent": _tile_ratios_consistent(),
		"photo_request_count": photo_request_count,
	}

func _build() -> void:
	var column := VBoxContainer.new()
	column.name = "GalleryColumn"
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 10)
	add_child(column)

	title_label = _label("Galerie", 28, PORTRAIT_THEME.GALLERY_ACCENT)
	column.add_child(title_label)
	count_label = _label("", 15, PORTRAIT_THEME.TEXT_SECONDARY)
	column.add_child(count_label)

	character_tabs = CHARACTER_TABS_SCRIPT.new()
	character_tabs.name = "CharacterTabs"
	character_tabs.configure(fixtures, character_order, PORTRAIT_THEME)
	character_tabs.character_selected.connect(select_character)
	character_tabs.focus_grid_requested.connect(focus_first_tile)
	column.add_child(character_tabs)

	var content_stack := Control.new()
	content_stack.name = "GalleryContentStack"
	content_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(content_stack)

	grid_scroll = ScrollContainer.new()
	grid_scroll.name = "GalleryGridScroll"
	grid_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	grid_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	grid_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	grid_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_stack.add_child(grid_scroll)

	grid = GridContainer.new()
	grid.name = "GalleryGrid"
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", int(GRID_GAP))
	grid.add_theme_constant_override("v_separation", int(GRID_GAP))
	grid_scroll.add_child(grid)

	empty_state = CenterContainer.new()
	empty_state.name = "GalleryEmptyState"
	empty_state.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content_stack.add_child(empty_state)
	var empty_panel := PanelContainer.new()
	empty_panel.custom_minimum_size = Vector2(260, 150)
	empty_panel.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE, 1, 18))
	empty_state.add_child(empty_panel)
	var empty_box := VBoxContainer.new()
	empty_box.alignment = BoxContainer.ALIGNMENT_CENTER
	empty_box.add_theme_constant_override("separation", 8)
	empty_panel.add_child(empty_box)
	var empty_title := _label("Aucune photo disponible", 20, PORTRAIT_THEME.TEXT_PRIMARY)
	empty_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_box.add_child(empty_title)
	var empty_hint := _label("Cette collection de démonstration est vide.", 14, PORTRAIT_THEME.TEXT_MUTED)
	empty_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_box.add_child(empty_hint)

func _rebuild_content() -> void:
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	tile_buttons.clear()
	var presentation: Dictionary = fixtures.get(selected_character_id, {})
	var items: Array = presentation.get("items", [])
	items.sort_custom(func(a: Dictionary, b: Dictionary): return int(a.get("sort_key", 0)) < int(b.get("sort_key", 0)))
	count_label.text = "%d photo%s" % [items.size(), "s" if items.size() != 1 else ""]
	grid_scroll.visible = not items.is_empty()
	empty_state.visible = items.is_empty()
	var accent: Color = presentation.get("accent_color", PORTRAIT_THEME.GALLERY_ACCENT)
	for index in range(items.size()):
		var tile = GALLERY_TILE_SCRIPT.new()
		tile.configure(items[index], accent, PORTRAIT_THEME, index)
		tile.photo_requested.connect(_on_photo_requested)
		tile.navigation_requested.connect(_on_tile_navigation_requested)
		grid.add_child(tile)
		tile_buttons.append(tile)
	_queue_layout_refresh()

func _queue_layout_refresh() -> void:
	call_deferred("_update_layout")

func _update_layout() -> void:
	if grid_scroll == null or not is_instance_valid(grid_scroll):
		return
	var scrollbar_width: float = grid_scroll.get_v_scroll_bar().get_combined_minimum_size().x
	var available_width: float = max(1.0, size.x - scrollbar_width)
	var columns: int = column_count_for_width(available_width)
	grid.columns = columns
	var tile_width: float = floor((available_width - GRID_GAP * float(columns - 1)) / float(columns))
	for tile in tile_buttons:
		tile.set_tile_width(tile_width)

func _on_tile_navigation_requested(index: int, horizontal_step: int, vertical_step: int) -> void:
	var target := index + horizontal_step + vertical_step * grid.columns
	if vertical_step < 0 and target < 0:
		character_tabs.focus_selected_tab()
		return
	focus_tile(target)

func _on_photo_requested(item_id: String) -> void:
	photo_request_count += 1
	photo_requested.emit(item_id)

func _label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _minimum_tile_target() -> float:
	var value := 100000.0
	for tile in tile_buttons:
		value = min(value, min(tile.size.x, tile.size.y))
	return 0.0 if tile_buttons.is_empty() else value

func _tile_ratios_consistent() -> bool:
	for tile in tile_buttons:
		if tile.size.y <= 0.0 or abs((tile.size.x / tile.size.y) - TILE_ASPECT_RATIO) > 0.04:
			return false
	return true

func _has_horizontal_crop() -> bool:
	if not grid_scroll.visible:
		return false
	var bounds := grid_scroll.get_global_rect()
	for tile in tile_buttons:
		var rect := tile.get_global_rect()
		if rect.position.x < bounds.position.x - 1.0 or rect.end.x > bounds.end.x + 1.0:
			return true
	return false
