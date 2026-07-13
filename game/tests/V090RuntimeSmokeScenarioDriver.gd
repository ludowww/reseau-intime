extends "res://tests/V090RuntimeSmokeStableDriver.gd"

func _run() -> void:
	_ensure_monday_loaded()
	var scenario := _requested_scenario()
	match scenario:
		"A": await _scenario_a_carried_morning_promise()
		"B": await _scenario_b_ordinary_morning()
		"C": await _scenario_c_sandra_lunch()
		"D": await _scenario_d_sandra_soft_boundary()
		"E": await _scenario_e_sandra_expiry()
		"F": await _scenario_f_sandra_defer()
		"G": await _scenario_g_marie_active_return()
		"H": await _scenario_h_marie_bounded_return()
		"I": await _scenario_i_honest_distance_preserves_mathilde_owner()
		_:
			failures.append("Unknown or missing V0.90 smoke scenario: %s" % scenario)

	# Let queued frees and deferred signal work settle before the process exits.
	await get_tree().process_frame
	await get_tree().process_frame

	if failures.is_empty():
		print("V0.90 runtime smoke %s: OK" % scenario)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("V0.90 runtime smoke %s: FAILED (%d)" % [scenario, failures.size()])
	get_tree().quit(1)

func _requested_scenario() -> String:
	for argument in OS.get_cmdline_user_args():
		var text := str(argument)
		if text.begins_with("--scenario="):
			return text.trim_prefix("--scenario=").strip_edges().to_upper()
	return ""
