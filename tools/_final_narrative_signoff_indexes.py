#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def write(path: str, text: str) -> None:
    (ROOT / path).write_text(text.rstrip() + "\n", encoding="utf-8")


def replace_once(path: str, old: str, new: str) -> None:
    text = read(path)
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{path}: expected one match, found {count}: {old[:120]!r}")
    write(path, text.replace(old, new, 1))


# README
readme = "docs/canon/dialogues/README.md"
replace_once(
    readme,
    "J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\n```",
    "J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\nJ01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md\n```",
)
replace_once(
    readme,
    "Lot D — validé\nProchaine étape — validation finale du corpus puis décision explicite de reprise technique",
    "Lot D — validé\nValidation finale J01–J21 — signée\nProchaine étape — décision explicite et séparée de reprise technique",
)
replace_once(
    readme,
    "Aucune nouvelle intégration J07–J21 ne doit commencer avant :\n\n1. validation finale explicite du corpus narratif ;\n2. décision séparée de reprise technique.",
    "Aucune nouvelle intégration J07–J21 ne doit commencer avant une décision explicite et séparée de reprise technique.\n\nLa validation finale du corpus narratif est signée.",
)

# Reading order
order = "docs/canon/DOCUMENTATION_READING_ORDER.md"
replace_once(
    order,
    "> **Phase : validation finale du corpus narratif**",
    "> **Phase : corpus narratif signé — décision technique requise**",
)
replace_once(
    order,
    "J07–J21 sont validés narrativement sous autorités correctives.\n\nL’audit global et les lots A, B, C et D sont validés.\n\nLa prochaine étape est la validation finale du corpus narratif avant toute reprise technique.",
    "J01–J21 constituent un corpus narratif finalisé et signé.\n\nL’audit global, les lots A–D et le sign-off final sont validés.\n\nLa prochaine étape est une décision explicite et séparée concernant la reprise technique.",
)
replace_once(
    order,
    "docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\n```",
    "docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\ndocs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md\n```",
)
replace_once(
    order,
    "scripts consolidés\n→ registres et contrat d’état\n→ reachability matrix\n→ audits historiques\n→ guide lot D pour les critères de voix",
    "scripts consolidés\n→ registres et contrat d’état\n→ reachability matrix\n→ sign-off final du corpus\n→ audits historiques\n→ guide lot D pour les critères de voix",
)
replace_once(
    order,
    "→ lot D : polish des voix validé\n→ validation Ludovic\n→ décision de reprise technique",
    "→ lot D : polish des voix validé\n→ validation finale Ludovic signée\n→ décision de reprise technique",
)
replace_once(
    order,
    "Aucune nouvelle modification technique J07–J21 avant :\n\n- validation finale explicite du corpus narratif ;\n- décision explicite et séparée de reprise technique.",
    "Aucune nouvelle modification technique J07–J21 avant une décision explicite et séparée de reprise technique.\n\nLa validation finale du corpus narratif est terminée.",
)
replace_once(
    order,
    "# 6. Validation finale après lot D\n\n- chaque voix reste identifiable sans nom ;",
    "# 6. Validation finale signée\n\nLe document `J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` confirme qu’aucun blocage narratif ne subsiste.\n\n- chaque voix reste identifiable sans nom ;",
)
replace_once(
    order,
    "| Lot D | validé |\n| Runtime J07–J21 | gelé |",
    "| Lot D | validé |\n| Validation finale du corpus | signée |\n| Runtime J07–J21 | gelé jusqu’à décision séparée |",
)
replace_once(
    order,
    "Le lot D a rendu les voix plus humaines sans modifier cette vérité.\nLa prochaine décision est technique et séparée.",
    "Le lot D a rendu les voix plus humaines sans modifier cette vérité.\nLe corpus narratif est signé. La prochaine décision est uniquement technique et séparée.",
)

# Narrative status
status = "docs/canon/NARRATIVE_CANON_STATUS.md"
replace_once(
    status,
    "> **Current phase: final narrative sign-off before technical resumption**",
    "> **Current phase: narrative corpus signed off — awaiting technical decision**",
)
replace_once(
    status,
    "The complete-season dialogue audit and lots A, B, C and D are validated.\n\nThe next phase is final narrative sign-off before any technical resumption.",
    "The complete-season dialogue audit, lots A–D and the final narrative sign-off are validated.\n\nThe only next step is an explicit and separate technical-resumption decision.",
)
replace_once(
    status,
    "→ Voice polish\n→ Ludovic validation\n→ Explicit technical-resumption decision",
    "→ Voice polish\n→ Final narrative corpus sign-off\n→ Explicit technical-resumption decision",
)
replace_once(
    status,
    "No new technical integration for J07–J21 before:\n\n1. Ludovic explicitly signs off the final consolidated narrative corpus ;\n2. an explicit and separate decision resumes technical work.",
    "No new technical integration for J07–J21 may begin until an explicit and separate decision resumes technical work.\n\nThe final consolidated narrative corpus is signed off.",
)
replace_once(
    status,
    "docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\n```",
    "docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\ndocs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md\n```",
)
replace_once(
    status,
    "Voice polish lot D: validated\nRuntime J07–J21: frozen",
    "Voice polish lot D: validated\nFinal narrative corpus sign-off: validated\nRuntime J07–J21: frozen pending a separate technical decision",
)
replace_once(
    status,
    "consolidated source scripts\n→ trace / promise / knowledge registries\n→ narrative state contract\n→ reachability matrix\n→ historical audits\n→ lot D voice guide",
    "consolidated source scripts\n→ trace / promise / knowledge registries\n→ narrative state contract\n→ reachability matrix\n→ final narrative corpus sign-off\n→ historical audits\n→ lot D voice guide",
)
replace_once(
    status,
    "lots A–D validated documentarily\ntechnical resumption prohibited before final narrative sign-off and explicit approval",
    "lots A–D and final narrative sign-off validated documentarily\ntechnical resumption prohibited until explicit and separate approval",
)
replace_once(
    status,
    "1. obtain final Ludovic sign-off on the consolidated narrative corpus\n2. decide separately whether to resume technical integration",
    "1. decide explicitly whether to resume technical integration\n2. if approved, scope the first technical reconciliation branch separately",
)
replace_once(
    status,
    "Lot D changed rhythm and wording without changing promises, knowledge, audiences or state transitions.\nTechnical resumption remains a separate decision.",
    "Lot D changed rhythm and wording without changing promises, knowledge, audiences or state transitions.\nThe narrative corpus is signed off. Technical resumption remains a separate decision.",
)

# Assertions
for path in [readme, order, status]:
    text = read(path)
    if "J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md" not in text:
        raise RuntimeError(f"{path}: sign-off document missing")

if "validation finale explicite du corpus narratif" in read(readme):
    raise RuntimeError("README: obsolete validation prerequisite remains")
if "obtain final Ludovic sign-off" in read(status):
    raise RuntimeError("Status: obsolete final sign-off task remains")

print("Final narrative sign-off indexes updated successfully.")
