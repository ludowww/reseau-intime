extends RefCounted

## Façade R8B de consultation. Elle ne possède aucun état et ne modifie jamais
## l'instance Season1State reçue.
class_name EtatNarratifLecture

const PERSONNAGES := ["marie", "sandra", "mathilde", "pauline", "raphaelle", "nico"]
const ETATS_VUE := ["NON_ETABLI", "INDETERMINE", "INCONNU", "ABSENT", "PRESENT", "ACTIF", "CLOS", "ENSEMBLE", "SEPARE", "FRACTURE", "RECONQUETE", "PROVISOIRE"]
const ETATS_REGISTRE_ACTIFS := ["ACTIVE", "PROPOSED", "AMENDED"]
const ETATS_TRACE_VISIBLES := ["ACTIVE", "PRIVATE_ACTIVE"]

func obtenir_resume_relation_centrale(etat: Season1State) -> Dictionary:
	var couple := _resume_couple(etat)
	return couple

func obtenir_resume_relation(personnage_id: String, etat: Season1State) -> Dictionary:
	var id := personnage_id.to_lower()
	if not PERSONNAGES.has(id):
		return {"personnage_id": personnage_id, "etat_arc": "INCONNU", "statut_relation": "INCONNU", "confiance": "INDETERMINE", "desir": "INDETERMINE", "intimite": "INDETERMINE", "secret": "INDETERMINE", "dernier_evenement_majeur_id": "", "faits_utiles": [], "debug": {"regle": "personnage_non_supporte", "champs_lus": []}}
	var source := _etat_arc_source(id, etat)
	var event_id := _dernier_id_pour_personnage(id, etat)
	return {
		"personnage_id": id,
		"etat_arc": _etat_arc_vue(source.value),
		"statut_relation": _statut_relation(id, source.value),
		"confiance": "INDETERMINE",
		"desir": "NONE" if id == "nico" else "INDETERMINE",
		"intimite": "INDETERMINE",
		"secret": _secret_pour(id, etat),
		"dernier_evenement_majeur_id": event_id,
		"faits_utiles": _faits_pour(id, etat),
		"debug": {"regle": source.rule, "champs_lus": source.fields, "registre_lu": source.registry, "valeur_runtime_legacy": source.value, "projection_evenement": "dernier identifiant de registre sourcé, trié de façon stable"},
	}

func obtenir_resume_etat_narratif(etat: Season1State) -> Dictionary:
	var relations: Array = []
	for id in PERSONNAGES:
		relations.append(obtenir_resume_relation(id, etat))
	return {
		"relation_centrale": obtenir_resume_relation_centrale(etat),
		"relations": relations,
		"acte_courant": _acte_pour_jour(etat.current_day),
		"jour_diegetique": etat.current_day,
		"promesses_actives_ids": _ids_actifs(etat.promises),
		"obligations_actives_ids": _ids_actifs(etat.obligations),
		"traces_pertinentes_ids": _ids_traces_pertinentes(etat.traces),
		"connaissances_majeures": _connaissances_bornees(etat.knowledge),
		"derniers_evenements_majeurs_ids": _derniers_evenements(etat),
		"debug": {"projection_acte": "projection de compatibilite sur le corpus historique J01-J21; ce jour n'est pas un acte", "champs_lus": ["current_day", "promises", "obligations", "traces", "knowledge", "foreground_history"]},
	}

func _resume_couple(etat: Season1State) -> Dictionary:
	var statut := _statut_couple(etat.couple_state)
	var separe := statut == "SEPARES"
	var contrat := "ABSENT" if separe else "INDETERMINE"
	var foyer := "ETABLI" if etat.household_rhythm_confirmed else "NON_ETABLI"
	var apres := "INDETERMINE" if separe else "ABSENT"
	return {"statut_couple": statut, "contrat_couple": contrat, "etat_divulgation": "INDETERMINE", "etat_foyer": foyer, "relation_apres_separation": apres, "dernier_evenement_majeur_id": _dernier_id_couple(etat), "faits_utiles": _faits_couple(etat), "debug": {"regle": "couple_state vers taxonomie de vue; aucun contrat implicite", "champs_lus": ["couple_state", "household_rhythm_confirmed", "j17_couple_outcome", "promises", "knowledge", "traces"], "raison_contrat": "le runtime ne porte aucun champ contrat_couple"}}

func _statut_couple(value: String) -> String:
	match value:
		"SEPARATION": return "SEPARES"
		"RECONQUEST_ACTIVE": return "RECONQUETE"
		"PROVISIONAL_AGREEMENT": return "PROVISOIRE"
		"FRACTURE", "DOUBLE_LIFE_FRAGILE", "STRAIN_VISIBLE": return "FRACTURE"
		"BASELINE_SHARED_LIFE": return "ENSEMBLE"
		_: return "INDETERMINE"

func _etat_arc_source(id: String, etat: Season1State) -> Dictionary:
	match id:
		"marie": return {"value": etat.couple_state, "rule": "etat de couple comme arc Marie/Player", "fields": ["couple_state"], "registry": []}
		"sandra": return {"value": etat.j18_sandra_outcome if etat.j18_sandra_outcome != "UNESTABLISHED" else etat.sandra_state, "rule": "resolution tardive prioritaire sinon etat de route", "fields": ["j18_sandra_outcome", "sandra_state"], "registry": ["traces", "knowledge"]}
		"mathilde": return {"value": etat.mathilde_state, "rule": "etat de route direct", "fields": ["mathilde_state"], "registry": ["knowledge"]}
		"pauline": return {"value": etat.j19_pauline_outcome if etat.j19_pauline_outcome != "UNESTABLISHED" else etat.pauline_state, "rule": "resolution tardive prioritaire sinon etat de route", "fields": ["j19_pauline_outcome", "pauline_state"], "registry": ["knowledge"]}
		"raphaelle": return {"value": etat.j19_raphaelle_outcome if etat.j19_raphaelle_outcome != "UNESTABLISHED" else etat.raphaelle_state, "rule": "resolution tardive prioritaire sinon etat de route", "fields": ["j19_raphaelle_outcome", "raphaelle_state"], "registry": ["traces", "knowledge"]}
		_: return {"value": etat.j20_nico_position if etat.j20_nico_position != "UNESTABLISHED" else etat.nico_state, "rule": "resolution tardive prioritaire sinon etat de route", "fields": ["j20_nico_position", "nico_state"], "registry": ["knowledge"]}

func _statut_relation(_id: String, etat_arc: String) -> String:
	if etat_arc in ["", "UNESTABLISHED"]: return "NON_ETABLI"
	if etat_arc in ["DISTANCE", "PROTECTIVE_DISTANCE", "TRUST_BROKEN", "COMPARTMENT_CLOSED", "BOUNDARY_REINFORCED"]: return "PAUSED"
	return "ACTIVE"

func _etat_arc_vue(value: String) -> String:
	if value in ["", "UNESTABLISHED"]: return "NON_ETABLI"
	if value in ["DISTANCE", "PROTECTIVE_DISTANCE", "TRUST_BROKEN", "COMPARTMENT_CLOSED", "BOUNDARY_REINFORCED"]: return "PAUSED"
	if value in ["REMOVED", "REFUSED", "NOT_CREATED"]: return "CLOSED"
	return "ACTIVE"

func _secret_pour(id: String, etat: Season1State) -> String:
	for fact in etat.knowledge.values():
		var knowers: Array = fact.get("initial_knowers", [])
		if knowers.has(_nom_canon(id)) and str(fact.get("shareability", "")) in ["PRIVATE", "PRIVATE_DO_NOT_SHARE", "OWNER_ONLY"]: return "PRESENT"
	return "INDETERMINE"

func _faits_pour(id: String, etat: Season1State) -> Array:
	var result: Array = []
	var nom := _nom_canon(id)
	for fact_id in etat.knowledge.keys():
		var fact: Dictionary = etat.knowledge[fact_id]
		if fact.get("initial_knowers", []).has(nom): result.append(_id_public("FAIT", str(fact_id)))
	result.sort()
	return result.slice(0, 5)

func _faits_couple(etat: Season1State) -> Array:
	var result: Array = []
	for fact_id in etat.knowledge.keys():
		if str(fact_id).contains("couple") or str(fact_id).contains("marie_player"): result.append(_id_public("FAIT", str(fact_id)))
	result.sort()
	return result.slice(0, 5)

func _ids_actifs(registre: Dictionary) -> Array:
	var result: Array = []
	for id in registre.keys():
		if ETATS_REGISTRE_ACTIFS.has(str(registre[id].get("status", ""))): result.append(_id_public("ENGAGEMENT", str(id)))
	result.sort()
	return result

func _ids_traces_pertinentes(registre: Dictionary) -> Array:
	var result: Array = []
	for id in registre.keys():
		var trace: Dictionary = registre[id]
		if ETATS_TRACE_VISIBLES.has(str(trace.get("current_state", ""))): result.append(_id_public("TRACE", str(id)))
	result.sort()
	return result.slice(0, 12)

func _connaissances_bornees(registre: Dictionary) -> Array:
	var result: Array = []
	for id in registre.keys(): result.append(_id_public("FAIT", str(id)))
	result.sort()
	return result.slice(0, 12)

func _dernier_id_pour_personnage(id: String, etat: Season1State) -> String:
	var nom := _nom_canon(id)
	var ids: Array = []
	for trace_id in etat.traces.keys():
		var trace: Dictionary = etat.traces[trace_id]
		if trace.get("owner", "") == nom or trace.get("subjects", []).has(nom): ids.append(str(trace_id))
	ids.sort()
	return _id_public("EVENEMENT", ids.back()) if not ids.is_empty() else ""

func _dernier_id_couple(etat: Season1State) -> String:
	if etat.traces.has("j17_couple_definition_record_01"): return "EVENEMENT_COUPLE_DEFINITION_RECORD_01"
	return ""

func _derniers_evenements(etat: Season1State) -> Array:
	var ids: Array = []
	for record in etat.foreground_history:
		var function_name := str(record.get("function", ""))
		if function_name != "": ids.append(_id_public("EVENEMENT", function_name))
	if ids.is_empty():
		for id in etat.traces.keys(): ids.append(_id_public("EVENEMENT", str(id)))
	ids.sort()
	return ids.slice(maxi(0, ids.size() - 5), ids.size())

func _acte_pour_jour(jour: String) -> String:
	var numero := int(jour.trim_prefix("J"))
	if numero <= 4: return "ACTE_1_REOUVERTURE"
	if numero <= 8: return "ACTE_2_ATTIRANCES"
	if numero <= 12: return "ACTE_3_EXPLORATIONS"
	if numero <= 16: return "ACTE_4_LIMITES_ET_CONSEQUENCES"
	return "ACTE_5_CLARIFICATION"

func _nom_canon(id: String) -> String:
	return {"marie": "Marie", "sandra": "Sandra", "mathilde": "Mathilde", "pauline": "Pauline", "raphaelle": "Raphaëlle", "nico": "Nico"}.get(id, id)

func _id_public(prefixe: String, legacy_id: String) -> String:
	var morceaux := legacy_id.split("_", false)
	if not morceaux.is_empty() and morceaux[0].length() == 3 and morceaux[0].begins_with("j") and morceaux[0].substr(1).is_valid_int(): morceaux.remove_at(0)
	return prefixe + "_" + "_".join(morceaux).to_upper()
