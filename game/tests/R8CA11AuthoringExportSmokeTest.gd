extends Node

const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const FIXTURE_PATH := "res://data/narrative_scenes/r8c_a11_sandra_last_lunch_export.json"

var failures: Array[String] = []
var checks := 0


func _ready() -> void:
	var result: Dictionary = BibliothequeModele.charger_depuis_json(FIXTURE_PATH)
	_expect(result["ok"], "chargement A6 explicite")
	if result["ok"]:
		var library = result["bibliotheque"]
		_expect(
			library.obtenir_ids_tries() == ["r8c_a11_sandra_last_lunch_definition"],
			"identite exportee",
		)
		var definition: Dictionary = library.obtenir_definition("r8c_a11_sandra_last_lunch_definition")
		_expect(definition["version_contrat"] == "1.0.0-prototype", "version prototype")
		_expect(
			definition["participants_requis"].map(
				func(participant): return participant["personnage_id"]
			) == ["sandra", "player"],
			"participants actifs Sandra et Player uniquement",
		)
		_expect(definition["choix"].size() == 2, "deux attitudes")
		_expect(definition["resolutions"].size() == 2, "deux receptions")
		_expect(
			definition["resolutions"]["careful_warmth_reception"]["interpretation"] == "intriguée_touchée",
			"reception chaleur prudente",
		)
		_expect(
			definition["resolutions"]["ironic_withdrawal_reception"]["interpretation"] == "défensive_embarrassée",
			"reception retrait ironique",
		)
		_expect(
			definition["resolutions"].values().all(
				func(resolution): return resolution["convergence"] == "RETOUR_NOYAU_COMMUN"
			),
			"convergence A3",
		)
	if failures.is_empty() and checks == 9:
		print("R8C_A11_AUTHORING_EXPORT: OK (%d controles)" % checks)
		get_tree().quit(0)
	else:
		push_error("R8C_A11_AUTHORING_EXPORT: ECHEC %s (%d/9)" % [failures, checks])
		get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)
