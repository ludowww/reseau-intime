extends RefCounted

## Façade R8B de consultation. Elle ne possède aucun état et ne modifie jamais
## l'instance Season1State reçue.
class_name EtatNarratifLecture

const PERSONNAGES := ["marie", "sandra", "mathilde", "pauline", "raphaelle", "nico"]
const STATUTS_COUPLE := ["ENSEMBLE", "SEPARES", "EN_CLARIFICATION", "INDETERMINE"]
const ETATS_REGISTRE_ACTIFS := ["ACTIVE", "PROPOSED", "AMENDED"]
const ETATS_TRACE_VISIBLES := ["ACTIVE", "PRIVATE_ACTIVE"]

func obtenir_resume_relation_centrale(etat: Season1State) -> Dictionary:

	return _resume_couple(etat)

func obtenir_resume_relation(personnage_id: String, etat: Season1State) -> Dictionary:

	var id := personnage_id.to_lower()
	if not PERSONNAGES.has(id):
		return {"personnage_id": personnage_id, "etat_arc": "INCONNU", "statut_relation": "INCONNU", "confiance": "INDETERMINE", "desir": "INDETERMINE", "intimite": "INDETERMINE", "secret": "INDETERMINE", "dernier_evenement_majeur_id": "", "faits_utiles": [], "debug": {"regle": "personnage_non_supporte", "champs_lus": []}}
	var source := _etat_arc_source(id, etat)
	var connaissances := _faits_pour(id, etat)
	return {
		"personnage_id": id,
		"etat_arc": _etat_arc_vue(id, source.value),
		"statut_relation": _statut_relation(id, etat.couple_state if id == "marie" else source.value),
		"confiance": "INDETERMINE",
		"desir": "NONE" if id == "nico" else "INDETERMINE",
		"intimite": "INDETERMINE",
		"secret": _secret_pour(id, etat),
		"dernier_evenement_majeur_id": _dernier_id_pour_personnage(id, etat),
		"faits_utiles": connaissances.ids,
		"debug": {"regle": source.rule, "champs_lus": source.fields, "registre_lu": source.registry, "valeur_runtime_legacy": source.value, "provenance_connaissances": connaissances.provenance, "projection_evenement": "foreground_history append-only; aucune trace n'est renommee en evenement"},
	}

func obtenir_resume_etat_narratif(etat: Season1State) -> Dictionary:

	var relations: Array = []
	for id in PERSONNAGES:
		relations.append(obtenir_resume_relation(id, etat))
	return {
		"relation_centrale": obtenir_resume_relation_centrale(etat), "relations": relations,
		"acte_courant": _acte_pour_jour(etat.current_day), "jour_diegetique": etat.current_day,
		"promesses_actives_ids": _ids_actifs(etat.promises), "obligations_actives_ids": _ids_actifs(etat.obligations),
		"traces_pertinentes_ids": _ids_traces_pertinentes(etat.traces), "connaissances_majeures": _connaissances_bornees(etat.knowledge),
		"derniers_evenements_majeurs_ids": _derniers_evenements(etat),
		"debug": {"projection_acte": "projection de compatibilite sur le corpus historique J01-J21; ce jour n'est pas un acte", "champs_lus": ["current_day", "promises", "obligations", "traces", "knowledge", "foreground_history"], "projection_evenements": "foreground_history append-only uniquement; aucun fallback sur traces"},
	}

func _resume_couple(etat: Season1State) -> Dictionary:

	var statut := _statut_couple(etat.couple_state)
	var separe := statut == "SEPARES"
	return {"statut_couple": statut, "contrat_couple": "ABSENT" if separe else "INDETERMINE", "etat_divulgation": "INDETERMINE", "etat_foyer": "ETABLI" if etat.household_rhythm_confirmed else "NON_ETABLI", "relation_apres_separation": "INDETERMINE" if separe else "ABSENT", "dernier_evenement_majeur_id": "", "faits_utiles": _faits_couple(etat), "debug": {"regle": "couple_state vers taxonomie de vue bornee", "champs_lus": ["couple_state", "household_rhythm_confirmed", "j17_couple_outcome", "promises", "knowledge", "traces"], "valeur_runtime_legacy": etat.couple_state, "raison_contrat": "le runtime ne porte aucun champ contrat_couple", "projection_evenement": "INDETERMINE: foreground_history ne porte pas de relation de couple explicite"}}

func _statut_couple(value: String) -> String:

	match value:
		"SEPARATION": return "SEPARES"
		"BASELINE_SHARED_LIFE", "RECONQUEST_ACTIVE", "PROVISIONAL_AGREEMENT", "DOUBLE_LIFE_FRAGILE": return "ENSEMBLE"
		"FRACTURE", "RECONFIGURATION_NEGOTIATION", "RECONFIGURATION_NEGOTIATING", "STRAIN_VISIBLE": return "EN_CLARIFICATION"
		_: return "INDETERMINE"

func _etat_arc_source(id: String, etat: Season1State) -> Dictionary:

	match id:
		"marie": return {"value": "", "rule": "aucune trajectoire individuelle Marie fiable dans le runtime historique", "fields": [], "registry": []}
		"sandra": return {"value": etat.j18_sandra_outcome if etat.j18_sandra_outcome != "UNESTABLISHED" else etat.sandra_state, "rule": "resolution J18 prioritaire sinon etat de route Sandra", "fields": ["j18_sandra_outcome", "sandra_state"], "registry": ["traces", "knowledge"]}
		"mathilde": return {"value": etat.mathilde_state, "rule": "etat de route Mathilde", "fields": ["mathilde_state"], "registry": ["knowledge"]}
		"pauline": return {"value": etat.j19_pauline_outcome if etat.j19_pauline_outcome != "UNESTABLISHED" else etat.pauline_state, "rule": "resolution J19 prioritaire sinon etat de route Pauline", "fields": ["j19_pauline_outcome", "pauline_state"], "registry": ["knowledge"]}
		"raphaelle": return {"value": etat.j19_raphaelle_outcome if etat.j19_raphaelle_outcome != "UNESTABLISHED" else etat.raphaelle_state, "rule": "resolution J19 prioritaire sinon etat de route Raphaelle", "fields": ["j19_raphaelle_outcome", "raphaelle_state"], "registry": ["traces", "knowledge"]}
		_: return {"value": etat.j20_nico_position if etat.j20_nico_position != "UNESTABLISHED" else etat.nico_state, "rule": "resolution J20 prioritaire sinon etat de route Nico", "fields": ["j20_nico_position", "nico_state"], "registry": ["knowledge"]}

func _etat_arc_vue(id: String, value: String) -> String:

	if value in ["", "UNESTABLISHED"]: return "NON_ETABLI" if id != "marie" else "INDETERMINE"
	match id:
		"sandra": return {"PROTECTIVE_DISTANCE": "PROTECTIVE_WITHDRAWAL", "TRUST_BROKEN": "TRUST_BROKEN", "PRIVILEGED_CONFIDENCE": "PRIVILEGED_CONFIDENCE", "FRIENDSHIP_RESTORED": "FRIENDSHIP_RESTORED"}.get(value, "INDETERMINE")
		"mathilde": return {"TRUST_BROKEN": "TRUST_BROKEN", "DISTANCE": "TAKING_DISTANCE", "SECRET_SUSPENDED": "SECRET_SUSPENDED"}.get(value, "INDETERMINE")
		"pauline": return {"SURFACE_RESTORED": "SURFACE_RESTORED", "COMPARTMENT_PROTECTED": "COMPARTMENT_PROTECTED", "COMPARTMENT_CLOSED": "COMPARTMENT_CLOSED"}.get(value, "INDETERMINE")
		"raphaelle": return {"CREATIVE_CONFIDENCE": "CREATIVE_TRUST", "FUTURE_INVITATION": "FUTURE_INVITATION", "BOUNDARY_REINFORCED": "BOUNDARY_REINFORCED", "COLLEAGUE_ONLY": "COLLEAGUE_ONLY"}.get(value, "INDETERMINE")
		"nico": return {"ORDINARY_FRIEND": "ORDINARY_FRIEND", "GUARDRAIL": "GUARDRAIL", "LIMITED_CONFIDANT": "LIMITED_CONFIDANT", "DISTANCE": "TAKING_DISTANCE"}.get(value, "INDETERMINE")
		_: return "INDETERMINE"

func _statut_relation(id: String, value: String) -> String:

	if id == "marie": return "PAUSED" if etat_couple_en_pause(value) else "ACTIVE"
	if value in ["", "UNESTABLISHED"]: return "NON_ETABLI"
	if value in ["PROTECTIVE_DISTANCE", "TRUST_BROKEN", "DISTANCE", "COMPARTMENT_CLOSED", "BOUNDARY_REINFORCED", "COLLEAGUE_ONLY"]: return "PAUSED"
	return "ACTIVE"

func etat_couple_en_pause(value: String) -> bool:

	return value in ["SEPARATION", "FRACTURE", "RECONFIGURATION_NEGOTIATION", "RECONFIGURATION_NEGOTIATING", "STRAIN_VISIBLE"]

func _secret_pour(id: String, etat: Season1State) -> String:

	for fact in etat.knowledge.values():
		if str(fact.get("relation_scope", "")) == _relation_scope(id) and str(fact.get("secret_status", "")) == "PRESENT": return "PRESENT"
	return "INDETERMINE"

func _faits_pour(id: String, etat: Season1State) -> Dictionary:

	var result: Array = []
	var fallback_used := false
	var nom := _nom_canon(id)
	for fact_id in etat.knowledge.keys():
		var fact: Dictionary = etat.knowledge[fact_id]
		var knowers: Array = fact.get("current_knowers", []) if fact.has("current_knowers") else fact.get("initial_knowers", [])
		if not fact.has("current_knowers"): fallback_used = true
		if knowers.has(nom): result.append(_id_public("FAIT", str(fact_id)))
	result.sort()
	return {"ids": result.slice(0, 5), "provenance": "initial_knowers_fallback" if fallback_used else "current_knowers"}

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

	var nom := _nom_canon(id).to_lower()
	for index in range(etat.foreground_history.size() - 1, -1, -1):
		var record: Dictionary = etat.foreground_history[index]
		if str(record.get("character_id", "")).to_lower() == nom and str(record.get("function", "")) != "": return _id_public("EVENEMENT", str(record.function))
	return ""

func _derniers_evenements(etat: Season1State) -> Array:

	var ids: Array = []
	for record in etat.foreground_history:
		var function_name := str(record.get("function", ""))
		if function_name != "": ids.append(_id_public("EVENEMENT", function_name))
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

func _relation_scope(id: String) -> String:

	return "marie_player" if id == "marie" else "player_" + id

func _id_public(prefixe: String, legacy_id: String) -> String:

	return prefixe + "_" + legacy_id.to_utf8_buffer().hex_encode().to_upper()
