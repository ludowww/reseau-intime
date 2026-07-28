import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class UIMsg04CInteractiveNotificationStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_dedicated_hosts_and_single_presentation_authority(self):
        screen = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        conversation = self.read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        for token in [
            "ListNotificationHost", "HeaderNotificationHost",
            "active_notification", "active_notification_generation", "pending_notification",
            "_present_notification", "_notification_presentation_blocked",
        ]:
            self.assertIn(token, screen + conversation)
        self.assertNotIn("var notification_snapshot", screen)

    def test_normal_notifications_never_shift_content(self):
        screen = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertNotIn("_set_content_banner_spacing", screen)
        self.assertNotIn("120.0 if banner_visible", screen)
        notification_block = screen.split("func _present_notification", 1)[1].split("\nfunc ", 1)[0]
        self.assertNotIn("offset_top", notification_block)

    def test_compact_banner_is_whole_surface_keyboard_accessible_and_real_time(self):
        banner = self.read("game/scripts/ui/messages/NotificationBanner.gd")
        for token in [
            "AUTO_DISMISS_SECONDS := 3.5", "Control.FOCUS_ALL", "MOUSE_FILTER_STOP",
            "InputEventMouseButton", 'event.is_action_pressed("ui_accept")',
            "ignore_time_scale = true", "presentation_generation", "dismissed",
        ]:
            self.assertIn(token, banner)
        present_block = self.read("game/scripts/ui/messages/MessagesScreen.gd").split("func _present_notification", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("true, remaining_seconds", present_block)
        self.assertNotIn("OpenNotification", present_block)
        self.assertNotIn("CloseNotification", present_block)
        self.assertNotIn("grab_focus", banner)
        self.assertNotIn("speed_multiplier", banner)

    def test_latest_wins_deferral_and_content_end_are_bounded(self):
        screen = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "_notification_key", "Time.get_ticks_msec", "notification_id", "message_id",
            "_defer_active_notification", "_resume_pending_notification",
            "latest pending wins", "TRANSITION_CARD_CONTENT_END", "_clear_notification_state",
        ]:
            self.assertIn(token, screen)
        for forbidden in ["Time.get_time", "Time.get_datetime", "Time.get_unix_time"]:
            self.assertNotIn(forbidden, screen)

    def test_interactive_notification_smoke_and_matrix_exist(self):
        required = [
            "game/tests/UI_MSG_04CInteractiveNotificationSmokeDriver.gd",
            "game/tests/UI_MSG_04CInteractiveNotificationSmokeTest.tscn",
            "tools/test_ui_msg_04c_interactive_notification.sh",
        ]
        for relative in required:
            self.assertTrue((ROOT / relative).exists(), relative)
        runner = self.read(required[-1])
        for resolution in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(resolution, runner)
        scene = self.read(required[1])
        self.assertIn("UI_MSG_04CInteractiveNotificationSmokeDriver.gd", scene)
        driver = self.read(required[0])
        self.assertIn('res://scenes/portrait/PortraitMain.tscn', driver)

    def test_scope_excludes_narrative_gallery_and_project_settings(self):
        forbidden_roots = (
            "game/data/conversations/", "game/data/runtime/season_1/",
            "game/scripts/runtime/season_1/", "docs/canon/", "game/scripts/ui/gallery/",
        )
        changed = _changed_paths()
        offenders = [path for path in changed if path.startswith(forbidden_roots) or path == "game/project.godot"]
        self.assertEqual([], offenders)


def _changed_paths():
    import subprocess
    tracked = subprocess.check_output(
        ["git", "diff", "--name-only", "bf2cc14befe23e5182805eb2a13d9ee88022fd75"],
        cwd=ROOT, text=True,
    ).splitlines()
    untracked = subprocess.check_output(
        ["git", "ls-files", "--others", "--exclude-standard"], cwd=ROOT, text=True,
    ).splitlines()
    return sorted(set(tracked + untracked))


if __name__ == "__main__":
    unittest.main()
