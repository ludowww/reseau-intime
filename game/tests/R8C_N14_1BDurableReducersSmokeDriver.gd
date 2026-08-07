extends Node

const EtatNarratifModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const Codec := preload("res://scripts/narrative_scene/A5NarrativeStateCodec.gd")
const Reducer := preload("res://scripts/narrative_state/ReducerResolutionSequence.gd")

var _checks := 0
var _failed := false


func _ready() -> void:
	var source := _new_state()
	_expect(not source.is_empty() and Codec.valider(source), "strict v2 source valid")
	var provenance := _provenance()

	var combined := _empty_payload()
	combined["facts"] = [
		{"event_key": "fact_relation_minimal", "scope": "RELATION", "personnage_id": "marie", "fact": {"fait_id": "fact_relation_minimal"}},
		{"event_key": "fact_central_complete", "scope": "RELATION_CENTRALE", "fact": {"fait_id": "fact_central_complete", "nature": "OBSERVATION", "recu_par": "player", "permission_future": true, "formulee_par": "marie"}},
		{"event_key": "fact_relation_partial", "scope": "RELATION", "personnage_id": "marie", "fact": {"fait_id": "fact_relation_partial", "nature": "DECISION"}},
	]
	combined["knowledge"] = [{"event_key": "knowledge_create", "effect": "ACQUIRE", "knowledge_id": "knowledge_one", "subject_id": "subject_one", "holder_ids": ["player", "marie"]}]
	combined["traces"] = [{"event_key": "trace_create", "effect": "CREATE", "trace_id": "trace_one", "creator_id": "marie", "audience_ids": [], "controller_ids": [], "accessible_to_ids": []}]
	combined["promises"] = [{"event_key": "promise_create", "effect": "CREATE", "promise_id": "promise_one", "author_id": "marie", "beneficiary_ids": ["player"], "content_ref": "promise_content_one"}]
	combined["obligations"] = [{"event_key": "obligation_create", "effect": "CREATE_DUE", "obligation_id": "obligation_one", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "FOLLOW_UP"}]
	combined["media_deliveries"] = [{"event_key": "media_create", "effect": "CREATE_DIEGETIC", "media_id": "media_one", "fictional_audience_ids": []}]

	var combined_result := Reducer.preparer(source, combined, provenance)
	_expect(combined_result["ok"] and combined_result["statut"] == "APPLIQUE", "payload combining all six categories accepted")
	_expect(Codec.valider(combined_result["candidat"]), "combined candidate codec valid")
	_expect(source == _new_state(), "source unchanged after combined preparation")
	var candidate: Dictionary = combined_result["candidat"]
	_expect(candidate["relations"]["marie"]["faits"][0]["fait_id"] == "fact_relation_minimal", "minimal relation fact created")
	_expect(candidate["relations"]["marie"]["faits"][1]["fait_id"] == "fact_relation_partial", "partial relation fact created in order")
	_expect(candidate["relation_centrale"]["faits"][0]["fait_id"] == "fact_central_complete", "complete central fact created")
	_expect(candidate["connaissances"]["knowledge_one"]["holder_ids"] == ["player", "marie"], "knowledge created with ordered holders")
	_expect(candidate["traces_narratives"]["trace_one"]["audience_ids"].is_empty(), "trace created with empty audience")
	_expect(candidate["promesses"]["promise_one"]["status"] == "ACTIVE", "promise created active")
	_expect(candidate["obligations"]["obligation_one"]["status"] == "DUE", "obligation created due")
	_expect(candidate["livraison_medias"]["media_one"]["fictional_audience_ids"].is_empty(), "media created with empty audience")

	var replay := Reducer.preparer(candidate, combined, provenance)
	_expect(replay["ok"] and replay["statut"] == "IDEMPOTENT", "identical combined replay idempotent")
	var divergent_knowledge_subject := _single("knowledge", [{"event_key": "knowledge_subject_divergent", "effect": "ACQUIRE", "knowledge_id": "knowledge_one", "subject_id": "subject_other", "holder_ids": ["player", "marie"]}])
	_expect_rejected(candidate, divergent_knowledge_subject, provenance, "knowledge subject divergence rejected")
	var divergent_knowledge_holders := _single("knowledge", [{"event_key": "knowledge_holders_divergent", "effect": "ACQUIRE", "knowledge_id": "knowledge_one", "subject_id": "subject_one", "holder_ids": ["player"]}])
	_expect_rejected(candidate, divergent_knowledge_holders, provenance, "knowledge holders divergence rejected")
	var unknown_knowledge_effect := _single("knowledge", [{"event_key": "knowledge_unknown_effect", "effect": "FORGET", "knowledge_id": "knowledge_other", "subject_id": "subject_other", "holder_ids": ["player"]}])
	_expect_rejected(candidate, unknown_knowledge_effect, provenance, "unknown knowledge effect rejected")
	var extra_knowledge_field := _single("knowledge", [{"event_key": "knowledge_extra_field", "effect": "ACQUIRE", "knowledge_id": "knowledge_other", "subject_id": "subject_other", "holder_ids": ["player"], "unknown": "value"}])
	_expect_rejected(candidate, extra_knowledge_field, provenance, "extra knowledge field rejected")

	var trace_grant := _single("traces", [{"event_key": "trace_grant", "effect": "GRANT_ACCESS", "trace_id": "trace_one", "accessible_to_ids": ["player", "sandra"]}])
	var trace_grant_result := Reducer.preparer(candidate, trace_grant, _provenance("2032-03-04T10:31:00+01:00"))
	_expect(trace_grant_result["ok"] and trace_grant_result["candidat"]["traces_narratives"]["trace_one"]["accessible_to_ids"] == ["player", "sandra"], "trace access granted in requested order")
	candidate = trace_grant_result["candidat"]
	var trace_revoke := _single("traces", [{"event_key": "trace_revoke", "effect": "REVOKE_ACCESS", "trace_id": "trace_one", "accessible_to_ids": ["player"]}])
	var trace_revoke_result := Reducer.preparer(candidate, trace_revoke, _provenance("2032-03-04T10:32:00+01:00"))
	_expect(trace_revoke_result["ok"] and trace_revoke_result["candidat"]["traces_narratives"]["trace_one"]["accessible_to_ids"] == ["sandra"], "trace access revoke limited to requested ids")
	candidate = trace_revoke_result["candidat"]
	var trace_withdraw := _single("traces", [{"event_key": "trace_withdraw", "effect": "WITHDRAW", "trace_id": "trace_one"}])
	var trace_withdraw_provenance := _provenance("2032-03-04T10:33:00+01:00")
	var trace_withdraw_result := Reducer.preparer(candidate, trace_withdraw, trace_withdraw_provenance)
	_expect(trace_withdraw_result["ok"] and trace_withdraw_result["candidat"]["traces_narratives"]["trace_one"]["status"] == "WITHDRAWN", "trace withdrawn")
	var withdrawn_trace_state: Dictionary = trace_withdraw_result["candidat"]
	var trace_withdraw_replay := Reducer.preparer(withdrawn_trace_state, trace_withdraw, trace_withdraw_provenance)
	_expect(trace_withdraw_replay["ok"] and trace_withdraw_replay["statut"] == "IDEMPOTENT", "trace withdrawal same moment idempotent")
	_expect_rejected(withdrawn_trace_state, trace_withdraw, _provenance("2032-03-04T10:34:00+01:00"), "trace withdrawal different moment rejected")
	_expect_rejected(withdrawn_trace_state, trace_grant, _provenance("2032-03-04T10:35:00+01:00"), "trace access after withdrawal rejected")

	var promise_pay := _single("promises", [{"event_key": "promise_pay", "effect": "PAY", "promise_id": "promise_one"}])
	var promise_paid := Reducer.preparer(candidate, promise_pay, _provenance("2032-03-04T10:36:00+01:00"))
	_expect(promise_paid["ok"] and promise_paid["candidat"]["promesses"]["promise_one"]["status"] == "PAID", "promise created then paid")
	_expect_rejected(promise_paid["candidat"], promise_pay, _provenance("2032-03-04T10:36:01+01:00"), "promise terminal replay different moment rejected")
	var promise_change_terminal := _single("promises", [{"event_key": "promise_change_terminal", "effect": "FAIL", "promise_id": "promise_one"}])
	_expect_rejected(promise_paid["candidat"], promise_change_terminal, _provenance("2032-03-04T10:36:00+01:00"), "promise terminal status change rejected")
	var promise_divergent_create := _single("promises", [{"event_key": "promise_divergent_create", "effect": "CREATE", "promise_id": "promise_one", "author_id": "marie", "beneficiary_ids": ["player"], "content_ref": "different_content"}])
	_expect_rejected(candidate, promise_divergent_create, provenance, "promise divergent creation rejected")
	var promise_duplicate_beneficiary := _single("promises", [{"event_key": "promise_duplicate_beneficiary", "effect": "CREATE", "promise_id": "promise_duplicate_beneficiary", "author_id": "marie", "beneficiary_ids": ["player", "player"], "content_ref": "content"}])
	_expect_rejected(candidate, promise_duplicate_beneficiary, provenance, "promise duplicate beneficiaries rejected")
	var promise_extra_field := _single("promises", [{"event_key": "promise_extra_field", "effect": "PAY", "promise_id": "promise_one", "unknown": "value"}])
	_expect_rejected(candidate, promise_extra_field, provenance, "promise extra field rejected")
	var promise_two_create := _single("promises", [{"event_key": "promise_two_create", "effect": "CREATE", "promise_id": "promise_two", "author_id": "sandra", "beneficiary_ids": ["player"], "content_ref": "promise_content_two"}])
	var promise_two_active: Dictionary = Reducer.preparer(candidate, promise_two_create, _provenance("2032-03-04T10:37:00+01:00"))["candidat"]
	var promise_fail := _single("promises", [{"event_key": "promise_fail", "effect": "FAIL", "promise_id": "promise_two"}])
	var promise_failed := Reducer.preparer(promise_two_active, promise_fail, _provenance("2032-03-04T10:38:00+01:00"))
	_expect(promise_failed["ok"] and promise_failed["candidat"]["promesses"]["promise_two"]["status"] == "FAILED", "promise created then failed separately")

	var obligation_pay := _single("obligations", [{"event_key": "obligation_pay", "effect": "PAY", "obligation_id": "obligation_one"}])
	var obligation_pay_provenance := _provenance("2032-03-04T10:39:00+01:00")
	var obligation_paid := Reducer.preparer(candidate, obligation_pay, obligation_pay_provenance)
	_expect(obligation_paid["ok"] and obligation_paid["candidat"]["obligations"]["obligation_one"]["status"] == "PAID", "obligation created then paid")
	var obligation_pay_replay := Reducer.preparer(obligation_paid["candidat"], obligation_pay, obligation_pay_provenance)
	_expect(obligation_pay_replay["ok"] and obligation_pay_replay["statut"] == "IDEMPOTENT", "CREATE_DUE then PAY identical replay remains idempotent")
	_expect_rejected(obligation_paid["candidat"], obligation_pay, _provenance("2032-03-04T10:39:01+01:00"), "obligation terminal replay different moment rejected")
	var obligation_change_terminal := _single("obligations", [{"event_key": "obligation_change_terminal", "effect": "FAIL", "obligation_id": "obligation_one"}])
	_expect_rejected(obligation_paid["candidat"], obligation_change_terminal, _provenance("2032-03-04T10:39:00+01:00"), "obligation terminal status change rejected")
	var obligation_divergent_create := _single("obligations", [{"event_key": "obligation_divergent_create", "effect": "CREATE_DUE", "obligation_id": "obligation_one", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "DIFFERENT_KIND"}])
	_expect_rejected(candidate, obligation_divergent_create, provenance, "obligation divergent creation rejected")
	var obligation_extra_field := _single("obligations", [{"event_key": "obligation_extra_field", "effect": "PAY", "obligation_id": "obligation_one", "unknown": "value"}])
	_expect_rejected(candidate, obligation_extra_field, provenance, "obligation extra field rejected")
	var obligation_two_create := _single("obligations", [{"event_key": "obligation_two_create", "effect": "CREATE_DUE", "obligation_id": "obligation_two", "debtor_id": "player", "beneficiary_ids": ["sandra"], "kind": "FOLLOW_UP"}])
	var obligation_two_due: Dictionary = Reducer.preparer(candidate, obligation_two_create, _provenance("2032-03-04T10:40:00+01:00"))["candidat"]
	var obligation_fail := _single("obligations", [{"event_key": "obligation_fail", "effect": "FAIL", "obligation_id": "obligation_two"}])
	var obligation_fail_provenance := _provenance("2032-03-04T10:41:00+01:00")
	var obligation_failed := Reducer.preparer(obligation_two_due, obligation_fail, obligation_fail_provenance)
	_expect(obligation_failed["ok"] and obligation_failed["candidat"]["obligations"]["obligation_two"]["status"] == "FAILED", "obligation created then failed separately")
	var obligation_fail_replay := Reducer.preparer(obligation_failed["candidat"], obligation_fail, obligation_fail_provenance)
	_expect(obligation_fail_replay["ok"] and obligation_fail_replay["statut"] == "IDEMPOTENT", "CREATE_DUE then FAIL identical replay remains idempotent")

	var same_moment := "2032-03-04T10:41:15+01:00"
	var same_moment_due_provenance := _provenance(same_moment)
	same_moment_due_provenance["event_id"] = "same_moment_due_create_event"
	var same_moment_due := _single("obligations", [{"event_key": "same_moment_due_create", "effect": "CREATE_DUE", "obligation_id": "obligation_same_moment_paid", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "FOLLOW_UP"}])
	var same_moment_due_state := Reducer.preparer(source, same_moment_due, same_moment_due_provenance)
	var same_moment_pay_provenance := _provenance(same_moment)
	same_moment_pay_provenance["event_id"] = "same_moment_pay_event"
	var same_moment_pay := _single("obligations", [{"event_key": "same_moment_pay", "effect": "PAY", "obligation_id": "obligation_same_moment_paid"}])
	var same_moment_paid := Reducer.preparer(same_moment_due_state["candidat"], same_moment_pay, same_moment_pay_provenance)
	_expect(same_moment_paid["ok"] and same_moment_paid["statut"] == "APPLIQUE", "CREATE_DUE then PAY at same moment applies")
	var same_moment_pay_replay := Reducer.preparer(same_moment_paid["candidat"], same_moment_pay, same_moment_pay_provenance)
	_expect(same_moment_pay_replay["ok"] and same_moment_pay_replay["statut"] == "IDEMPOTENT", "CREATE_DUE then PAY at same moment replay idempotent")
	var same_moment_fail_due_provenance := _provenance(same_moment)
	same_moment_fail_due_provenance["event_id"] = "same_moment_fail_due_create_event"
	var same_moment_fail_due := _single("obligations", [{"event_key": "same_moment_fail_due_create", "effect": "CREATE_DUE", "obligation_id": "obligation_same_moment_failed", "debtor_id": "player", "beneficiary_ids": ["sandra"], "kind": "FOLLOW_UP"}])
	var same_moment_fail_due_state := Reducer.preparer(source, same_moment_fail_due, same_moment_fail_due_provenance)
	var same_moment_fail_provenance := _provenance(same_moment)
	same_moment_fail_provenance["event_id"] = "same_moment_fail_event"
	var same_moment_fail := _single("obligations", [{"event_key": "same_moment_fail", "effect": "FAIL", "obligation_id": "obligation_same_moment_failed"}])
	var same_moment_failed := Reducer.preparer(same_moment_fail_due_state["candidat"], same_moment_fail, same_moment_fail_provenance)
	_expect(same_moment_failed["ok"] and same_moment_failed["statut"] == "APPLIQUE", "CREATE_DUE then FAIL at same moment applies")
	var same_moment_fail_replay := Reducer.preparer(same_moment_failed["candidat"], same_moment_fail, same_moment_fail_provenance)
	_expect(same_moment_fail_replay["ok"] and same_moment_fail_replay["statut"] == "IDEMPOTENT", "CREATE_DUE then FAIL at same moment replay idempotent")

	var create_paid_provenance := _provenance("2032-03-04T10:41:30+01:00")
	var obligation_create_paid := _single("obligations", [{"event_key": "obligation_create_paid", "effect": "CREATE_PAID", "obligation_id": "obligation_paid_at_creation", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "AFTERCARE"}])
	var obligation_created_paid := Reducer.preparer(source, obligation_create_paid, create_paid_provenance)
	var paid_record: Dictionary = obligation_created_paid["candidat"]["obligations"]["obligation_paid_at_creation"]
	_expect(obligation_created_paid["ok"] and obligation_created_paid["statut"] == "APPLIQUE", "CREATE_PAID creates obligation from fresh state")
	_expect(paid_record["status"] == "PAID" and paid_record["resolved_at"] == create_paid_provenance["moment_diegetique"], "CREATE_PAID record is terminal at provenance moment")
	_expect(paid_record["debtor_id"] == "player" and paid_record["beneficiary_ids"] == ["marie"] and paid_record["kind"] == "AFTERCARE" and paid_record["provenance"] == create_paid_provenance, "CREATE_PAID record preserves metadata and provenance")
	var create_paid_replay := Reducer.preparer(obligation_created_paid["candidat"], obligation_create_paid, create_paid_provenance)
	_expect(create_paid_replay["ok"] and create_paid_replay["statut"] == "IDEMPOTENT", "CREATE_PAID identical replay idempotent")
	_expect_rejected(obligation_created_paid["candidat"], obligation_create_paid, _provenance("2032-03-04T10:41:31+01:00"), "CREATE_PAID replay different moment rejected")
	var paid_to_failed := _single("obligations", [{"event_key": "obligation_paid_to_failed", "effect": "CREATE_FAILED", "obligation_id": "obligation_paid_at_creation", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "AFTERCARE"}])
	_expect_rejected(obligation_created_paid["candidat"], paid_to_failed, create_paid_provenance, "CREATE_PAID to CREATE_FAILED status change rejected")
	var divergent_paid_debtor := _single("obligations", [{"event_key": "obligation_paid_other_debtor", "effect": "CREATE_PAID", "obligation_id": "obligation_paid_at_creation", "debtor_id": "marie", "beneficiary_ids": ["marie"], "kind": "AFTERCARE"}])
	_expect_rejected(obligation_created_paid["candidat"], divergent_paid_debtor, create_paid_provenance, "CREATE_PAID divergent debtor rejected")
	var divergent_paid_beneficiaries := _single("obligations", [{"event_key": "obligation_paid_other_beneficiaries", "effect": "CREATE_PAID", "obligation_id": "obligation_paid_at_creation", "debtor_id": "player", "beneficiary_ids": ["sandra"], "kind": "AFTERCARE"}])
	_expect_rejected(obligation_created_paid["candidat"], divergent_paid_beneficiaries, create_paid_provenance, "CREATE_PAID divergent beneficiaries rejected")
	var divergent_paid_kind := _single("obligations", [{"event_key": "obligation_paid_other_kind", "effect": "CREATE_PAID", "obligation_id": "obligation_paid_at_creation", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "FOLLOW_UP"}])
	_expect_rejected(obligation_created_paid["candidat"], divergent_paid_kind, create_paid_provenance, "CREATE_PAID divergent kind rejected")
	var create_failed_provenance := _provenance("2032-03-04T10:41:45+01:00")
	var obligation_create_failed := _single("obligations", [{"event_key": "obligation_create_failed", "effect": "CREATE_FAILED", "obligation_id": "obligation_failed_at_creation", "debtor_id": "player", "beneficiary_ids": ["sandra"], "kind": "AFTERCARE"}])
	var obligation_created_failed := Reducer.preparer(source, obligation_create_failed, create_failed_provenance)
	var failed_record: Dictionary = obligation_created_failed["candidat"]["obligations"]["obligation_failed_at_creation"]
	_expect(obligation_created_failed["ok"] and obligation_created_failed["statut"] == "APPLIQUE", "CREATE_FAILED creates obligation from fresh state")
	_expect(failed_record["status"] == "FAILED" and failed_record["resolved_at"] == create_failed_provenance["moment_diegetique"], "CREATE_FAILED record is terminal at provenance moment")
	_expect(failed_record["debtor_id"] == "player" and failed_record["beneficiary_ids"] == ["sandra"] and failed_record["kind"] == "AFTERCARE" and failed_record["provenance"] == create_failed_provenance, "CREATE_FAILED record preserves metadata and provenance")
	var create_failed_replay := Reducer.preparer(obligation_created_failed["candidat"], obligation_create_failed, create_failed_provenance)
	_expect(create_failed_replay["ok"] and create_failed_replay["statut"] == "IDEMPOTENT", "CREATE_FAILED identical replay idempotent")
	var media_grant_hidden := _single("media_deliveries", [{"event_key": "media_grant_hidden", "effect": "GRANT_ACCESS", "media_id": "media_one", "diegetic_status": "CREATED", "fictional_audience_ids": [], "gallery_status": "HIDDEN"}])
	var media_hidden := Reducer.preparer(candidate, media_grant_hidden, _provenance("2032-03-04T10:42:00+01:00"))
	_expect(media_hidden["ok"] and media_hidden["candidat"]["livraison_medias"]["media_one"]["access_status"] == "ACCESSIBLE", "media access hidden granted")
	var media_hidden_replay := Reducer.preparer(media_hidden["candidat"], media_grant_hidden, _provenance("2032-03-04T10:42:00+01:00"))
	_expect(media_hidden_replay["ok"] and media_hidden_replay["statut"] == "IDEMPOTENT", "media grant identical replay idempotent")
	var media_grant_available := _single("media_deliveries", [{"event_key": "media_grant_available", "effect": "GRANT_ACCESS", "media_id": "media_one", "diegetic_status": "CREATED", "fictional_audience_ids": [], "gallery_status": "AVAILABLE"}])
	var media_available := Reducer.preparer(media_hidden["candidat"], media_grant_available, _provenance("2032-03-04T10:43:00+01:00"))
	_expect(media_available["ok"] and media_available["candidat"]["livraison_medias"]["media_one"]["gallery_status"] == "AVAILABLE", "media gallery available granted")
	_expect_rejected(media_available["candidat"], media_grant_hidden, _provenance("2032-03-04T10:44:00+01:00"), "media gallery AVAILABLE to HIDDEN rejected")
	var media_revoke := _single("media_deliveries", [{"event_key": "media_revoke", "effect": "REVOKE_ACCESS", "media_id": "media_one"}])
	var media_revoked := Reducer.preparer(media_available["candidat"], media_revoke, _provenance("2032-03-04T10:45:00+01:00"))
	_expect(media_revoked["ok"] and media_revoked["candidat"]["livraison_medias"]["media_one"]["access_status"] == "REVOKED" and media_revoked["candidat"]["livraison_medias"]["media_one"]["withdrawal_status"] == "ACTIVE", "media access revoked while active")
	var media_revoke_replay := Reducer.preparer(media_revoked["candidat"], media_revoke, _provenance("2032-03-04T10:45:00+01:00"))
	_expect(media_revoke_replay["ok"] and media_revoke_replay["statut"] == "IDEMPOTENT", "media revoke replay idempotent")
	var media_withdraw := _single("media_deliveries", [{"event_key": "media_withdraw", "effect": "WITHDRAW", "media_id": "media_one"}])
	var media_withdrawn := Reducer.preparer(media_revoked["candidat"], media_withdraw, _provenance("2032-03-04T10:46:00+01:00"))
	_expect(media_withdrawn["ok"] and media_withdrawn["candidat"]["livraison_medias"]["media_one"]["withdrawal_status"] == "WITHDRAWN", "media withdrawn")
	var media_withdraw_replay := Reducer.preparer(media_withdrawn["candidat"], media_withdraw, _provenance("2032-03-04T10:47:00+01:00"))
	_expect(media_withdraw_replay["ok"] and media_withdraw_replay["statut"] == "IDEMPOTENT", "media double withdrawal canonical idempotent")
	var absent_grant := _single("media_deliveries", [{"event_key": "media_absent_grant", "effect": "GRANT_ACCESS", "media_id": "media_absent_grant", "diegetic_status": "NOT_APPLICABLE", "fictional_audience_ids": [], "gallery_status": "AVAILABLE"}])
	var absent_granted := Reducer.preparer(candidate, absent_grant, _provenance("2032-03-04T10:48:00+01:00"))
	_expect(absent_granted["ok"] and absent_granted["candidat"]["livraison_medias"]["media_absent_grant"]["gallery_status"] == "AVAILABLE", "media absent grant creates exact requested state")

	var v1 := source.duplicate(true)
	v1.erase("format_version")
	_expect(Codec.valider(v1), "v1 source remains codec migrable")
	_expect_rejected(v1, combined, provenance, "v1 source rejected by reducer orchestrator")
	_expect_rejected(source, _empty_payload(), provenance, "empty payload rejected")
	var missing_category := combined.duplicate(true)
	missing_category.erase("knowledge")
	_expect_rejected(source, missing_category, provenance, "missing payload category rejected")
	var extra_category := combined.duplicate(true)
	extra_category["unknown"] = []
	_expect_rejected(source, extra_category, provenance, "extra payload category rejected")
	var wrong_type := combined.duplicate(true)
	wrong_type["traces"] = {}
	_expect_rejected(source, wrong_type, provenance, "wrong payload category type rejected")
	var incomplete_provenance := provenance.duplicate(true)
	incomplete_provenance.erase("source_sequence_id")
	_expect_rejected(source, combined, incomplete_provenance, "incomplete provenance rejected")
	var extra_provenance := provenance.duplicate(true)
	extra_provenance["unknown"] = "value"
	_expect_rejected(source, combined, extra_provenance, "extra provenance rejected")
	var bad_semver := provenance.duplicate(true)
	bad_semver["source_authored_version"] = "01.0.0"
	_expect_rejected(source, combined, bad_semver, "invalid semver rejected")
	var bad_moment := provenance.duplicate(true)
	bad_moment["moment_diegetique"] = "2032-03-04"
	_expect_rejected(source, combined, bad_moment, "invalid normalized moment rejected")
	var empty_event_key := _single("knowledge", [{"event_key": "", "effect": "ACQUIRE", "knowledge_id": "knowledge_bad", "subject_id": "subject", "holder_ids": ["player"]}])
	_expect_rejected(source, empty_event_key, provenance, "empty event_key rejected")
	var duplicate_event_key := _empty_payload()
	duplicate_event_key["knowledge"] = [{"event_key": "duplicate_key", "effect": "ACQUIRE", "knowledge_id": "knowledge_dup", "subject_id": "subject", "holder_ids": ["player"]}]
	duplicate_event_key["traces"] = [{"event_key": "duplicate_key", "effect": "CREATE", "trace_id": "trace_dup", "creator_id": "marie", "audience_ids": [], "controller_ids": [], "accessible_to_ids": []}]
	_expect_rejected(source, duplicate_event_key, provenance, "duplicate event_key across categories rejected")
	var duplicate_business := _single("promises", [
		{"event_key": "promise_dup_create", "effect": "CREATE", "promise_id": "promise_dup", "author_id": "marie", "beneficiary_ids": ["player"], "content_ref": "one"},
		{"event_key": "promise_dup_pay", "effect": "PAY", "promise_id": "promise_dup"},
	])
	_expect_rejected(source, duplicate_business, provenance, "duplicate business identifier rejected")
	var duplicate_obligation_business := _single("obligations", [
		{"event_key": "obligation_duplicate_create", "effect": "CREATE_DUE", "obligation_id": "obligation_duplicate", "debtor_id": "player", "beneficiary_ids": ["marie"], "kind": "FOLLOW_UP"},
		{"event_key": "obligation_duplicate_pay", "effect": "PAY", "obligation_id": "obligation_duplicate"},
	])
	_expect_rejected(source, duplicate_obligation_business, provenance, "CREATE_DUE and PAY same obligation rejected as duplicate business identifier")
	var bad_fact := _single("facts", [{"event_key": "bad_fact", "scope": "RELATION_CENTRALE", "fact": {"fait_id": "bad_fact", "unknown": "value"}}])
	_expect_rejected(source, bad_fact, provenance, "incoherent fact rejected")
	var absent_trace := _single("traces", [{"event_key": "absent_trace", "effect": "WITHDRAW", "trace_id": "absent_trace"}])
	_expect_rejected(source, absent_trace, provenance, "absent trace rejected")
	var promise_before_create := _single("promises", [{"event_key": "promise_before_create", "effect": "PAY", "promise_id": "absent_promise"}])
	_expect_rejected(source, promise_before_create, provenance, "promise paid before creation rejected")
	var obligation_before_due := _single("obligations", [{"event_key": "obligation_before_due", "effect": "PAY", "obligation_id": "absent_obligation"}])
	_expect_rejected(source, obligation_before_due, provenance, "obligation paid before due rejected")
	var obligation_fail_before_due := _single("obligations", [{"event_key": "obligation_fail_before_due", "effect": "FAIL", "obligation_id": "absent_obligation"}])
	_expect_rejected(source, obligation_fail_before_due, provenance, "obligation failed before due rejected")
	var absent_media := _single("media_deliveries", [{"event_key": "absent_media", "effect": "WITHDRAW", "media_id": "absent_media"}])
	_expect_rejected(source, absent_media, provenance, "absent media rejected")
	var unknown_gallery := _single("media_deliveries", [{"event_key": "unknown_gallery", "effect": "GRANT_ACCESS", "media_id": "unknown_gallery", "diegetic_status": "CREATED", "fictional_audience_ids": [], "gallery_status": "UNKNOWN"}])
	_expect_rejected(source, unknown_gallery, provenance, "unknown gallery status rejected")
	var divergent_audience := _single("media_deliveries", [{"event_key": "divergent_audience", "effect": "GRANT_ACCESS", "media_id": "media_one", "diegetic_status": "CREATED", "fictional_audience_ids": ["player"], "gallery_status": "HIDDEN"}])
	_expect_rejected(candidate, divergent_audience, provenance, "divergent media audience rejected")
	var divergent_diegesis := _single("media_deliveries", [{"event_key": "divergent_diegesis", "effect": "GRANT_ACCESS", "media_id": "media_one", "diegetic_status": "NOT_APPLICABLE", "fictional_audience_ids": [], "gallery_status": "HIDDEN"}])
	_expect_rejected(candidate, divergent_diegesis, provenance, "divergent media diegesis rejected")
	var last_reducer_failure := _empty_payload()
	last_reducer_failure["facts"] = [{"event_key": "fact_before_last_failure", "scope": "RELATION_CENTRALE", "fact": {"fait_id": "fact_before_last_failure"}}]
	last_reducer_failure["media_deliveries"] = [{"event_key": "last_media_failure", "effect": "WITHDRAW", "media_id": "absent_last_media"}]
	_expect_rejected(source, last_reducer_failure, provenance, "last reducer failure leaves source intact")

	if _failed:
		push_error("R8C_N14_1B_DURABLE_REDUCERS: KO (%d controls)" % _checks)
		get_tree().quit(1)
		return
	print("R8C_N14_1B_DURABLE_REDUCERS: OK (%d controls)" % _checks)
	get_tree().quit(0)


func _new_state() -> Dictionary:
	var state := EtatNarratifModel.creer_synthetique({
		"statut_couple": "SEPARES",
		"relation_apres_separation": "BONS_TERMES",
		"faits": [],
	})
	return {} if state == null else state.obtenir_snapshot()


func _empty_payload() -> Dictionary:
	return {"facts": [], "knowledge": [], "traces": [], "promises": [], "obligations": [], "media_deliveries": []}


func _single(category: String, effects: Array) -> Dictionary:
	var payload := _empty_payload()
	payload[category] = effects
	return payload


func _provenance(moment := "2032-03-04T10:30:00+01:00") -> Dictionary:
	return {
		"event_id": "synthetic_n14_1b_event",
		"source_scene_id": "synthetic_scene",
		"source_scene_instance_id": "synthetic_instance",
		"source_a10_choice_id": "synthetic_choice",
		"source_a10_resolution_id": "synthetic_a10_resolution",
		"source_sequence_id": "synthetic_sequence",
		"source_authored_version": "1.0.0",
		"source_resolution_id": "synthetic_resolution",
		"moment_diegetique": moment,
	}


func _expect_rejected(source: Dictionary, payload: Dictionary, provenance: Dictionary, label: String) -> void:
	var before := source.duplicate(true)
	var result := Reducer.preparer(source, payload, provenance)
	_expect(not result["ok"] and result["statut"] == "REJETE", label)
	_expect(result["candidat"].is_empty(), "%s returns empty candidate" % label)
	_expect(source == before, "%s preserves source" % label)


func _expect(condition: bool, label: String) -> void:
	_checks += 1
	if not condition:
		_failed = true
		push_error("R8C_N14_1B_DURABLE_REDUCERS: failed control: %s" % label)
