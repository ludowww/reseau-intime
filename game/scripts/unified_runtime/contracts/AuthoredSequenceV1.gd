extends RefCounted

class_name R8CAuthoredSequenceV1

const SCHEMA_ID := "reseau_intime.authored_sequence"
const SCHEMA_VERSION := 1
const CANONICAL_STATUS := "CANON_APPROVED"

const ROOT_FIELDS := [
	"schema_id",
	"schema_version",
	"sequence_id",
	"authored_version",
	"season_id",
	"dramatic_movement_id",
	"narrative_function",
	"canonical_status",
	"author_provenance",
	"participants",
	"orchestration",
	"temporal_projection",
	"entry_beat_id",
	"beats",
	"resolutions",
	"media",
]

const DRAMATIC_MOVEMENTS := ["movement_i", "movement_ii", "movement_iii", "movement_iv", "movement_v"]
const NARRATIVE_FUNCTIONS := ["RELATION", "OPPORTUNITY", "ECHO", "RESPIRATION"]
const PLAYER_ROLES := ["PARTICIPANT", "OBSERVER", "ABSENT"]
const CONFLICT_POLICIES := ["CLOSE_SILENTLY", "MARK_MISSED_IF_PROPOSED", "DEFER"]
const DELAY_MODES := ["NONE", "DIEGETIC_MINUTES", "AFTER_EVENT"]

const AUTHOR_PROVENANCE_FIELDS := [
	"source_document_paths",
	"source_sequence_ids",
	"approval_ref",
	"authoring_tool_ref",
]
const PARTICIPANTS_FIELDS := [
	"present_character_ids",
	"concerned_absent_character_ids",
	"initial_audiences",
	"player_role",
]
const ORCHESTRATION_FIELDS := ["a6_entry", "a8_window", "a9_slot"]
const A6_ENTRY_FIELDS := ["scene_definition_id", "variant_id", "definition"]
const A8_WINDOW_FIELDS := ["window_id", "conflict_policy"]
const A9_SLOT_FIELDS := [
	"slot_role",
	"duration_minutes",
	"relative_order",
	"not_before_anchor",
	"not_after_anchor",
]
const TEMPORAL_PROJECTION_FIELDS := [
	"anchor_id",
	"offset_minutes",
	"relative_order",
	"delay",
	"resolved_window",
]
const DELAY_FIELDS := ["mode", "value"]
const RESOLVED_WINDOW_FIELDS := ["opens_at", "closes_at"]

const BEAT_TYPES := [
	"MESSAGE",
	"CHOICE",
	"TRANSITION",
	"PHYSICAL_BEAT",
	"MEDIA_REVEAL",
	"AFTERCARE",
	"RETURN",
]
const PROJECTION_TARGETS := ["MESSAGES", "PHYSICAL", "MEDIA", "GALLERY", "PHOTO_VIEWER", "NONE"]
const LOCAL_CONDITION_KINDS := [
	"CHOICE_CONSUMED",
	"CHECKPOINT_REACHED",
	"PROJECTION_ACKED",
	"RESOLUTION_SELECTED",
]
const NEXT_MODES := ["DIRECT", "BRANCH", "TERMINAL"]
const TRANSITION_MODES := ["CLOCK", "OFF_PHONE", "NIGHT", "NEW_DAY"]

const BEAT_FIELDS := [
	"beat_id",
	"type",
	"content",
	"participant_ids",
	"local_conditions",
	"projection_target",
	"checkpoint_before",
	"checkpoint_after",
	"next",
]
const LOCAL_CONDITION_FIELDS := ["kind", "ref_id", "expected"]
const NEXT_DIRECT_FIELDS := ["mode", "beat_id"]
const NEXT_BRANCH_FIELDS := ["mode", "branches"]
const NEXT_TERMINAL_FIELDS := ["mode", "beat_id"]

const MESSAGE_CONTENT_FIELDS := ["thread_id", "messages"]
const MESSAGE_FIELDS := ["message_id", "author_id", "text", "diegetic_at", "relative_order"]
const CHOICE_CONTENT_FIELDS := ["thread_id", "choices"]
const CHOICE_FIELDS := ["choice_id", "text", "resolution_id", "next_beat_id"]
const TRANSITION_CONTENT_FIELDS := [
	"transition_id",
	"mode",
	"from_anchor",
	"to_anchor",
	"continuation_label",
]
const PHYSICAL_BEAT_CONTENT_FIELDS := ["physical_beat_id", "content_ref", "withdrawal_choice_ids"]
const MEDIA_REVEAL_CONTENT_FIELDS := ["media_id", "reveal_context", "requires_ack"]
const AFTERCARE_CONTENT_FIELDS := ["aftercare_id", "content_ref", "obligation_id"]
const RETURN_CONTENT_FIELDS := ["return_id", "content_ref", "delay", "eligible_resolution_ids"]

const RESOLUTION_FIELDS := [
	"resolution_id",
	"choice_id",
	"a10_choice_id",
	"a10_resolution_id",
	"terminal_checkpoint_id",
	"event_refs",
	"fact_ids",
	"knowledge_ids",
	"trace_ids",
	"promise_effects",
	"obligation_effects",
	"consequence_ids",
	"media_effects",
	"convergence",
	"next_beat_id",
]
const EVENT_REF_FIELDS := ["event_type", "event_key", "reducer_id"]
const PROMISE_EFFECT_FIELDS := ["promise_id", "effect"]
const OBLIGATION_EFFECT_FIELDS := ["obligation_id", "effect"]
const MEDIA_EFFECT_FIELDS := ["media_id", "effect"]
const PROMISE_EFFECTS := ["CREATE", "PAY", "FAIL", "NONE"]
const OBLIGATION_EFFECTS := ["CREATE_DUE", "PAY", "FAIL", "NONE"]
const MEDIA_EFFECTS := ["CREATE_DIEGETIC", "GRANT_ACCESS", "REVOKE_ACCESS", "NONE"]
const CONVERGENCES := ["COMMON_EXIT", "POST_RESOLUTION_RETURN", "COMPLETE"]

const MEDIA_FIELDS := [
	"media_id",
	"visual_level",
	"analytic_level",
	"production_status",
	"diegesis",
	"audience_ids",
	"gallery_policy",
	"parent_media_id",
	"thumbnail_policy",
	"thumbnail_media_id",
	"removal_policy",
]
const VISUAL_LEVELS := ["V0", "V1", "V2", "V3", "V4", "V5"]
const ANALYTIC_LEVELS := ["NV0", "NV1", "NV2", "NV3", "NV4"]
const PRODUCTION_STATUSES := [
	"SPECIFIED_NOT_PRODUCED",
	"DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED",
	"PRODUCED",
	"VALIDATED",
]
const DIEGESIS_VALUES := ["DIEGETIC", "NON_DIEGETIC"]
const GALLERY_POLICIES := ["NEVER", "ON_ACCESS"]
const THUMBNAIL_POLICIES := ["SELF", "DERIVE_FIRST_ACCESSIBLE_CHILD", "REUSE_MEDIA"]
const REMOVAL_POLICIES := ["NEVER", "AUTHORED_RESOLUTION_ONLY"]


static func schema_contract() -> Dictionary:
	return {
		"schema_id": SCHEMA_ID,
		"schema_version": SCHEMA_VERSION,
		"canonical_status": CANONICAL_STATUS,
		"root_fields": ROOT_FIELDS.duplicate(),
		"beat_types": BEAT_TYPES.duplicate(),
		"projection_targets": PROJECTION_TARGETS.duplicate(),
	}
