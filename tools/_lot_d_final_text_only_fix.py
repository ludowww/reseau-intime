#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def write(rel: str, text: str) -> None:
    (ROOT / rel).write_text(text.rstrip() + "\n", encoding="utf-8")


def replace_once(rel: str, old: str, new: str) -> None:
    text = read(rel)
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{rel}: expected one match, found {count}: {old[:100]!r}")
    write(rel, text.replace(old, new, 1))


# Remove duplicate train line introduced by polish.
replace_once(
    "docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md",
    """**Sandra**

> Train attrapé.

**Sandra**

> J’ai eu le train.

**Sandra**

> On ne va pas en faire un événement.""",
    """**Sandra**

> Train attrapé.

**Sandra**

> On ne va pas en faire un événement.""",
)

# J11 must start from a real separation, not two rooms in one home.
rel = "docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel,
"communication_mode: SEPARATE_ROOMS_PING → OFF_PHONE → AFTERGLOW_REMOTE",
"communication_mode: REMOTE_ASYNC → OFF_PHONE → AFTERGLOW_REMOTE")
replace_once(rel,
"""Mathilde est au foyer.

Marie est retenue à La Verrière ou chez Pauline pour une raison indépendante de la route.

Elle a donné une heure de retour réaliste.

Player et Mathilde sont dans des pièces séparées.

Le chat est utilisé parce que Mathilde préfère formuler avant de revenir dans le salon.""",
"""Mathilde revient de sa sortie avec Inès et se trouve encore dehors, devant l’immeuble.

Marie est retenue à La Verrière ou chez Pauline pour une raison indépendante de la route.

Elle a donné une heure de retour réaliste.

Player est au foyer.

Le chat est utilisé avant que Mathilde entre dans l’appartement.""")
replace_once(rel,
"""**21:06 — Mathilde**

> Je vais revenir dans le salon.

**21:06 — Mathilde**

> Et je porte la première tenue.""",
"""**21:06 — Mathilde**

> Je suis en bas.

**21:06 — Mathilde**

> Je remonte dans deux minutes.

**21:06 — Mathilde**

> Et je porte la première tenue.""")
replace_once(rel,
"""Mathilde peut repartir à tout moment
```""",
"""Mathilde peut repartir à tout moment
Mathilde ressort quelques minutes avant le retour textuel
```""")
replace_once(rel,
"""Mathilde arrête la scène la première
```""",
"""Mathilde arrête la scène la première
Mathilde quitte ensuite le logement quelques minutes avant le retour textuel
```""")
replace_once(rel,
"""Mathilde peut arrêter et retourne dans sa chambre avant le retour de Marie
```""",
"""Mathilde peut arrêter et rejoint sa solution de couchage indépendante avant le retour de Marie
```""")
replace_once(rel, "> Je suis dans ma chambre.", "> Je suis arrivée.")

# J14 discovery conversation resumes only after a real departure.
replace_once(
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md",
    """Mathilde ne tente pas de le récupérer.

Elle quitte la cuisine ou termine ce qu’elle faisait.

À 18:36, elle écrit depuis une autre pièce.""",
    """Mathilde ne tente pas de le récupérer.

Elle quitte l’appartement pour prendre l’air quelques minutes ou terminer une course déjà prévue.

À 18:36, elle écrit depuis dehors.""",
)

# Update lot D guide with the final text-only correction note.
rel = "docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md"
text = read(rel)
needle = "Les changements concernent uniquement la formulation des messages. Les identifiants canoniques ont été comparés avant et après chaque remplacement et sont inchangés."
replacement = needle + "\n\nLe contrôle final a également supprimé deux reprises de chat depuis des pièces différentes du même logement : J11 commence désormais avant l’entrée de Mathilde, et J14 reprend après sa sortie réelle."
if text.count(needle) != 1:
    raise RuntimeError("Lot D guide result marker missing")
write(rel, text.replace(needle, replacement, 1))

print("Final lot D text-only fixes completed successfully.")
