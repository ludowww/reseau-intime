extends Node

const MEDIA_RESOLVER := preload("res://scripts/ui/media/VisualMediaResolver.gd")
const IMAGE_MESSAGE_SCRIPT := preload("res://scripts/ui/messages/ImageMessage.gd")
const GALLERY_TILE_SCRIPT := preload("res://scripts/ui/gallery/GalleryTile.gd")
const PHOTO_VIEWER_SCRIPT := preload("res://scripts/ui/gallery/PhotoViewer.gd")
const PORTRAIT_THEME_SCRIPT := preload("res://scripts/ui/PortraitShellTheme.gd")
const TECHNICAL_REF := "pipeline_technical_texture"
const TECHNICAL_PATH := "res://tests/fixtures/visual_delivery_test_pattern.svg"
const PROTOTYPE_REF := "marie_tuesday_black_dress_mirror_01"

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	get_window().size = Vector2i(1280, 720)
	DataLoader.visual_content_by_id[TECHNICAL_REF] = {
		"id": TECHNICAL_REF,
		"type": "technical_fixture",
		"asset_path": TECHNICAL_PATH,
	}
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(get_window().size == Vector2i(1280, 720), "pipeline smoke must run at 1280x720")
	_validate_resolution_states()
	_validate_image_message()
	_validate_gallery_thumbnail()
	await _validate_photo_viewer()
	DataLoader.visual_content_by_id.erase(TECHNICAL_REF)
	_finish()

func _validate_resolution_states() -> void:
	var loaded := MEDIA_RESOLVER.resolve(TECHNICAL_REF)
	_expect(str(loaded.get("status", "")) == MEDIA_RESOLVER.STATUS_LOADED, "valid imported texture status mismatch")
	_expect(loaded.get("texture") is Texture2D, "valid imported texture must load a Texture2D through ResourceLoader")
	var cached := MEDIA_RESOLVER.resolve(TECHNICAL_REF)
	_expect(is_same(loaded.get("texture"), cached.get("texture")), "ResourceLoader cache must reuse the loaded Texture2D")
	var prototype := MEDIA_RESOLVER.resolve(PROTOTYPE_REF)
	_expect(str(prototype.get("status", "")) == MEDIA_RESOLVER.STATUS_DEVELOPMENT_PLACEHOLDER, "PROTOTYPE must resolve to DEVELOPMENT_PLACEHOLDER")
	_expect(prototype.get("texture") == null, "PROTOTYPE must never expose a loaded texture")
	_expect(str(MEDIA_RESOLVER.resolve("").get("status", "")) == MEDIA_RESOLVER.STATUS_MISSING_REFERENCE, "empty reference status mismatch")
	_expect(str(MEDIA_RESOLVER.resolve("unknown_visual_reference").get("status", "")) == MEDIA_RESOLVER.STATUS_INVALID_REFERENCE, "invalid reference status mismatch")
	_expect(str(MEDIA_RESOLVER.resolve("res://tests/fixtures/visual_delivery_test_pattern.svg").get("status", "")) == MEDIA_RESOLVER.STATUS_INVALID_REFERENCE, "direct resource path must remain invalid")
	_expect(str(MEDIA_RESOLVER.resolve("photo_marie_tender_tier1_placeholder").get("status", "")) == MEDIA_RESOLVER.STATUS_DEVELOPMENT_PLACEHOLDER, "development placeholder status mismatch")
	DataLoader.visual_content_by_id["pipeline_not_delivered"] = {"id": "pipeline_not_delivered", "asset_status": "NOT_DELIVERED", "asset_path": ""}
	_expect(str(MEDIA_RESOLVER.resolve("pipeline_not_delivered").get("status", "")) == MEDIA_RESOLVER.STATUS_NOT_DELIVERED, "not-delivered status mismatch")
	DataLoader.visual_content_by_id.erase("pipeline_not_delivered")
	DataLoader.visual_content_by_id["pipeline_load_failure"] = {"id": "pipeline_load_failure", "asset_path": "res://tests/fixtures/missing_pipeline_asset.svg"}
	_expect(str(MEDIA_RESOLVER.resolve("pipeline_load_failure").get("status", "")) == MEDIA_RESOLVER.STATUS_LOAD_FAILED, "missing resource must remain LOAD_FAILED without crashing")
	DataLoader.visual_content_by_id.erase("pipeline_load_failure")
	DataLoader.visual_content_by_id["pipeline_wrong_type"] = {"id": "pipeline_wrong_type", "asset_path": "res://scripts/ui/media/VisualMediaResolver.gd"}
	_expect(str(MEDIA_RESOLVER.resolve("pipeline_wrong_type").get("status", "")) == MEDIA_RESOLVER.STATUS_LOAD_FAILED, "wrong resource type must remain LOAD_FAILED without crashing")
	DataLoader.visual_content_by_id.erase("pipeline_wrong_type")

func _validate_image_message() -> void:
	var theme = PORTRAIT_THEME_SCRIPT.new()
	var request := {"message_id": "", "media_ref": ""}
	var delivered = IMAGE_MESSAGE_SCRIPT.new()
	delivered.image_requested.connect(func(message_id: String, media_ref: String):
		request["message_id"] = message_id
		request["media_ref"] = media_ref
	)
	delivered.configure("technical_message", TECHNICAL_REF, "", Color.WHITE, theme, "Placeholder interdit")
	_expect(delivered.has_loaded_texture(), "ImageMessage must load a valid imported texture")
	_expect(delivered.image_button.icon != null and delivered.image_button.text == "", "ImageMessage delivered presentation mismatch")
	delivered.image_button.pressed.emit()
	_expect(str(request.get("message_id", "")) == "technical_message" and str(request.get("media_ref", "")) == TECHNICAL_REF, "ImageMessage must open the requested content")
	delivered.free()
	var prototype = IMAGE_MESSAGE_SCRIPT.new()
	prototype.configure("prototype_message", PROTOTYPE_REF, "", Color.WHITE, theme, "Prototype V0.95")
	_expect(not prototype.has_loaded_texture(), "PROTOTYPE ImageMessage must not load a texture")
	_expect(prototype.displayed_media_status() == MEDIA_RESOLVER.STATUS_DEVELOPMENT_PLACEHOLDER, "PROTOTYPE ImageMessage status mismatch")
	_expect(prototype.image_button.text == MEDIA_RESOLVER.NOT_DELIVERED_LABEL, "PROTOTYPE ImageMessage must display Visuel non livré")
	prototype.free()
	var missing = IMAGE_MESSAGE_SCRIPT.new()
	missing.configure("missing_message", "", "", Color.WHITE, theme, "Placeholder interdit")
	_expect(not missing.has_loaded_texture(), "empty ImageMessage reference must not load")
	_expect(missing.image_button.text == MEDIA_RESOLVER.NOT_DELIVERED_LABEL, "empty ImageMessage fallback mismatch")
	missing.free()

func _validate_gallery_thumbnail() -> void:
	var tile = GALLERY_TILE_SCRIPT.new()
	tile.configure({
		"item_id": "technical_gallery_item",
		"state": "UNLOCKED",
		"is_new": false,
		"thumbnail_label": "Ne doit pas remplacer la texture",
		"thumbnail_ref": TECHNICAL_REF,
	}, Color.WHITE, PORTRAIT_THEME_SCRIPT.new(), 0)
	_expect(tile.has_loaded_thumbnail(), "GalleryTile must load valid thumbnail_ref")
	_expect(tile.icon != null and tile.text == "", "GalleryTile delivered presentation mismatch")
	tile.free()
	var prototype_tile = GALLERY_TILE_SCRIPT.new()
	prototype_tile.configure({
		"item_id": "prototype_gallery_item",
		"state": "UNLOCKED",
		"is_new": false,
		"thumbnail_label": "Prototype V0.95",
		"thumbnail_ref": PROTOTYPE_REF,
	}, Color.WHITE, PORTRAIT_THEME_SCRIPT.new(), 1)
	_expect(not prototype_tile.has_loaded_thumbnail(), "PROTOTYPE GalleryTile must not load a thumbnail")
	_expect(prototype_tile.displayed_media_status() == MEDIA_RESOLVER.STATUS_DEVELOPMENT_PLACEHOLDER, "PROTOTYPE GalleryTile status mismatch")
	_expect(prototype_tile.text == MEDIA_RESOLVER.NOT_DELIVERED_LABEL, "PROTOTYPE GalleryTile must display Visuel non livré")
	prototype_tile.free()

func _validate_photo_viewer() -> void:
	var viewer = PHOTO_VIEWER_SCRIPT.new()
	add_child(viewer)
	var sequence: Array[Dictionary] = [_presentation("technical_photo", TECHNICAL_REF, "Placeholder interdit")]
	_expect(viewer.configure(sequence, 0, PORTRAIT_THEME_SCRIPT.new()), "valid PhotoViewer presentation rejected")
	await get_tree().process_frame
	await get_tree().process_frame
	viewer._update_visual_size()
	await get_tree().process_frame
	_expect(viewer.has_loaded_texture(), "PhotoViewer must load valid visual_ref")
	_expect(viewer.visual_texture.texture != null and viewer.visual_texture.visible, "PhotoViewer texture must be visible")
	_expect(viewer.visual_texture.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED, "PhotoViewer must preserve texture aspect ratio")
	_expect(absf(viewer.displayed_texture_ratio() - 0.75) < 0.01, "PhotoViewer natural texture ratio mismatch")
	_expect(absf(viewer.visual_ratio() - 0.75) < 0.01, "PhotoViewer frame ratio mismatch at 1280x720")
	_expect(not viewer.has_horizontal_crop() and not viewer.has_vertical_crop(), "PhotoViewer must not crop at 1280x720")
	_expect(viewer.visual_label.text == "" and not viewer.visual_label.visible, "PhotoViewer must hide placeholder_label for a valid texture")
	var prototype_sequence: Array[Dictionary] = [_presentation("prototype_photo", PROTOTYPE_REF, "Prototype V0.95")]
	_expect(viewer.configure(prototype_sequence, 0, PORTRAIT_THEME_SCRIPT.new()), "PROTOTYPE PhotoViewer presentation rejected")
	await get_tree().process_frame
	_expect(not viewer.has_loaded_texture(), "PROTOTYPE PhotoViewer must not load a texture")
	_expect(viewer.displayed_media_status() == MEDIA_RESOLVER.STATUS_DEVELOPMENT_PLACEHOLDER, "PROTOTYPE PhotoViewer status mismatch")
	_expect(viewer.visual_label.text == MEDIA_RESOLVER.NOT_DELIVERED_LABEL and viewer.visual_label.visible, "PROTOTYPE PhotoViewer must display Visuel non livré")
	viewer.queue_free()

func _presentation(photo_id: String, visual_ref: String, fallback_label: String) -> Dictionary:
	return {
		"photo_id": photo_id,
		"visual_ref": visual_ref,
		"access_state": "UNLOCKED",
		"source_kind": "messages",
		"character_id": "technical_fixture",
		"display_name": "Fixture technique",
		"accent_color": Color.WHITE,
		"context_label": "Smoke",
		"timestamp": "00:00",
		"caption": "",
		"placeholder_label": fallback_label,
	}

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	if failures.is_empty():
		print("VISUAL DELIVERY PIPELINE smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("VISUAL DELIVERY PIPELINE smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
