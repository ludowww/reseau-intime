extends Node

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const SequenceExecutor := preload(
	"res://scripts/unified_runtime/execution/SequenceExecutor.gd"
)
const MessagesPhysicalPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const MediaPort := preload(
	"res://scripts/unified_runtime/projection/MediaProjectionPort.gd"
)
const CompositePort := preload(
	"res://scripts/unified_runtime/projection/CompositePlayerProjectionPort.gd"
)
const MediaResolver := preload(
	"res://scripts/unified_runtime/projection/AuthoredMediaResolver.gd"
)
const MediaAdapter := preload(
	"res://scripts/unified_runtime/projection/MediaUIProjectionAdapter.gd"
)
const DurableGallery := preload(
	"res://scripts/unified_runtime/projection/DurableGalleryProjection.gd"
)
const PortraitTheme := preload("res://scripts/ui/PortraitShellTheme.gd")
const PhotoViewerScene := preload("res://scenes/portrait/gallery/PhotoViewer.tscn")
const GalleryScreenScene := preload("res://scenes/portrait/gallery/GalleryScreen.tscn")

const SEQUENCE_PATH := "res://tests/fixtures/unified_runtime/n15_messages_physical_projection_valid.json"
const FIXTURE_PATH := "res://tests/fixtures/unified_runtime/n16_media_projection_fixture.json"
const INSTANCE_ID := "synthetic_n16_instance"

var failures: Array[String] = []
var controls := 0


class FacadeStub:
	extends RefCounted

	var state: Dictionary

	func _init(sequence: Dictionary) -> void:
		var a6: Dictionary = sequence["orchestration"]["a6_entry"]
		state = {
			"scene_registry": [{
				"instance_id": INSTANCE_ID,
				"state": "PROPOSED",
				"scene_definition_id": a6["scene_definition_id"],
			}],
		}

	func resolve_scene(_instance_id: String, _choice_id: String, _context: Dictionary) -> Dictionary:
		return {"ok": false, "error_code": "COMMIT_NOT_ALLOWED_IN_N16_SMOKE"}

	func save_state() -> Dictionary:
		return state.duplicate(true)

	func restore_state(value: Dictionary) -> Dictionary:
		state = value.duplicate(true)
		return {"ok": true, "error_code": null}


class ProjectionProbePort:
	extends RefCounted

	func snapshot() -> Dictionary:
		return {
			"accepted": true,
			"snapshot": {"snapshot_version": 1, "open_requests": [], "receipts": []},
			"error_code": null,
		}


class ProjectionProbeExecutor:
	extends RefCounted

	var beat: Dictionary
	var open_calls := 0

	func _init(value: Dictionary) -> void:
		beat = value.duplicate(true)

	func current_beat() -> Dictionary:
		return beat.duplicate(true)

	func execution_state() -> Dictionary:
		return {
			"instance_id": INSTANCE_ID,
			"sequence_id": "synthetic_n15_durable_sequence",
			"authored_version": "1.0.0",
			"execution_status": "ACTIVE",
			"current_beat_id": beat.get("beat_id"),
		}

	func open_current_projection() -> Dictionary:
		open_calls += 1
		return {"ok": false, "error_code": "PROBE_OPENED"}

	func receive_ack(_receipt: Dictionary) -> Dictionary:
		return {"ok": false, "error_code": "PROBE_ACK"}

	func receive_command(_command: Dictionary) -> Dictionary:
		return {"ok": false, "error_code": "PROBE_COMMAND"}


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	get_window().size = Vector2i(1280, 720)
	var base := _load_json(SEQUENCE_PATH)
	var fixture := _load_json(FIXTURE_PATH)
	_restore_integer_types(base)
	_expect(AuthoredValidator.validate(base)["valid"], "fixture authored de base valide")
	_test_resolver_and_ports(base, fixture)
	await _test_preflight_before_open(base, fixture)
	await _test_requires_ack_true(base, fixture)
	await _test_requires_ack_false(base, fixture)
	await _test_resume_before_ack(base, fixture)
	await _test_resume_after_ack(base, fixture)
	await _test_durable_gallery(base, fixture)
	_finish()


func _test_resolver_and_ports(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n16_produced", false)
	var sequence_validation: Dictionary = AuthoredValidator.validate(sequence)
	if not sequence_validation["valid"]:
		push_error("N16 fixture validation: " + JSON.stringify(sequence_validation["errors"]))
	_expect(sequence_validation["valid"], "fixture authored N16 produite valide")
	var catalog: Dictionary = fixture["presentation_catalog"].duplicate(true)
	var created: Dictionary = MediaResolver.create(sequence, catalog)
	_expect(created["ok"], "resolver N16 cree")
	if not created["ok"]:
		return
	var resolver = created["resolver"]
	var produced: Dictionary = resolver.resolve("synthetic_n16_produced")
	_expect(produced["ok"] and produced["presentation"]["display_status"] == "LOADED", "production PRODUCED resolue")
	_expect(produced["presentation"]["gallery_character_ids"] == ["marie"], "presentation conserve gallery_character_ids authored")
	var validated: Dictionary = resolver.resolve("synthetic_n16_validated")
	_expect(validated["ok"] and validated["presentation"]["display_status"] == "LOADED", "production VALIDATED resolue")
	var specified: Dictionary = resolver.resolve("synthetic_n15_media")
	_expect(specified["ok"] and specified["presentation"]["display_status"] == "NOT_DELIVERED", "SPECIFIED_NOT_PRODUCED accepte")
	_expect(specified["presentation"]["status_label"] == "Visuel non livré", "etat non livre explicite")
	_expect(resolver.resolve("unknown_media")["error_code"] == "UNKNOWN_MEDIA", "media_id inconnu refuse")
	var broken_catalog := catalog.duplicate(true)
	broken_catalog["entries"][0]["visual_ref"] = "res://missing_n16_asset.png"
	var broken := MediaResolver.create(sequence, broken_catalog)
	_expect(broken["ok"] and broken["resolver"].resolve("synthetic_n16_produced")["error_code"] == "INVALID_PRESENTATION_ASSET", "asset invalide refuse sans fallback")
	var unknown_catalog := catalog.duplicate(true)
	unknown_catalog["entries"][0]["media_id"] = "unknown_catalog_media"
	_expect(MediaResolver.create(sequence, unknown_catalog)["error_code"] == "UNKNOWN_CATALOG_MEDIA", "identite catalogue inconnue refusee")
	var empty_gallery_catalog := catalog.duplicate(true)
	empty_gallery_catalog["entries"][0]["gallery_character_ids"] = []
	_expect(MediaResolver.create(sequence, empty_gallery_catalog)["error_code"] == "INVALID_PRESENTATION_CATALOG", "onglets Galerie authored vides refuses")

	var media_port = MediaPort.new(sequence)
	var composite_result: Dictionary = CompositePort.create(MessagesPhysicalPort.new(sequence), media_port)
	_expect(composite_result["ok"], "port composite cree")
	if composite_result["ok"]:
		var composite = composite_result["port"]
		_expect(composite.supports_projection("MESSAGES")["supported"], "composite route MESSAGES")
		_expect(composite.supports_projection("PHYSICAL")["supported"], "composite route PHYSICAL")
		_expect(composite.supports_projection("MEDIA")["supported"], "composite route MEDIA")
		_expect(not composite.supports_projection("GALLERY")["supported"], "composite refuse target non compose")
		_expect(composite.snapshot()["snapshot"].keys().size() == 3, "snapshot port v1 sans extension")


func _test_preflight_before_open(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n16_produced", true)
	var resolver = MediaResolver.create(sequence, fixture["presentation_catalog"])["resolver"]
	var unknown_beat := _beat(sequence, "beat_media").duplicate(true)
	unknown_beat["content"]["media_id"] = "unknown_media"
	var executor := ProjectionProbeExecutor.new(unknown_beat)
	var viewer = await _new_viewer()
	var created: Dictionary = MediaAdapter.create(executor, ProjectionProbePort.new(), resolver, viewer, PortraitTheme.new())
	_expect(created["ok"], "adaptateur probe cree")
	var result: Dictionary = created["adapter"].open_current_projection()
	_expect(not result["ok"] and result["error_code"] == "UNKNOWN_MEDIA", "media inconnu refuse avant open")
	_expect(executor.open_calls == 0 and not viewer.visible, "echec resolution sans mutation executor ni UI")
	var wrong_target := _beat(sequence, "beat_media").duplicate(true)
	wrong_target["projection_target"] = "PHOTO_VIEWER"
	executor = ProjectionProbeExecutor.new(wrong_target)
	created = MediaAdapter.create(executor, ProjectionProbePort.new(), resolver, viewer, PortraitTheme.new())
	result = created["adapter"].open_current_projection()
	_expect(not result["ok"] and result["error_code"] == "UNSUPPORTED_TARGET", "mauvais target refuse avant open")
	_expect(executor.open_calls == 0, "target incoherent sans mutation executor")
	_dispose(viewer)
	await get_tree().process_frame


func _test_requires_ack_true(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n15_media", true)
	var environment := _started_environment(sequence)
	_expect(not environment.is_empty() and _advance_to_media(environment["executor"]), "executeur atteint MEDIA_REVEAL")
	if environment.is_empty() or environment["executor"].current_beat().get("type") != "MEDIA_REVEAL":
		return
	var domain_before: Dictionary = environment["facade"].save_state()
	var resolver = MediaResolver.create(sequence, fixture["presentation_catalog"])["resolver"]
	var viewer = await _new_viewer()
	var adapter = MediaAdapter.create(environment["executor"], environment["port"], resolver, viewer, PortraitTheme.new())["adapter"]
	var opened: Dictionary = adapter.open_current_projection()
	_expect(opened["ok"] and viewer.visible, "PhotoViewer canonique reellement ouvert")
	_expect(environment["executor"].execution_state()["execution_status"] == "WAITING_FOR_PROJECTION_ACK", "aucune progression avant visibilite VIEWED")
	await get_tree().process_frame
	_expect(viewer.displayed_media_status() == "NOT_DELIVERED", "visuel non livre reellement affiche")
	_expect(environment["executor"].execution_state()["execution_status"] == "WAITING_FOR_PLAYER", "VIEWED fait attendre CONTINUE")
	_expect(_receipt_kind_count(environment["executor"], "VIEWED") == 1, "VIEWED unique requires_ack true")
	viewer.media_presented.emit("synthetic_n15_media", "NOT_DELIVERED")
	_expect(_receipt_kind_count(environment["executor"], "VIEWED") == 1, "replay VIEWED idempotent")
	_expect(environment["facade"].save_state() == domain_before, "reveal sans ecriture livraison_medias ni A1-A5")
	_expect(adapter.continue_current_projection()["ok"], "CONTINUE apres VIEWED")
	_expect(not viewer.visible and environment["executor"].current_beat()["projection_target"] == "MESSAGES", "routing MEDIA vers MESSAGES et viewer ferme")
	_dispose(viewer)
	await get_tree().process_frame


func _test_requires_ack_false(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n16_produced", false)
	var environment := _started_environment(sequence)
	_expect(not environment.is_empty() and _advance_to_media(environment["executor"]), "executeur non-ack atteint MEDIA_REVEAL")
	if environment.is_empty() or environment["executor"].current_beat().get("type") != "MEDIA_REVEAL":
		return
	var resolver = MediaResolver.create(sequence, fixture["presentation_catalog"])["resolver"]
	var viewer = await _new_viewer()
	var adapter = MediaAdapter.create(environment["executor"], environment["port"], resolver, viewer, PortraitTheme.new())["adapter"]
	_expect(adapter.open_current_projection()["ok"] and viewer.visible, "presentation non-ack montee")
	await get_tree().process_frame
	_expect(viewer.has_loaded_texture(), "asset PRODUCED reellement visible")
	_expect(_receipt_kind_count(environment["executor"], "PRESENTED") == 1, "PRESENTED unique requires_ack false")
	_expect(_receipt_kind_count(environment["executor"], "VIEWED") == 0, "aucun VIEWED obligatoire requires_ack false")
	_expect(adapter.continue_current_projection()["ok"], "CONTINUE direct apres PRESENTED")
	_dispose(viewer)
	await get_tree().process_frame


func _test_resume_before_ack(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n15_media", true)
	var environment := _started_environment(sequence)
	if environment.is_empty() or not _advance_to_media(environment["executor"]):
		_expect(false, "environnement reprise avant ACK cree")
		return
	var resolver = MediaResolver.create(sequence, fixture["presentation_catalog"])["resolver"]
	var first = await _new_viewer()
	var first_adapter = MediaAdapter.create(environment["executor"], environment["port"], resolver, first, PortraitTheme.new())["adapter"]
	_expect(first_adapter.open_current_projection()["ok"], "projection ouverte avant snapshot operationnel")
	first.visible = false
	first.reset_viewer()
	var resumed = await _new_viewer()
	var resumed_adapter = MediaAdapter.create(environment["executor"], environment["port"], resolver, resumed, PortraitTheme.new())["adapter"]
	_expect(resumed_adapter.resume_from_execution()["ok"] and resumed.visible, "reprise WAITING_FOR_PROJECTION_ACK reconstruit viewer")
	await get_tree().process_frame
	_expect(_receipt_kind_count(environment["executor"], "VIEWED") == 1, "reprise avant ACK emet VIEWED apres visibilite")
	_dispose(first)
	_dispose(resumed)
	await get_tree().process_frame


func _test_resume_after_ack(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n16_produced", false)
	var environment := _started_environment(sequence)
	if environment.is_empty() or not _advance_to_media(environment["executor"]):
		_expect(false, "environnement reprise apres ACK cree")
		return
	var resolver = MediaResolver.create(sequence, fixture["presentation_catalog"])["resolver"]
	var first = await _new_viewer()
	var first_adapter = MediaAdapter.create(environment["executor"], environment["port"], resolver, first, PortraitTheme.new())["adapter"]
	first_adapter.open_current_projection()
	await get_tree().process_frame
	_expect(_receipt_kind_count(environment["executor"], "PRESENTED") == 1, "ACK PRESENTED avant reprise")
	first.visible = false
	first.reset_viewer()
	var resumed = await _new_viewer()
	var resumed_adapter = MediaAdapter.create(environment["executor"], environment["port"], resolver, resumed, PortraitTheme.new())["adapter"]
	_expect(resumed_adapter.resume_from_execution()["ok"] and resumed.visible, "reprise WAITING_FOR_PLAYER reconstruit viewer")
	await get_tree().process_frame
	_expect(_receipt_kind_count(environment["executor"], "PRESENTED") == 1, "reprise apres ACK sans double receipt")
	_expect(resumed_adapter.continue_current_projection()["ok"], "CONTINUE disponible apres reprise")
	_dispose(first)
	_dispose(resumed)
	await get_tree().process_frame


func _test_durable_gallery(base: Dictionary, fixture: Dictionary) -> void:
	var sequence := _sequence_for_media(base, fixture, "synthetic_n16_produced", false)
	var resolver = MediaResolver.create(sequence, fixture["presentation_catalog"])["resolver"]
	var accessible := _record("synthetic_n16_produced", "ACCESSIBLE", "AVAILABLE", "ACTIVE")
	var projection_result: Dictionary = DurableGallery.create(sequence, {"synthetic_n16_produced": accessible}, resolver)
	_expect(projection_result["ok"], "projection galerie durable cree")
	var source_result: Dictionary = projection_result["projection"].content_source()
	_expect(source_result["ok"], "source galerie resolue")
	var source: Dictionary = source_result["source"]
	_expect(source["fixtures"]["marie"]["items"].size() == 1, "GRANT_ACCESS AVAILABLE rend media visible")

	var multi_registry := {
		"photo_multi_character": _record("photo_multi_character", "ACCESSIBLE", "AVAILABLE", "ACTIVE"),
		"photo_multi_child_one": _record("photo_multi_child_one", "ACCESSIBLE", "AVAILABLE", "ACTIVE"),
		"photo_multi_child_two": _record("photo_multi_child_two", "ACCESSIBLE", "AVAILABLE", "ACTIVE"),
	}
	var multi_registry_before: Dictionary = multi_registry.duplicate(true)
	var multi_result: Dictionary = DurableGallery.create(sequence, multi_registry, resolver)
	var multi_source_result: Dictionary = multi_result["projection"].content_source()
	var multi_source: Dictionary = multi_source_result["source"]
	_expect(multi_source_result["ok"], "projection multi-personnage resolue")
	_expect(
		multi_source["fixtures"]["marie"]["items"].size() == 1
		and multi_source["fixtures"]["pauline"]["items"].size() == 1,
		"meme media visible dans Marie et Pauline"
	)
	_expect(
		multi_source["fixtures"]["marie"]["items"][0]["item_id"] == "photo_multi_character"
		and multi_source["fixtures"]["pauline"]["items"][0]["item_id"] == "photo_multi_character"
		and multi_source["fixtures"]["marie"]["items"][0]["sequence_child_ids"] == [
			"photo_multi_character", "photo_multi_child_one", "photo_multi_child_two",
		]
		and multi_source["fixtures"]["pauline"]["items"][0]["sequence_child_ids"] == [
			"photo_multi_character", "photo_multi_child_one", "photo_multi_child_two",
		],
		"multi-onglets conserve le meme item_id et les memes enfants"
	)
	_expect(
		multi_source["children_by_id"].size() == 3
		and multi_source["children_by_id"].values().all(
			func(child): return not child.has("character_id")
		),
		"catalogue enfants global character-neutral"
	)
	_expect(
		multi_result["projection"].durable_registry_snapshot() == multi_registry_before,
		"multi-onglets conserve exactement les trois records durables sans duplication"
	)
	var multi_gallery = GalleryScreenScene.instantiate()
	multi_gallery.configure_content_source(multi_source)
	add_child(multi_gallery)
	await get_tree().process_frame
	for character_id in ["marie", "pauline"]:
		multi_gallery.select_character(character_id)
		var viewer_sequence: Array[Dictionary] = multi_gallery.viewer_sequence_for_item(
			"photo_multi_character"
		)
		_expect(
			viewer_sequence.size() == 3
			and viewer_sequence.all(
				func(presentation): return presentation["character_id"] == character_id
			),
			"sequence viewer projetee depuis l'onglet " + character_id
		)
		var multi_viewer = await _new_viewer()
		_expect(
			multi_viewer.configure(viewer_sequence, 0, PortraitTheme.new()),
			"PhotoViewer ouvre la sequence depuis l'onglet " + character_id
		)
		_dispose(multi_viewer)
	multi_gallery.queue_free()
	await get_tree().process_frame

	var separated_record := _record("photo_audience_separated", "ACCESSIBLE", "AVAILABLE", "ACTIVE")
	var separated_result: Dictionary = DurableGallery.create(
		sequence, {"photo_audience_separated": separated_record}, resolver
	)
	var separated_source: Dictionary = separated_result["projection"].content_source()["source"]
	_expect(
		separated_source["fixtures"]["sandra"]["items"].size() == 1
		and not separated_source["fixtures"].has("player_only"),
		"audience player_only projetee sous Sandra sans onglet audience"
	)

	var never_sequence := sequence.duplicate(true)
	never_sequence["media"]["photo_audience_separated"]["gallery_policy"] = "NEVER"
	var never_resolver = MediaResolver.create(never_sequence, fixture["presentation_catalog"])["resolver"]
	var never_result: Dictionary = DurableGallery.create(
		never_sequence, {"photo_audience_separated": separated_record}, never_resolver
	)
	var never_snapshot: Dictionary = never_result["projection"].durable_registry_snapshot()
	var never_source: Dictionary = never_result["projection"].content_source()
	_expect(
		not never_source["ok"]
		and never_source["error_code"] == "AVAILABLE_MEDIA_FORBIDDEN_BY_GALLERY_POLICY"
		and never_source["source"].is_empty(),
		"AVAILABLE avec gallery_policy NEVER refuse sans affichage"
	)
	_expect(
		never_result["projection"].durable_registry_snapshot() == never_snapshot,
		"incoherence gallery_policy refusee sans mutation durable"
	)
	for state in [
		["ACCESSIBLE", "HIDDEN", "ACTIVE"],
		["REVOKED", "HIDDEN", "ACTIVE"],
		["REVOKED", "HIDDEN", "WITHDRAWN"],
	]:
		var registry := {"synthetic_n16_produced": _record("synthetic_n16_produced", state[0], state[1], state[2])}
		var hidden_projection = DurableGallery.create(sequence, registry, resolver)["projection"]
		var hidden_source: Dictionary = hidden_projection.content_source()["source"]
		_expect(hidden_source["character_order"].is_empty(), "%s/%s/%s retire le media" % state)

	var registry_before: Dictionary = projection_result["projection"].durable_registry_snapshot()
	var gallery = GalleryScreenScene.instantiate()
	gallery.configure_content_source(source)
	add_child(gallery)
	await get_tree().process_frame
	_expect(gallery.unlocked_item_count() == 1 and gallery.new_item_count() == 1, "GalleryScreen canonique consomme source durable")
	var sequence_for_viewer: Array[Dictionary] = gallery.viewer_sequence_for_item("synthetic_n16_produced")
	_expect(sequence_for_viewer.size() == 1 and typeof(sequence_for_viewer[0].get("resolved_media")) == TYPE_DICTIONARY, "GalleryScreen transmet presentation deja resolue")
	_expect(gallery.mark_viewed("synthetic_n16_produced"), "NEW devient VIEWED en UI")
	_expect(gallery.display_state_for_item("synthetic_n16_produced") == "VIEWED", "VIEWED galerie cosmetique")
	_expect(projection_result["projection"].durable_registry_snapshot() == registry_before, "clic Galerie sans mutation durable A1-A5")
	gallery.queue_free()
	await get_tree().process_frame


func _started_environment(sequence: Dictionary) -> Dictionary:
	var messages_port = MessagesPhysicalPort.new(sequence)
	var media_port = MediaPort.new(sequence)
	var composite_result: Dictionary = CompositePort.create(messages_port, media_port)
	if not composite_result["ok"]:
		return {}
	var facade := FacadeStub.new(sequence)
	var created: Dictionary = SequenceExecutor.create(
		facade, composite_result["port"], sequence, _activation(sequence)
	)
	if not created["ok"] or not created["executor"].start()["ok"]:
		return {}
	return {"facade": facade, "port": composite_result["port"], "executor": created["executor"]}


func _advance_to_media(executor) -> bool:
	for _index in 8:
		var beat: Dictionary = executor.current_beat()
		if beat.get("type") == "MEDIA_REVEAL":
			return true
		var opened: Dictionary = executor.open_current_projection()
		if not opened.get("ok", false):
			return false
		var request: Dictionary = opened["payload"]["request"]
		var presentation_id: String = opened["payload"]["port_result"]["presentation_id"]
		var receipt := _receipt(request, presentation_id, "PRESENTED", _subject_for(beat))
		if not executor.receive_ack(receipt).get("ok", false):
			return false
		if not executor.receive_command(_command(request)).get("ok", false):
			return false
	return false


func _sequence_for_media(base: Dictionary, fixture: Dictionary, media_id: String, requires_ack: bool) -> Dictionary:
	var result := base.duplicate(true)
	for definition_id in fixture["media_definitions"]:
		result["media"][definition_id] = fixture["media_definitions"][definition_id].duplicate(true)
	var beat: Dictionary = _beat(result, "beat_media")
	beat["content"]["media_id"] = media_id
	beat["content"]["requires_ack"] = requires_ack
	return result


func _activation(sequence: Dictionary) -> Dictionary:
	var a6: Dictionary = sequence["orchestration"]["a6_entry"]
	var option := {
		"option_id": "primary_option",
		"instance_id": INSTANCE_ID,
		"scene_definition_id": a6["scene_definition_id"],
		"variant_id": a6["variant_id"],
		"state": "PROPOSED",
		"materialized": true,
	}
	return {
		"ok": true,
		"activation_state": "PROPOSED",
		"scene_state": "PROPOSED",
		"instance_id": INSTANCE_ID,
		"option_id": "primary_option",
		"window": {
			"state": "CLOSED",
			"selected_option_id": "primary_option",
			"options": [option],
		},
	}


func _receipt(request: Dictionary, presentation_id: String, kind: String, subject_id: String) -> Dictionary:
	return {
		"presentation_id": presentation_id,
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": request["beat_type"],
		"projection_target": request["projection_target"],
		"kind": kind,
		"subject_id": subject_id,
	}


func _command(request: Dictionary) -> Dictionary:
	return {
		"command_id": "n16_smoke_" + request["beat_id"],
		"instance_id": request["instance_id"],
		"beat_id": request["beat_id"],
		"kind": "CONTINUE",
		"choice_id": null,
	}


func _subject_for(beat: Dictionary) -> String:
	match beat.get("type"):
		"MESSAGE":
			return beat["content"]["messages"][0]["message_id"]
		"TRANSITION":
			return beat["content"]["transition_id"]
		"PHYSICAL_BEAT":
			return beat["content"]["physical_beat_id"]
		_:
			return beat["beat_id"]


func _record(media_id: String, access: String, gallery: String, withdrawal: String) -> Dictionary:
	return {
		"media_id": media_id,
		"diegetic_status": "CREATED",
		"fictional_audience_ids": ["player_only"],
		"access_status": access,
		"gallery_status": gallery,
		"withdrawal_status": withdrawal,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_n16_smoke"},
	}


func _new_viewer():
	var viewer = PhotoViewerScene.instantiate()
	viewer.visible = false
	add_child(viewer)
	await get_tree().process_frame
	return viewer


func _dispose(node) -> void:
	if node != null and is_instance_valid(node):
		node.queue_free()


func _receipt_kind_count(executor, kind: String) -> int:
	var count := 0
	var state: Dictionary = executor.execution_state()
	for presentation_id in state.get("projection_receipts", {}):
		var receipt_kind = state["projection_receipts"][presentation_id]
		if receipt_kind == kind and str(presentation_id).ends_with("__MEDIA"):
			count += 1
	return count


func _beat(sequence: Dictionary, beat_id: String) -> Dictionary:
	for beat in sequence["beats"]:
		if beat["beat_id"] == beat_id:
			return beat
	return {}


func _load_json(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _restore_integer_types(sequence: Dictionary) -> void:
	sequence["schema_version"] = int(sequence["schema_version"])
	var orchestration: Dictionary = sequence["orchestration"]
	orchestration["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"] = int(
		orchestration["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"]
	)
	orchestration["a9_slot"]["duration_minutes"] = int(orchestration["a9_slot"]["duration_minutes"])
	orchestration["a9_slot"]["relative_order"] = int(orchestration["a9_slot"]["relative_order"])
	sequence["temporal_projection"]["offset_minutes"] = int(sequence["temporal_projection"]["offset_minutes"])
	sequence["temporal_projection"]["relative_order"] = int(sequence["temporal_projection"]["relative_order"])
	for beat in sequence["beats"]:
		if beat["type"] == "MESSAGE":
			for message in beat["content"]["messages"]:
				message["relative_order"] = int(message["relative_order"])
		if beat["type"] == "RETURN":
			beat["content"]["delay"]["value"] = int(beat["content"]["delay"]["value"])


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("R8C_N16_MEDIA_REVEAL_GALLERY_PROJECTION: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("R8C_N16_MEDIA_REVEAL_GALLERY_PROJECTION: " + failure)
	get_tree().quit(1)
