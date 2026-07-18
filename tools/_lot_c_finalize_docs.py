#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def write(rel: str, text: str) -> None:
    (ROOT / rel).write_text(text.rstrip() + "\n", encoding="utf-8")


def replace_regex(rel: str, pattern: str, replacement: str) -> None:
    text = read(rel)
    updated, count = re.subn(pattern, replacement.rstrip() + "\n\n", text, count=1, flags=re.MULTILINE | re.DOTALL)
    if count != 1:
        raise RuntimeError(f"{rel}: expected one match, found {count}: {pattern}")
    write(rel, updated)


def replace_once(rel: str, old: str, new: str) -> None:
    text = read(rel)
    if text.count(old) != 1:
        raise RuntimeError(f"{rel}: expected one literal match: {old[:120]!r}")
    write(rel, text.replace(old, new, 1))


# J08 — every Nico-dependent collision is conditional.
rel = "docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md"
text = read(rel)
text = text.replace(
    "Nico attend à 18 h 45.",
    "Si `nico_j07_tuesday_1845` est `ACTIVE`, Nico attend à 18 h 45.",
)
text = text.replace(
    "Trois attentes sont réelles.",
    "Deux ou trois attentes sont réelles selon les `promise_id` actifs.",
)
text = text.replace(
    "Le foyer a déjà été payé à 18 h 30.\n\nÀ 18:47 :",
    "Le foyer a déjà été payé à 18 h 30. Cette sous-branche existe uniquement si `nico_j07_tuesday_1845` est encore `ACTIVE`.\n\nÀ 18:47 :",
)
write(rel, text)

# J09 — quality of presence is observed off-phone, not messaged in the room.
replace_regex(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 9\. Choix secondaire A — Qualité de la présence au montage\n.*?(?=^# 10\.)",
    r'''# 9. Qualité de la présence au montage — état hors téléphone

La qualité de présence n’est pas choisie par un échange de messages pendant la co-présence.

Elle est déterminée par les actes observables.

## A1 — Initiative réelle

```text
Player prend les tables du fond et la rallonge noire sans attendre une relance.
Marie n’a pas besoin de guider chaque geste.
présence active
```

## A2 — Humour mais action réelle

```text
Player plaisante brièvement mais accomplit les tâches annoncées.
présence joueuse et utile
```

## A3 — Présence distraite

```text
Player reste physiquement présent mais consulte plusieurs fois un autre fil.
Marie observe seulement l’attention déplacée.
présence physique
attention insuffisante
conséquence de couple active
```

Aucun dialogue oral n’est transcrit. Marie ne demande pas qui reçoit les messages.
''',
)

# J09 — dinner choice is real for every branch that proposes it.
replace_regex(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 16\. Retour après branche A1 ou A2 — Présence active\n.*?(?=^# 17\.)",
    r'''# 16. Retour après branche A1 ou A2 — Présence active

**23:07 — Marie**

> Merci pour ce soir.

**23:07 — Marie**

> C’était bien de te voir porter des chaises, parler à Élodie et ne pas me demander toutes les cinq minutes si ça allait.

**Réponse Player guidée**

> j’étais bien là

**23:08 — Marie**

> Oui.

**23:08 — Marie**

> Je l’ai vu.

**23:09 — Marie**

> Demain, 20 h 30, on mange ensemble ?

Player reçoit trois choix :

```text
M1 accepter → marie_j09_dinner_j10_2030 ACTIVE
M2 proposer vendredi → marie_j09_dinner_friday_2030 ACTIVE
M3 refuser → marie_j09_dinner_j10_2030 REFUSED
```

Aucune réponse guidée ne crée automatiquement le dîner.

### État de sortie

```text
présence active mémorisée
retour couple J10 conditionnel au choix réel
```

Aucune récompense sexuelle automatique.
''',
)
replace_regex(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 18\. Retour après branche B1 — Arrivée tardive active\n.*?(?=^# 19\.)",
    r'''# 18. Retour après branche B1 — Arrivée tardive active

**23:07 — Marie**

> Tu es arrivé à l’heure que tu avais donnée.

**23:07 — Marie**

> Et tu as pris un bout de la soirée en charge.

**Réponse Player guidée**

> j’aurais préféré être là plus tôt

**23:08 — Marie**

> Peut-être.

**23:08 — Marie**

> Mais tu n’as pas promis plus tôt.

**23:09 — Marie**

> Ce soir, ce que tu as dit et ce que tu as fait se ressemblent.

**23:10 — Marie**

> Demain 20 h 30 ?

Player accepte, propose vendredi ou refuse selon les choix M1–M3 définis en section 16.

### État de sortie

```text
présence tardive fiable
retour couple J10 conditionnel au choix réel
```
''',
)

# J17 — provisional rule carries the explicit post-J21 checkpoint.
replace_once(
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md",
    "nouveau point à une date précise\n```\n\n**19:27 — Marie**",
    "nouveau point : jeudi suivant J21, 20 h 30\n```\n\n```text\npromise_id: couple_review_due_at\nstatus: ACTIVE\n```\n\n**19:27 — Marie**",
)

# J21 — generic trace labels become registry IDs.
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 6\. Traces éligibles\n.*?(?=^# 7\.)",
    r'''# 6. Traces éligibles — registre canonique

J21 sélectionne uniquement un `trace_id` existant dans `J01_J21_TRACE_REGISTRY.md`.

## 6.1 Marie

```text
j09_marie_black_dress_private_01
j09_marie_laverriere_public_01
j09_marie_laverriere_after_01
j12_laverriere_public_group_set_01
```

## 6.2 Sandra

```text
j01_sandra_lunch_memory_soft
j11_sandra_chosen_image_01
j18_sandra_lunch_print_01
```

## 6.3 Mathilde

```text
j10_mathilde_outfit_choice_01
```

Si aucune photographie familiale réellement produite et autorisée n’existe, le foyer vide reste une `IMAGE_DE_SCÈNE` et ne devient pas une trace diégétique.

## 6.4 Pauline

```text
j04_pauline_bastien_public_set_01
j13_pauline_private_version_01
j19_pauline_reciprocal_message_01
```

## 6.5 Raphaëlle

```text
j11_raphaelle_chosen_result_01
j13_raphaelle_masked_version_01
j19_raphaelle_creative_access_01
```

## 6.6 Nico et le réseau

```text
j12_annexe_public_group_set_01
j13_nico_alibi_or_hour_message_01
j20_nico_exact_hour_record_01
j20_nico_unauthorized_copy_deleted_01
```

Une entrée `REMOVED`, `DELETED` ou `INACCESSIBLE` peut porter la finale uniquement par son état ou son absence. Son fichier n’est jamais restauré.
''',
)

# Trace registry — FACT_RECORD entries must not retain photo metadata.
rel = "docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md"
text = read(rel)
text = text.replace(
    "initial_audience: [Marie, Player, Mathilde] si photo familiale\ncurrent_audience: identique sauf retrait\nstorage_location: fil foyer ou archive de scène\nsaving_rule: OWNER_ONLY ou SAME_AUDIENCE_ONLY\ntransfer_rule: OWNER_CONFIRMATION_REQUIRED",
    "initial_audience: non applicable\ncurrent_audience: non applicable\nstorage_location: état narratif du foyer\nsaving_rule: NONE\ntransfer_rule: FORBIDDEN",
)
text = text.replace(
    "trace_type: PHOTO ou FACT_RECORD\nsource_day: J03 ou journée réconciliée future\nsource_scene: vie professionnelle Marie\ncreator: Élodie si PHOTO ; none si FACT_RECORD\nsubjects: [Marie]\nowner: Marie ou La Verrière\ninitial_audience: audience professionnelle nommée\ncurrent_audience: audience professionnelle nommée\nstorage_location: fil professionnel ou dossier La Verrière\nsaving_rule: PUBLIC_SOURCE_RULES\ntransfer_rule: PUBLIC_SOURCE_RULES\ncurrent_state: ACTIVE, SUPERSEDED ou NOT_CREATED\nknowledge_created: fact_player_knows_marie_laverriere_world\neligible_for_j14: false\neligible_for_j21: true si source et audience résolues",
    "trace_type: FACT_RECORD\nsource_day: J03\nsource_scene: vie professionnelle Marie établie\ncreator: none\nsubjects: [Marie]\nowner: état narratif La Verrière\ninitial_audience: non applicable\ncurrent_audience: non applicable\nstorage_location: registre de connaissances\nsaving_rule: NONE\ntransfer_rule: FORBIDDEN\ncurrent_state: ACTIVE\nknowledge_created: fact_marie_laverriere_world_exists\neligible_for_j14: false\neligible_for_j21: false",
)
write(rel, text)

# Final assertions.
checks_absent = {
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md": [
        "**18:00 — Marie**\n\n> Très bien.",
        "**Réponse Player guidée**\n\n> oui. 20 h 30\n\n**23:09 — Marie**\n\n> Parfait.",
        "**Réponse Player guidée**\n\n> oui\n\n**23:10 — Marie**\n\n> Très bien.",
    ],
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md": [
        "image du foyer déjà établie",
        "photographie sociale de L’Annexe",
    ],
}
for path, fragments in checks_absent.items():
    data = read(path)
    for fragment in fragments:
        if fragment in data:
            raise RuntimeError(f"{path}: legacy fragment remains: {fragment[:80]}")

required = {
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md": ["Qualité de la présence au montage — état hors téléphone", "retour couple J10 conditionnel au choix réel"],
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md": ["nouveau point : jeudi suivant J21, 20 h 30"],
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md": ["Traces éligibles — registre canonique", "j20_nico_unauthorized_copy_deleted_01"],
}
for path, markers in required.items():
    data = read(path)
    for marker in markers:
        if marker not in data:
            raise RuntimeError(f"{path}: marker missing: {marker}")

print("Lot C final documentation checks completed successfully.")
