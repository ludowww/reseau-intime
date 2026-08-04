extends Node

const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const FIXTURE_PATH := "res://data/narrative_scenes/r8c_a11_4_sandra_recontact_after_silence_export.json"

var failures: Array[String] = []
var checks := 0


func _ready() -> void:
	var result: Dictionary = BibliothequeModele.charger_depuis_json(FIXTURE_PATH)
	_expect(result["ok"], "chargement A6 par chemin explicite")
	if result["ok"]:
		var library = result["bibliotheque"]
		_expect(
			library.obtenir_ids_tries() == ["r8c_a11_4_sandra_recontact_after_silence_definition"],
			"identite synthetique A11.4",
		)
		var definition: Dictionary = library.obtenir_definition(
			"r8c_a11_4_sandra_recontact_after_silence_definition"
		)
		_expect(definition["version_contrat"] == "1.0.0-a11-4-test-prototype", "version de test")
		_expect(
			definition["participants_requis"].map(
				func(participant): return participant["personnage_id"]
			) == ["player", "sandra"],
			"participants Player et Sandra uniquement",
		)
		_expect("marie" not in str(definition["participants_requis"]).to_lower(), "Marie reste contextuelle")
		_expect(
			definition["choix"].map(func(option): return option["choix_id"]) == [
				"acknowledge_importance_without_claim",
				"maintain_light_indirectness",
			],
			"deux attitudes exactes",
		)
		_expect(
			definition["choix"].map(func(option): return option["formulation"]) == [
				"Parce que l'autre soir a compté.",
				"Parce que ce ticket méritait mieux.",
			],
			"formulations finales conservees",
		)
		var resolutions: Dictionary = definition["resolutions"]
		_expect(resolutions.size() == 2, "deux receptions Sandra")
		_expect(
			resolutions["acknowledge_importance_without_claim_reception"]["interpretation"]
				== "importance_entendue_rythme_protege"
			and resolutions["maintain_light_indirectness_reception"]["interpretation"]
				== "detour_accepte_portee_ambigue",
			"receptions distinctes",
		)
		_expect(
			resolutions.values().all(
				func(resolution): return resolution["portee_micro_signal"] == "LOCALE"
			),
			"portee locale",
		)
		_expect(
			resolutions.values().all(
				func(resolution): return resolution["reception"] == "NON_PERSISTANTE"
			),
			"receptions non persistantes",
		)
		_expect(
			resolutions.values().all(
				func(resolution): return resolution["faits_relationnels"].is_empty()
			),
			"aucun fait durable",
		)
		_expect(
			resolutions.values().all(
				func(resolution): return resolution["convergence"] == "RETOUR_NOYAU_COMMUN"
			),
			"convergence commune",
		)
		_expect(not definition.has("messages"), "bulles auteur non inventees dans A6")
		_expect(
			not definition.has("approval_fingerprint") and not definition.has("projection_report"),
			"preuves editoriales absentes du runtime",
		)
	if failures.is_empty() and checks == 15:
		print("R8C_A11_4_PLAN_DRAFT_A6_EXPORT: OK (%d controles)" % checks)
		get_tree().quit(0)
	else:
		push_error("R8C_A11_4_PLAN_DRAFT_A6_EXPORT: ECHEC %s (%d/15)" % [failures, checks])
		get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)
