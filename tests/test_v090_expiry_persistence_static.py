import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PHONE = ROOT / "game/scripts/ui/PhonePrototypeV090.gd"


class V090ExpiryPersistenceStaticTests(unittest.TestCase):
    def test_sandra_expiry_is_reasserted_after_phase_advance(self):
        source = PHONE.read_text(encoding="utf-8")
        start = source.index("func _advance_optional_phase")
        end = source.index("func _on_conversation_completed")
        block = source[start:end]

        self.assertIn("await _advance_after_phase(day_value, phase_id)", block)
        after_advance = block.split("await _advance_after_phase(day_value, phase_id)", 1)[1]
        self.assertIn(
            "TimelineState.expire_conversation(day_value, SANDRA_CONVERSATION_ID)",
            after_advance,
        )
        self.assertIn("_clear_pending_for_episode(day_value, SANDRA_CONVERSATION_ID)", after_advance)
        self.assertIn('== "EXPIRED"', after_advance)


if __name__ == "__main__":
    unittest.main()
