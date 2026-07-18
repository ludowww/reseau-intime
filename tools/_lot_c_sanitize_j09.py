#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REL = "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md"
PATH = ROOT / REL
text = PATH.read_text(encoding="utf-8")

pattern = r"^# 10\. Événement branche A\n.*?(?=^# 14\.)"
replacement = r'''# 10. Événement branche A — trace publique et logistique hors téléphone

## 10.1 Trace publique

À 19 h 08, Élodie publie :

```text
trace_id: j09_marie_laverriere_public_01
creator: Élodie
audience: groupe photographié / canal La Verrière nommé
```

La publication est une trace sociale passive, pas une conversation directe entre Marie et Player.

Selon l’état :

```text
A1 ou A2 : la trace montre une présence fonctionnelle et partagée
A3 : la trace peut montrer Player physiquement présent mais absorbé par son téléphone
```

Aucune réponse Player n’est affichée pendant la co-présence.

## 10.2 Logistique en salle

```text
19:00–fermeture
les verres, rideaux, cartons et rallonges sont gérés physiquement
aucun message direct Marie / Player
aucun choix interactif dans la salle
```

La qualité de présence reste observable par les actes.

---

# 11. Branche B — Player arrive à 20 h 15

Marie a réalisé le montage sans lui.

Elle ne lui fait pas payer une absence qu’il avait annoncée.

## 11.1 Orientation avant l’arrivée

Tant que Player est encore dehors :

**20:12 — Marie**

> Tu es où ?

**Player**

> côté cour

**20:13 — Marie**

> Passe par la porte scène.

**20:13 — Marie**

> Évite l’entrée principale. Il y a six manteaux et personne ne sait à qui ils appartiennent.

Le chat direct s’arrête dès que Player entre dans La Verrière.

## 11.2 Présence tardive observée hors téléphone

### B1 — Rejoindre le mouvement

```text
Player demande une tâche à son arrivée.
Il prend les cartons vides puis les verres propres.
arrivée tardive mais présence active
```

### B2 — Venir surtout regarder

```text
Player prend un verre et regarde Marie terminer.
Marie apprécie le regard mais distingue cette présence de l’action.
présence de spectateur
```

### B3 — Présence bornée et assumée

```text
Player aide jusqu’à 21 h puis reste dans la salle jusqu’à 21 h 30.
Il part à l’heure annoncée.
présence limitée mais fiable
```

Aucun dialogue oral n’est transcrit.

---

# 12. Événement branche B — trace passive

À 20 h 28, Élodie publie la même trace sociale autorisée :

```text
trace_id: j09_marie_laverriere_public_01
```

La lecture dépend des actes déjà observés :

```text
B1 : Player a rejoint le mouvement malgré son arrivée tardive
B2 : Player possède l’image mais Marie continue sa vie sociale
B3 : l’heure de départ reste une règle déjà connue
```

Aucun échange direct Marie / Player n’est affiché pendant la co-présence.

---

# 13. Sortie de co-présence J09

Le chat reste fermé jusqu’à une séparation réelle.

Les conséquences suivantes sont mémorisées sans message dans la salle :

```text
presence_active
presence_spectator
presence_bounded_reliable
presence_distracted
```

Le retour textuel commence uniquement en section 15, après le départ de Player ou de Marie.

---

'''
updated, count = re.subn(pattern, replacement, text, count=1, flags=re.MULTILINE | re.DOTALL)
if count != 1:
    raise RuntimeError(f"Expected one J09 co-presence block, found {count}")

for forbidden in [
    "## 10.2 Logistique en salle",
    "# 12. Choix secondaire B",
    "# 13. Événement branche B",
    "**20:26 — Marie**",
    "**20:29 — Marie**",
]:
    if forbidden in updated:
        raise RuntimeError(f"Legacy co-presence fragment remains: {forbidden}")

for required in [
    "Événement branche A — trace publique et logistique hors téléphone",
    "Le chat direct s’arrête dès que Player entre dans La Verrière.",
    "Sortie de co-présence J09",
]:
    if required not in updated:
        raise RuntimeError(f"Required marker missing: {required}")

PATH.write_text(updated.rstrip() + "\n", encoding="utf-8")
print("J09 co-presence cleanup completed successfully.")
