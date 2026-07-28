extends Control

class_name TimePassageOverlay

signal flow_finished(request_id: int)
signal phase_changed(phase: String)
signal speed_requested

const PHASE_CLOCK := "CLOCK"
const PHASE_OFF_PHONE := "OFF_PHONE"
const PHASE_NIGHT := "NIGHT"
const PHASE_NEW_DAY := "NEW_DAY"
# DECISION and CONTENT_END intentionally stay on DayTransition cards.
const FLOW_DECISION := "DECISION"
const FLOW_CONTENT_END := "CONTENT_END"
const MINIMUM_SKIP_DELAY_SECONDS := 0.35
const MINIMUM_AUTOMATIC_VISIBLE_SECONDS := 0.25
const CLOCK_DURATION_SECONDS := 4.0
const NIGHT_DURATION_SECONDS := 2.6
const NEW_DAY_DURATION_SECONDS := 2.4
const CLOCK_BACKGROUND := Color(0.015, 0.02, 0.04, 0.96)
const OFF_PHONE_BACKGROUND := Color(0.015, 0.02, 0.04, 0.97)
const NIGHT_BACKGROUND := Color(0.005, 0.008, 0.018, 1.0)
const NEW_DAY_BACKGROUND := Color(0.015, 0.02, 0.04, 1.0)

var request_id := 0
var phases: Array[Dictionary] = []
var phase_index := -1
var real_elapsed := 0.0
var speed_scaled_elapsed := 0.0
var phase_duration := 1.0
var speed_multiplier := 1.0
var reduced_motion := false
var active := false
var skip_requested := false

@onready var dimmer: ColorRect = $Dimmer
@onready var content: VBoxContainer = $Center/Content
@onready var eyebrow_label: Label = $Center/Content/Eyebrow
@onready var clock_label: Label = $Center/Content/Clock
@onready var title_label: Label = $Center/Content/Title
@onready var body_label: Label = $Center/Content/Body
@onready var sleep_container: Control = $Center/Content/SleepContainer
@onready var sleep_z: Label = $Center/Content/SleepContainer/SleepZ
@onready var sleep_zz: Label = $Center/Content/SleepContainer/SleepZz
@onready var sleep_zzz: Label = $Center/Content/SleepContainer/SleepZzz
# Compatibility alias used by the previous smoke contract.
@onready var sleep_label: Label = $Center/Content/SleepContainer/SleepZzz
@onready var speed_button: Button = $SpeedButton

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)
	set_process_unhandled_key_input(true)
	speed_button.pressed.connect(func(): speed_requested.emit())
	set_process(false)
	visible = false

func play_flow(value: Array, next_request_id: int) -> bool:
	if active or value.is_empty():
		return false
	phases.clear()
	for item in value:
		if item is Dictionary and str(item.get("phase", "")) in [PHASE_CLOCK, PHASE_OFF_PHONE, PHASE_NIGHT, PHASE_NEW_DAY]:
			phases.append(item.duplicate(true))
	if phases.is_empty():
		return false
	request_id = next_request_id
	phase_index = -1
	active = true
	visible = true
	set_process(true)
	_advance_phase()
	return true

func cancel_flow() -> void:
	var cancelled_request_id := request_id
	var was_active := active
	request_id += 1
	active = false
	phases.clear()
	set_process(false)
	visible = false
	if was_active:
		flow_finished.emit(cancelled_request_id)

func dismiss() -> void:
	active = false
	phases.clear()
	set_process(false)
	visible = false

func set_speed_multiplier(value: float) -> void:
	if value in [1.0, 3.0, 8.0]:
		speed_multiplier = value
		if speed_button != null:
			speed_button.text = "×%d" % int(value)

func set_reduced_motion(enabled: bool) -> void:
	reduced_motion = enabled
	if active:
		_apply_phase(phases[phase_index])

func set_compact_height_mode(enabled: bool) -> void:
	clock_label.add_theme_font_size_override("font_size", 44 if enabled else 64)
	title_label.add_theme_font_size_override("font_size", 22 if enabled else 28)
	body_label.add_theme_font_size_override("font_size", 15 if enabled else 18)
	content.add_theme_constant_override("separation", 6 if enabled else 12)

func current_phase() -> String:
	if not active or phase_index < 0 or phase_index >= phases.size():
		return ""
	return str(phases[phase_index].get("phase", ""))

func surface_rect() -> Rect2:
	return get_global_rect() if visible else Rect2()

func has_horizontal_crop() -> bool:
	return visible and content.get_global_rect().size.x > get_global_rect().size.x + 0.5

func _process(delta: float) -> void:
	if not active:
		return
	real_elapsed += delta
	speed_scaled_elapsed += delta * speed_multiplier
	var phase: Dictionary = phases[phase_index]
	var kind := current_phase()
	if kind == PHASE_CLOCK:
		_update_clock(phase, speed_scaled_elapsed)
	elif kind == PHASE_NIGHT and not reduced_motion:
		_update_sleep(real_elapsed)
	var can_skip := kind == PHASE_OFF_PHONE and skip_requested and real_elapsed >= MINIMUM_SKIP_DELAY_SECONDS
	var active_progress := real_elapsed if kind == PHASE_NIGHT else speed_scaled_elapsed
	var automatic_finished := active_progress >= phase_duration and real_elapsed >= MINIMUM_AUTOMATIC_VISIBLE_SECONDS
	if can_skip or automatic_finished:
		if kind == PHASE_CLOCK:
			_update_clock(phase, phase_duration)
		skip_requested = false
		_advance_phase()

func _advance_phase() -> void:
	phase_index += 1
	if phase_index >= phases.size():
		active = false
		set_process(false)
		flow_finished.emit(request_id)
		return
	real_elapsed = 0.0
	speed_scaled_elapsed = 0.0
	skip_requested = false
	_apply_phase(phases[phase_index])
	phase_changed.emit(current_phase())

func _apply_phase(phase: Dictionary) -> void:
	var kind := str(phase.get("phase", ""))
	eyebrow_label.text = str(phase.get("eyebrow", "")) if kind == PHASE_NEW_DAY else ""
	title_label.text = str(phase.get("title", "")) if kind == PHASE_NEW_DAY else ""
	body_label.text = str(phase.get("body", phase.get("text", ""))) if kind in [PHASE_OFF_PHONE, PHASE_NEW_DAY] else ""
	clock_label.text = str(phase.get("from_time", phase.get("time", ""))) if kind in [PHASE_CLOCK, PHASE_NEW_DAY] else ""
	eyebrow_label.visible = kind == PHASE_NEW_DAY and eyebrow_label.text != ""
	title_label.visible = kind == PHASE_NEW_DAY and title_label.text != ""
	body_label.visible = kind == PHASE_OFF_PHONE or (kind == PHASE_NEW_DAY and body_label.text != "")
	clock_label.visible = kind in [PHASE_CLOCK, PHASE_NEW_DAY]
	sleep_container.visible = kind == PHASE_NIGHT
	_reset_sleep_labels()
	if kind == PHASE_CLOCK:
		dimmer.color = CLOCK_BACKGROUND
	elif kind == PHASE_OFF_PHONE:
		dimmer.color = OFF_PHONE_BACKGROUND
	elif kind == PHASE_NIGHT:
		dimmer.color = NIGHT_BACKGROUND
	else:
		dimmer.color = NEW_DAY_BACKGROUND
	if reduced_motion:
		phase_duration = maxf(float(phase.get("reduced_duration", 0.35)), 0.15)
	elif kind == PHASE_CLOCK:
		phase_duration = maxf(float(phase.get("duration_seconds", CLOCK_DURATION_SECONDS)), 0.1)
	elif kind == PHASE_OFF_PHONE:
		var reading_time := clampf(2.0 + float(body_label.text.length()) * 0.025, 3.0, 7.0)
		phase_duration = maxf(float(phase.get("duration_seconds", reading_time)), 0.5)
	elif kind == PHASE_NIGHT:
		phase_duration = maxf(float(phase.get("duration_seconds", NIGHT_DURATION_SECONDS)), 0.3)
	else:
		phase_duration = maxf(float(phase.get("duration_seconds", NEW_DAY_DURATION_SECONDS)), 0.3)

func _update_clock(phase: Dictionary, scaled_elapsed: float) -> void:
	var from_minutes := int(phase.get("from_minutes", -1))
	var to_minutes := int(phase.get("to_minutes", -1))
	if reduced_motion or from_minutes < 0 or to_minutes < from_minutes:
		clock_label.text = str(phase.get("to_time", phase.get("time", "")))
		return
	var ratio := clampf(scaled_elapsed / maxf(phase_duration, 0.001), 0.0, 1.0)
	var shown := mini(to_minutes, from_minutes + int(floor(float(to_minutes - from_minutes) * ratio)))
	clock_label.text = "%02d:%02d" % [shown / 60, shown % 60]

func _reset_sleep_labels() -> void:
	for label in [sleep_z, sleep_zz, sleep_zzz]:
		label.visible = false
		label.modulate.a = 0.0
	sleep_z.position.y = 20.0
	sleep_zz.position.y = 10.0
	sleep_zzz.position.y = 0.0
	if reduced_motion:
		sleep_zzz.visible = true
		sleep_zzz.modulate.a = 1.0

func _update_sleep(real_progress: float) -> void:
	_set_sleep_label_progress(sleep_z, real_progress, 0.00, 0.85, 20.0, 6.0)
	_set_sleep_label_progress(sleep_zz, real_progress, 0.70, 1.60, 10.0, 8.0)
	_set_sleep_label_progress(sleep_zzz, real_progress, 1.45, 2.60, 0.0, 10.0)

func _set_sleep_label_progress(label: Label, elapsed_seconds: float, start: float, end: float, base_y: float, rise: float) -> void:
	var ratio := clampf((elapsed_seconds - start) / maxf(end - start, 0.001), 0.0, 1.0)
	label.visible = elapsed_seconds >= start
	var eased := 1.0 - pow(1.0 - ratio, 3.0)
	label.position.y = base_y - rise * eased
	var fade_in := clampf(ratio * 5.0, 0.0, 1.0)
	var fade_out := clampf((1.0 - ratio) * 5.0, 0.0, 1.0)
	label.modulate.a = minf(fade_in, fade_out) if elapsed_seconds >= phase_duration - 0.35 else fade_in

func _on_gui_input(event: InputEvent) -> void:
	if not active:
		return
	if event is InputEventMouseButton and event.pressed:
		if current_phase() == PHASE_OFF_PHONE:
			skip_requested = true
		accept_event()

func _unhandled_key_input(event: InputEvent) -> void:
	if not active or not event is InputEventKey:
		return
	if event.pressed and not event.echo and (event.keycode in [KEY_ENTER, KEY_SPACE] or event.is_action_pressed("ui_accept")):
		if current_phase() == PHASE_OFF_PHONE:
			skip_requested = true
		get_viewport().set_input_as_handled()
