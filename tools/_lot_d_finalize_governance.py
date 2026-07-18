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


# J19 minor grammar correction.
replace_once(
    "docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md",
    "> on supprime tout les deux",
    "> on supprime tous les deux",
)

# README governance.
rel = "docs/canon/dialogues/README.md"
text = read(rel)
text = text.replace(
    "Le lot A prévaut sur les passages contradictoires de J10, J12, J14, J17 et J21 jusqu’à leur consolidation physique au lot C.",
    "Les corrections A–C sont consolidées dans les sources. Les audits restent des archives de décision et les contrats pré-runtime restent autoritatifs.",
)
text = text.replace(
    "J01_J21_REACHABILITY_MATRIX.md\n```",
    "J01_J21_REACHABILITY_MATRIX.md\nJ07_J21_LOT_D_POLISH_VOIX_NATUREL.md\n```",
    1,
)
text = text.replace(
    "Prochaine étape — validation finale avant reprise technique validé",
    "Prochaine étape — validation finale du corpus puis décision explicite de reprise technique",
)
text = text.replace(
    "1. passe de naturel des voix ;\n2. validation du corpus consolidé ;\n3. décision séparée de reprise technique.",
    "1. validation finale explicite du corpus narratif ;\n2. décision séparée de reprise technique.",
)
write(rel, text)

# Reading order governance.
rel = "docs/canon/DOCUMENTATION_READING_ORDER.md"
text = read(rel)
text = text.replace(
    "> **Phase : polish des voix et naturel — lot D**",
    "> **Phase : validation finale du corpus narratif**",
)
text = text.replace(
    "L’audit global et les lots A, B et C sont validés.",
    "L’audit global et les lots A, B, C et D sont validés.",
)
text = text.replace(
    "docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md\n```",
    "docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md\ndocs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\n```",
)
text = text.replace(
    "script source\n→ lot A lorsque concerné\n→ registres et contrat d’état\n→ reachability matrix\n→ audit global",
    "scripts consolidés\n→ registres et contrat d’état\n→ reachability matrix\n→ audits historiques\n→ guide lot D pour les critères de voix",
)
text = text.replace(
    "Le lot C doit supprimer progressivement la nécessité de l’overlay lot A en intégrant les corrections dans les scripts.",
    "Les overlays A–C sont consolidés dans les scripts ; ils restent des archives de décision.",
)
text = text.replace(
    "Aucune nouvelle modification technique J07–J21 avant :\n\n- consolidation des scripts sources ;\n- résolution des créateurs et traces encore ouverts ;\n- consolidation J01–J09 ;\n- passe de naturel ;\n- décision explicite de reprise technique.",
    "Aucune nouvelle modification technique J07–J21 avant :\n\n- validation finale explicite du corpus narratif ;\n- décision explicite et séparée de reprise technique.",
)
text = text.replace(
    "# 6. Tests obligatoires après lot C\n\n- aucun passage contradictoire avec le lot A ne reste dans les scripts ;\n- chaque trace citée possède un `trace_id` ;\n- chaque promesse importante possède un `promise_id` ;\n- chaque affirmation de connaissance forte possède un `fact_id` ;\n- les créateurs d’images diégétiques sont exacts ;\n- la branche physique Mathilde exige une indépendance matérielle réelle ;\n- les anciens audits servent d’historique, pas de patch mental ;\n- aucun runtime ou asset modifié.",
    "# 6. Validation finale après lot D\n\n- chaque voix reste identifiable sans nom ;\n- les formulations trop parfaites ont été réduites ;\n- les identifiants `trace_id`, `promise_id` et `fact_id` sont inchangés ;\n- aucune co-présence n’est rejouée par chat direct ;\n- les limites, promesses et conséquences restent lisibles ;\n- aucun runtime, JSON, test ou asset n’a été modifié.",
)
text = text.replace(
    "Le lot D doit leur rendre une voix plus humaine sans changer cette vérité.",
    "Le lot D a rendu les voix plus humaines sans modifier cette vérité.\nLa prochaine décision est technique et séparée.",
)
write(rel, text)

# Narrative canon status.
rel = "docs/canon/NARRATIVE_CANON_STATUS.md"
text = read(rel)
text = text.replace(
    "The complete-season dialogue audit and lots A, B and C are validated.",
    "The complete-season dialogue audit and lots A, B, C and D are validated.",
)
text = text.replace(
    "1. source files physically consolidate corrective overlays and canonical IDs ;\n2. unresolved diegetic image creators are fixed ;\n3. J01–J09 source authority is reconciled ;\n4. the long-form voice polish is validated ;\n5. an explicit decision resumes technical work.",
    "1. Ludovic explicitly signs off the final consolidated narrative corpus ;\n2. an explicit and separate decision resumes technical work.",
)
text = text.replace(
    "docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md",
    "docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md\ndocs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md",
    1,
)
text = text.replace(
    "docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md\n```",
    "docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md\ndocs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md\n```",
)
text = text.replace(
    "Until lot C is completed:\n\n```text\nsource script\n→ lot A corrective authority\n→ trace / promise / knowledge registries\n→ narrative state contract\n→ reachability matrix\n→ global audit\n```\n\nThis overlay is temporary.\n\nLot C must integrate the corrections and IDs directly into the scripts.",
    "Current authority order:\n\n```text\nconsolidated source scripts\n→ trace / promise / knowledge registries\n→ narrative state contract\n→ reachability matrix\n→ historical audits\n→ lot D voice guide\n```\n\nLots A–C are fully consolidated in source. Their documents remain historical decision records.",
)
text = text.replace(
    "lots A and B validated documentarily\ntechnical resumption prohibited before lots C–D and explicit approval",
    "lots A–D validated documentarily\ntechnical resumption prohibited before final narrative sign-off and explicit approval",
)
text = text.replace(
    "No runtime, JSON, test, tool, asset or gallery modification is authorized by the lot B merge.",
    "No runtime, JSON, test, tool, asset or gallery modification is authorized by lots A–D.",
)
text = text.replace(
    "1. complete the long-form voice and naturalness polish\n2. validate the consolidated narrative corpus\n3. decide separately whether to resume technical integration",
    "1. obtain final Ludovic sign-off on the consolidated narrative corpus\n2. decide separately whether to resume technical integration",
)
text = text.replace(
    "Lot D may change rhythm and wording, but not promises, knowledge, audiences or state transitions.",
    "Lot D changed rhythm and wording without changing promises, knowledge, audiences or state transitions.\nTechnical resumption remains a separate decision.",
)
write(rel, text)

# Assertions.
for rel, required in {
    "docs/canon/dialogues/README.md": ["Lot D — validé", "validation finale explicite du corpus narratif"],
    "docs/canon/DOCUMENTATION_READING_ORDER.md": ["Phase : validation finale du corpus narratif", "lots A, B, C et D sont validés"],
    "docs/canon/NARRATIVE_CANON_STATUS.md": ["lots A, B, C and D are validated", "final narrative sign-off"],
}.items():
    data = read(rel)
    for marker in required:
        if marker not in data:
            raise RuntimeError(f"{rel}: missing marker: {marker}")

print("Lot D governance finalized successfully.")
