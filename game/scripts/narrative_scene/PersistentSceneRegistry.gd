extends RefCounted

class_name R8CPersistentSceneRegistry

const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")
const MAX_INSTANCES := 1024

var _instances_par_id: Dictionary = {}


static func creer_depuis_snapshot(snapshot) -> R8CPersistentSceneRegistry:
	if typeof(snapshot) != TYPE_ARRAY or snapshot.size() > MAX_INSTANCES:
		return null
	var registre := new()
	for donnees in snapshot:
		if typeof(donnees) != TYPE_DICTIONARY:
			return null
		var instance = InstanceModele.creer_depuis_snapshot_persistant(donnees)
		if instance == null:
			return null
		var resultat := registre.enregistrer(instance)
		if not resultat["ok"]:
			return null
	return registre


func enregistrer(instance) -> Dictionary:
	if instance == null:
		return _resultat(false, "INSTANCE_ABSENTE")
	if _instances_par_id.size() >= MAX_INSTANCES:
		return _resultat(false, "REGISTRE_SCENES_PLEIN")
	var instance_id: String = instance.obtenir_instance_id()
	if _instances_par_id.has(instance_id):
		return _resultat(false, "INSTANCE_ID_DUPLIQUE")
	for existante in _instances_par_id.values():
		if (
			existante.obtenir_scene_definition_id() == instance.obtenir_scene_definition_id()
			and (instance.obtenir_politique_unicite() == "UNIQUE" or existante.obtenir_politique_unicite() == "UNIQUE")
		):
			return _resultat(false, "SCENE_UNIQUE_DEJA_INSTANCIEE")
	_instances_par_id[instance_id] = instance
	return _resultat(true, "")


func obtenir_instance(instance_id: String):
	return _instances_par_id.get(instance_id)


func scene_unique_connue(scene_definition_id: String, instance_id_exclu: String = "") -> bool:
	for instance_id in _instances_par_id:
		if instance_id == instance_id_exclu:
			continue
		if _instances_par_id[instance_id].obtenir_scene_definition_id() == scene_definition_id:
			return true
	return false


func obtenir_snapshot() -> Array:
	var instance_ids: Array = _instances_par_id.keys()
	instance_ids.sort()
	var snapshot := []
	for instance_id in instance_ids:
		snapshot.append(_instances_par_id[instance_id].obtenir_snapshot_persistant())
	return snapshot


func _resultat(ok: bool, erreur: String) -> Dictionary:
	return {"ok": ok, "erreur": erreur}
