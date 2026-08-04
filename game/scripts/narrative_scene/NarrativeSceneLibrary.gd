extends RefCounted

class_name R8CNarrativeSceneLibrary

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const DataLoaderModele := preload("res://scripts/core/DataLoader.gd")

const DOSSIER_CANONIQUE := "res://data/narrative_scenes/"
const FORMAT_BUNDLE := "R8C_A6_SCENE_LIBRARY"
const VERSION_BUNDLE := 1
const MAX_DEFINITIONS := 32
const CHAMPS_RACINE := ["format", "version", "definitions"]
const CHAMPS_ENTREE := ["scene_definition_id", "variant_id", "definition"]

var _entrees_triees: Array = []
var _entrees_par_scene_id: Dictionary = {}


static func charger_depuis_json(path: String) -> Dictionary:
	var chemin := path.simplify_path()
	if (
		path.is_empty()
		or not chemin.begins_with(DOSSIER_CANONIQUE)
		or not chemin.ends_with(".json")
	):
		return _echec("CHEMIN_BUNDLE_INVALIDE", "bundle hors du dossier narratif canonique")
	var lecteur = DataLoaderModele.new()
	var bundle: Dictionary = lecteur.load_json(chemin)
	var erreurs: Array = lecteur.load_errors.duplicate()
	lecteur.free()
	if not erreurs.is_empty():
		return _echec("LECTURE_BUNDLE_ECHOUEE", str(erreurs[0]))
	return charger_depuis_bundle(bundle)


static func charger_depuis_bundle(bundle) -> Dictionary:
	if typeof(bundle) != TYPE_DICTIONARY:
		return _echec("RACINE_BUNDLE_INVALIDE", "la racine doit etre un objet")
	if not _cles_exactes(bundle, CHAMPS_RACINE):
		return _echec("SCHEMA_RACINE_INVALIDE", "champs racine inconnus ou manquants")
	if bundle["format"] != FORMAT_BUNDLE:
		return _echec("FORMAT_BUNDLE_INCONNU", "format de bundle inconnu")
	if (
		typeof(bundle["version"]) not in [TYPE_INT, TYPE_FLOAT]
		or float(bundle["version"]) != float(VERSION_BUNDLE)
		or float(bundle["version"]) != floor(float(bundle["version"]))
	):
		return _echec("VERSION_BUNDLE_INCONNUE", "version de bundle inconnue")
	var definitions = bundle["definitions"]
	if (
		typeof(definitions) != TYPE_ARRAY
		or definitions.is_empty()
		or definitions.size() > MAX_DEFINITIONS
	):
		return _echec("COLLECTION_DEFINITIONS_INVALIDE", "collection absente, vide ou hors borne")

	var scene_ids := {}
	var variant_ids := {}
	var entrees_candidates: Array = []
	for index in definitions.size():
		var entree = definitions[index]
		if typeof(entree) != TYPE_DICTIONARY or not _cles_exactes(entree, CHAMPS_ENTREE):
			return _echec("ENTREE_INVALIDE", "entree %d: schema inconnu ou incomplet" % index)
		var scene_definition_id = entree["scene_definition_id"]
		var variant_id = entree["variant_id"]
		if not _identifiant_valide(scene_definition_id):
			return _echec("SCENE_DEFINITION_ID_INVALIDE", "entree %d" % index)
		if not _identifiant_valide(variant_id):
			return _echec("VARIANT_ID_INVALIDE", "entree %d" % index)
		if scene_definition_id == variant_id:
			return _echec("IDENTITES_CONFONDUES", "definition et variante doivent rester distinctes")
		if scene_ids.has(scene_definition_id):
			return _echec("SCENE_DEFINITION_ID_DUPLIQUE", str(scene_definition_id))
		if variant_ids.has(variant_id):
			return _echec("VARIANT_ID_DUPLIQUE", str(variant_id))
		var definition = entree["definition"]
		if typeof(definition) != TYPE_DICTIONARY:
			return _echec("DEFINITION_INVALIDE", "entree %d: definition absente" % index)
		if definition.get("scene_id") != scene_definition_id:
			return _echec("IDENTITE_A3_INCOHERENTE", "scene_definition_id differe de scene_id")
		var erreur_definition := DefinitionModele.valider_fermee(definition)
		if not erreur_definition.is_empty():
			return _echec("DEFINITION_INVALIDE", "entree %d: %s" % [index, erreur_definition])
		scene_ids[scene_definition_id] = true
		variant_ids[variant_id] = true
		entrees_candidates.append(entree.duplicate(true))

	entrees_candidates.sort_custom(_entree_avant)
	var bibliotheque = new()
	bibliotheque._publier(entrees_candidates)
	return {"ok": true, "erreur": "", "details": "", "bibliotheque": bibliotheque}


func obtenir_definition(scene_definition_id: String) -> Dictionary:
	var entree = _entrees_par_scene_id.get(scene_definition_id)
	if entree == null:
		return {}
	return entree["definition"].duplicate(true)


func obtenir_ids_tries() -> Array[String]:
	var resultat: Array[String] = []
	for entree in _entrees_triees:
		resultat.append(entree["scene_definition_id"])
	return resultat


func obtenir_identites_triees() -> Array:
	var resultat: Array = []
	for entree in _entrees_triees:
		resultat.append({
			"scene_definition_id": entree["scene_definition_id"],
			"variant_id": entree["variant_id"],
		})
	return resultat


func query_candidates(moteur, etat_narratif, contexte: Dictionary) -> Dictionary:
	return _query_candidates(moteur, etat_narratif, contexte, false)


func query_candidates_dev(moteur, etat_narratif, contexte: Dictionary) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {
			"ok": false,
			"erreur": "DIAGNOSTICS_INDISPONIBLES",
			"candidats": [],
		}
	return _query_candidates(moteur, etat_narratif, contexte, true)


func _publier(entrees_candidates: Array) -> void:
	_entrees_triees = entrees_candidates.duplicate(true)
	_entrees_par_scene_id.clear()
	for entree in _entrees_triees:
		_entrees_par_scene_id[entree["scene_definition_id"]] = entree


func _query_candidates(
	moteur,
	etat_narratif,
	contexte: Dictionary,
	inclure_diagnostics: bool
) -> Dictionary:
	if (
		moteur == null
		or typeof(moteur) != TYPE_OBJECT
		or not moteur.has_method("evaluer_definition")
	):
		return {"ok": false, "erreur": "MOTEUR_A3_INVALIDE", "candidats": []}
	if (
		etat_narratif == null
		or typeof(etat_narratif) != TYPE_OBJECT
		or not etat_narratif.has_method("obtenir_snapshot")
	):
		return {"ok": false, "erreur": "ETAT_NARRATIF_ABSENT", "candidats": []}
	var candidats: Array = []
	var diagnostics_refuses: Array = []
	for entree in _entrees_triees:
		var definition: Dictionary = entree["definition"].duplicate(true)
		var diagnostic: Dictionary = moteur.evaluer_definition(definition, etat_narratif, contexte)
		var identite := {
			"scene_definition_id": entree["scene_definition_id"],
			"definition_version": definition["version_contrat"],
			"variant_id": entree["variant_id"],
		}
		if diagnostic.get("eligible", false):
			var candidat: Dictionary = identite.duplicate(true)
			if inclure_diagnostics:
				candidat["diagnostic"] = diagnostic.duplicate(true)
			else:
				candidat["revalidation_requise_avant"] = diagnostic.get("revalidation_requise_avant")
			candidats.append(candidat)
		elif inclure_diagnostics:
			var refus: Dictionary = identite.duplicate(true)
			refus["diagnostic"] = diagnostic.duplicate(true)
			diagnostics_refuses.append(refus)
	var resultat := {"ok": true, "erreur": "", "candidats": candidats}
	if inclure_diagnostics:
		resultat["diagnostics_refuses"] = diagnostics_refuses
	return resultat


static func _cles_exactes(value: Dictionary, attendues: Array) -> bool:
	if value.size() != attendues.size():
		return false
	for champ in attendues:
		if not value.has(champ):
			return false
	return true


static func _identifiant_valide(value) -> bool:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96:
		return false
	if value != value.strip_edges():
		return false
	for index in value.length():
		var caractere: String = value.substr(index, 1)
		if caractere not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			return false
	return true


static func _entree_avant(a: Dictionary, b: Dictionary) -> bool:
	if a["scene_definition_id"] != b["scene_definition_id"]:
		return a["scene_definition_id"] < b["scene_definition_id"]
	return a["variant_id"] < b["variant_id"]


static func _diagnostics_detailles_autorises() -> bool:
	return OS.is_debug_build() or Engine.is_editor_hint()


static func _echec(code: String, details: String) -> Dictionary:
	return {"ok": false, "erreur": code, "details": details, "bibliotheque": null}
