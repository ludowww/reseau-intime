extends Node

const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")
const BUNDLE_PATH := "res://data/narrative_scenes/r8c_a6_prototype_library.json"

var failures: Array[String] = []
var controles := 0


func _ready() -> void:
	_executer()
	if controles != 34:
		failures.append("nombre de controles inattendu: %d/34" % controles)
	if failures.is_empty():
		print("R8C_A6_MINIMAL_NARRATIVE_LIBRARY: OK (%d controles)" % controles)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _executer() -> void:
	var charge: Dictionary = BibliothequeModele.charger_depuis_json(BUNDLE_PATH)
	_expect(
		charge["ok"] and charge["bibliotheque"] != null,
		"01 bundle prototype charge: %s %s" % [charge.get("erreur"), charge.get("details")],
	)
	if not charge["ok"]:
		return
	var bibliotheque = charge["bibliotheque"]
	var ids_attendus := [
		"r8c_a6_distance_raphaelle_definition",
		"r8c_a6_distance_sandra_definition",
		"r8c_a6_signature_sandra_definition",
	]
	_expect(bibliotheque.obtenir_ids_tries() == ids_attendus, "02 identifiants tries")
	_expect(bibliotheque.obtenir_identites_triees().size() == 3, "03 identites structurees")
	var copie: Dictionary = bibliotheque.obtenir_definition(ids_attendus[0])
	copie["scene_id"] = "mutation_externe"
	_expect(
		bibliotheque.obtenir_definition(ids_attendus[0])["scene_id"] == ids_attendus[0],
		"04 lecture defensive",
	)

	var bundle := _charger_bundle_brut()
	var racine_inconnue: Dictionary = bundle.duplicate(true)
	racine_inconnue["champ_inconnu"] = true
	_expect(_rejet_atomique(racine_inconnue, "SCHEMA_RACINE_INVALIDE"), "05 racine fermee")
	var partiel: Dictionary = bundle.duplicate(true)
	partiel["definitions"][1]["definition"]["conditions_dures"]["champ_inconnu"] = true
	_expect(_rejet_atomique(partiel, "DEFINITION_INVALIDE"), "06 rejet atomique partiel")
	var version_inconnue: Dictionary = bundle.duplicate(true)
	version_inconnue["version"] = 2
	_expect(_rejet_atomique(version_inconnue, "VERSION_BUNDLE_INCONNUE"), "07 version inconnue")
	var scene_dupliquee: Dictionary = bundle.duplicate(true)
	scene_dupliquee["definitions"][1]["scene_definition_id"] = scene_dupliquee["definitions"][0]["scene_definition_id"]
	scene_dupliquee["definitions"][1]["definition"]["scene_id"] = scene_dupliquee["definitions"][0]["scene_definition_id"]
	_expect(_rejet_atomique(scene_dupliquee, "SCENE_DEFINITION_ID_DUPLIQUE"), "08 scene_definition_id duplique")
	var variante_dupliquee: Dictionary = bundle.duplicate(true)
	variante_dupliquee["definitions"][1]["variant_id"] = variante_dupliquee["definitions"][0]["variant_id"]
	_expect(_rejet_atomique(variante_dupliquee, "VARIANT_ID_DUPLIQUE"), "09 variant_id duplique")
	var variante_absente: Dictionary = bundle.duplicate(true)
	variante_absente["definitions"][0].erase("variant_id")
	_expect(_rejet_atomique(variante_absente, "ENTREE_INVALIDE"), "10 variant_id explicite requis")
	var variante_vide: Dictionary = bundle.duplicate(true)
	variante_vide["definitions"][0]["variant_id"] = ""
	_expect(_rejet_atomique(variante_vide, "VARIANT_ID_INVALIDE"), "11 variant_id vide refuse")
	var identite_confondue: Dictionary = bundle.duplicate(true)
	identite_confondue["definitions"][0]["variant_id"] = identite_confondue["definitions"][0]["scene_definition_id"]
	_expect(_rejet_atomique(identite_confondue, "IDENTITES_CONFONDUES"), "12 identites distinctes")
	var identite_a3: Dictionary = bundle.duplicate(true)
	identite_a3["definitions"][0]["definition"]["scene_id"] = "r8c_a6_autre_definition"
	_expect(_rejet_atomique(identite_a3, "IDENTITE_A3_INCOHERENTE"), "13 projection A3 coherente")
	var permute: Dictionary = bundle.duplicate(true)
	permute["definitions"].reverse()
	var charge_permute: Dictionary = BibliothequeModele.charger_depuis_bundle(permute)
	_expect(
		charge_permute["ok"] and charge_permute["bibliotheque"].obtenir_ids_tries() == ids_attendus,
		"14 ordre stable apres permutation",
	)
	_expect(
		not BibliothequeModele.charger_depuis_json("res://data/characters/sandra.json")["ok"],
		"15 chemin ferme sans scan libre",
	)

	_test_requete_sans_mutation(bibliotheque)
	_test_filtres_a3(bibliotheque)
	_test_variantes_non_interchangeables(bibliotheque)
	_test_unicite_deja_consommee(bibliotheque)


func _test_requete_sans_mutation(bibliotheque) -> void:
	var etat = _nouvel_etat()
	var moteur := MoteurModele.new()
	var contexte := _contexte("a6-query-readonly", "2030-04-09T13:00:00+02:00", {"sandra": true})
	var avant_etat: Dictionary = etat.obtenir_snapshot()
	var avant_moteur: Dictionary = moteur.obtenir_snapshot(etat)
	var resultat: Dictionary = bibliotheque.query_candidates(moteur, etat, contexte)
	_expect(resultat["ok"] and resultat["candidats"].is_empty(), "16 absence de compatibilite silencieuse")
	_expect(etat.obtenir_snapshot() == avant_etat, "17 query sans mutation A1")
	_expect(moteur.obtenir_snapshot(etat) == avant_moteur, "18 query sans instance ni snapshot A5")
	_expect(not resultat.has("diagnostics_refuses"), "19 refus absents du resultat joueur")
	var dev: Dictionary = bibliotheque.query_candidates_dev(moteur, etat, contexte)
	_expect(dev["ok"] and dev["diagnostics_refuses"].size() == 3, "20 diagnostics complets en test")
	_expect(dev["diagnostics_refuses"][0].has("diagnostic"), "21 details A3 conserves en test")


func _test_filtres_a3(bibliotheque) -> void:
	var etat = _nouvel_etat()
	_expect(_ajouter_evenement(etat, "r8c-a6-sandra-away", "sandra"), "22 evenement requis ajoute")
	var moteur := MoteurModele.new()
	var contexte := _contexte("a6-filter", "2030-04-09T13:00:00+02:00", {"sandra": true})
	var compatible: Dictionary = bibliotheque.query_candidates(moteur, etat, contexte)
	_expect(
		compatible["candidats"].size() == 1
		and compatible["candidats"][0]["variant_id"] == "sandra_distance"
		and not compatible["candidats"][0].has("diagnostic"),
		"23 filtre evenement et variante Sandra",
	)
	var autre_acte: Dictionary = contexte.duplicate(true)
	autre_acte["acte_courant"] = "ACTE_INCOMPATIBLE"
	_expect(bibliotheque.query_candidates(moteur, etat, autre_acte)["candidats"].is_empty(), "24 filtre acte")
	var indisponible: Dictionary = contexte.duplicate(true)
	indisponible["participants_disponibles"]["sandra"] = false
	_expect(bibliotheque.query_candidates(moteur, etat, indisponible)["candidats"].is_empty(), "25 filtre disponibilite")
	var hors_fenetre: Dictionary = contexte.duplicate(true)
	hors_fenetre["moment_diegetique"] = "2030-04-09T21:00:00+02:00"
	_expect(bibliotheque.query_candidates(moteur, etat, hors_fenetre)["candidats"].is_empty(), "26 filtre fenetre")
	var opportunite_invalide: Dictionary = contexte.duplicate(true)
	opportunite_invalide["opportunite_valide"] = false
	_expect(bibliotheque.query_candidates(moteur, etat, opportunite_invalide)["candidats"].is_empty(), "27 filtre opportunite")
	_expect(_ajouter_evenement(etat, "r8c-a6-sandra-returned", "sandra"), "28 evenement interdit ajoute")
	_expect(bibliotheque.query_candidates(moteur, etat, contexte)["candidats"].is_empty(), "29 filtre evenement interdit")


func _test_variantes_non_interchangeables(bibliotheque) -> void:
	var etat = _nouvel_etat()
	_ajouter_evenement(etat, "r8c-a6-sandra-away", "sandra")
	_ajouter_evenement(etat, "r8c-a6-raphaelle-away", "raphaelle")
	var contexte := _contexte(
		"a6-two-variants",
		"2030-04-09T13:00:00+02:00",
		{"sandra": true, "raphaelle": true},
	)
	var resultat: Dictionary = bibliotheque.query_candidates(MoteurModele.new(), etat, contexte)
	var variantes: Array = resultat["candidats"].map(func(candidat): return candidat["variant_id"])
	_expect(variantes == ["raphaelle_distance", "sandra_distance"], "30 ordre structure variants stable")
	var sandra: Dictionary = bibliotheque.obtenir_definition("r8c_a6_distance_sandra_definition")
	var raphaelle: Dictionary = bibliotheque.obtenir_definition("r8c_a6_distance_raphaelle_definition")
	_expect(
		sandra["structure_id"] == raphaelle["structure_id"]
		and sandra["participants_requis"] != raphaelle["participants_requis"],
		"31 structure commune sans variantes interchangeables",
	)


func _test_unicite_deja_consommee(bibliotheque) -> void:
	var etat = _nouvel_etat()
	_ajouter_evenement(etat, "r8c-a6-sandra-ready", "sandra")
	var moteur := MoteurModele.new()
	var contexte := _contexte("a6-signature-instance", "2030-04-08T19:00:00+02:00", {"sandra": true})
	var avant: Dictionary = bibliotheque.query_candidates(moteur, etat, contexte)
	var definition: Dictionary = bibliotheque.obtenir_definition("r8c_a6_signature_sandra_definition")
	var diagnostic: Dictionary = moteur.evaluer_definition(definition, etat, contexte)
	var instance = moteur.creer_instance(definition, diagnostic, contexte)
	var snapshot_consomme: Dictionary = moteur.obtenir_snapshot(etat)
	var contexte_apres: Dictionary = contexte.duplicate(true)
	contexte_apres["instance_id"] = "a6-signature-autre-instance"
	var apres: Dictionary = bibliotheque.query_candidates(moteur, etat, contexte_apres)
	_expect(
		avant["candidats"].size() == 1 and instance != null and apres["candidats"].is_empty(),
		"32 UNIQUE deja connue exclue",
	)
	_expect(moteur.obtenir_snapshot(etat) == snapshot_consomme, "33 query apres UNIQUE sans mutation A5")
	_expect(etat.obtenir_snapshot()["evenements"].size() == 1, "34 aucune opportunite manquee creee")


func _rejet_atomique(bundle: Dictionary, erreur_attendue: String) -> bool:
	var resultat: Dictionary = BibliothequeModele.charger_depuis_bundle(bundle)
	return not resultat["ok"] and resultat["erreur"] == erreur_attendue and resultat["bibliotheque"] == null


func _charger_bundle_brut() -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(BUNDLE_PATH))
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _nouvel_etat():
	return EtatNarratifModele.creer_synthetique({
		"statut_couple": "EN_CLARIFICATION",
		"contrat_couple": null,
		"etat_divulgation": "PARTIEL",
		"etat_foyer": null,
		"relation_apres_separation": null,
		"dernier_evenement_majeur_id": null,
		"faits": [],
		"cadre_provisoire": null,
	})


func _ajouter_evenement(etat, event_id: String, personnage_id: String) -> bool:
	var faits: Array = etat.obtenir_snapshot()["relations"][personnage_id]["faits"].duplicate(true)
	faits.append({"fait_id": event_id + "-fait", "nature": "PRECONDITION_SYNTHETIQUE"})
	var resultat: Dictionary = etat.traiter_evenement({
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a6_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})
	return resultat["ok"]


func _contexte(instance_id: String, moment: String, disponibilites: Dictionary) -> Dictionary:
	return {
		"instance_id": instance_id,
		"acte_courant": "ACTE_SYNTHETIQUE_A6",
		"moment_diegetique": moment,
		"participants_disponibles": disponibilites,
		"opportunite_valide": true,
	}


func _expect(condition: bool, message: String) -> void:
	controles += 1
	if not condition:
		failures.append(message)
