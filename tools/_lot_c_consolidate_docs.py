#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def write(rel: str, text: str) -> None:
    path = ROOT / rel
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def replace_exact(rel: str, old: str, new: str, *, required: bool = True) -> None:
    text = read(rel)
    count = text.count(old)
    if required and count != 1:
        raise RuntimeError(f"{rel}: expected exactly one literal match, found {count}: {old[:100]!r}")
    if not required and count == 0:
        return
    if count > 1 and required:
        raise RuntimeError(f"{rel}: ambiguous literal match ({count})")
    write(rel, text.replace(old, new, 1 if required else -1))


def replace_regex(rel: str, pattern: str, replacement: str, *, flags: int = re.MULTILINE | re.DOTALL) -> None:
    text = read(rel)
    updated, count = re.subn(pattern, replacement.rstrip() + "\n\n", text, count=1, flags=flags)
    if count != 1:
        raise RuntimeError(f"{rel}: expected one regex match, found {count}: {pattern}")
    write(rel, updated)


def insert_before(rel: str, anchor: str, block: str) -> None:
    text = read(rel)
    if block.strip() in text:
        return
    count = text.count(anchor)
    if count != 1:
        raise RuntimeError(f"{rel}: anchor count {count}: {anchor!r}")
    write(rel, text.replace(anchor, block.rstrip() + "\n\n" + anchor, 1))


def append_section(rel: str, title: str, body: str) -> None:
    text = read(rel)
    if title in text:
        return
    write(rel, text.rstrip() + "\n\n---\n\n" + title + "\n\n" + body.strip() + "\n")


def status_validated(rel: str) -> None:
    text = read(rel)
    text = text.replace(
        "**Catégorie : Canon candidat à validation narrative**",
        "**Catégorie : Canon validé narrativement — source pré-runtime consolidée**",
        1,
    )
    write(rel, text)


# ---------------------------------------------------------------------------
# C1 — ouverture J01–J09 consolidée
# ---------------------------------------------------------------------------
opening_source = r'''# Réseau Intime — Source canonique consolidée J01–J06

## Statut

**Catégorie : Source narrative canonique consolidée — pré-runtime**

**Périmètre : J01 à J06**

Ce document remplace l’usage de `J01_J09_AUDIT_CONFORMITE_NARRATIVE.md` comme patch mental permanent pour J01–J06.

Les dialogues runtime historiques restent à migrer plus tard. Les décisions narratives ci-dessous sont la source de vérité.

---

# 1. Règles communes

- messagerie texte uniquement ;
- toute co-présence arrête le chat direct ;
- aucune réplique orale n’est affichée comme message ;
- une proposition ne devient promesse qu’après choix Player ;
- aucune image de scène ne devient trace diégétique ;
- aucun ticket, propriétaire de vague, candidate pool ou R2 automatique ;
- Marie revient obligatoirement après toute continuité extérieure ;
- les routes restent invisibles.

---

# 2. J01 — Marie et Sandra

## Fonction

- établir la vie commune Marie / Player ;
- réactiver Sandra par une trace concrète ;
- ne pas créer de triangle explicite ;
- Mathilde apparaît indirectement dans le fil Marie.

## Corrections intégrées

- les deux anciennes répliques orales directes sont retirées ;
- les événements physiques restent décrits sans dialogue ;
- la photographie Sandra utilise `trace_id: j01_sandra_lunch_memory_soft` ;
- voir cette photographie crée `fact_player_saw_sandra_lunch_photo` ;
- aucun transfert ni sauvegarde hors fil n’est autorisé ;
- une présence Marie éventuelle utilise `promise_id: marie_j01_shared_evening` seulement si Player l’accepte.

---

# 3. J02 — Arrivée de Mathilde

## Fonction

- introduire Mathilde comme personne et besoin réel ;
- mettre le foyer en mouvement ;
- élargir le réseau sans panel de routes.

## Corrections intégrées

- tout libellé `Marie appelle` devient `Marie écrit` ;
- l’aide à l’arrivée utilise `promise_id: mathilde_j02_arrival_help` ;
- `j02_mathilde_arrival_room_01` est un `FACT_RECORD`, pas une photographie diégétique garantie ;
- aucun créateur d’image n’est inventé ;
- Mathilde arrive et s’organise même si Player refuse ou échoue.

---

# 4. J03–J04 — Travail, réseau et premières traces publiques

## Fonction

- rendre visibles La Verrière, Raphaëlle, Pauline et Bastien ;
- conserver Marie comme axe principal ;
- séparer clairement monde professionnel et monde social.

## Traces

- `j03_marie_laverriere_setup_01` : photographie seulement si Élodie la crée ; sinon `FACT_RECORD` ;
- `j04_pauline_bastien_public_set_01` : set public contrôlé par Pauline via retardateur, avec Bastien et le groupe réellement présents ;
- audience publique ou de groupe nommée ;
- aucune version privée dérivée automatiquement.

---

# 5. J05 — Une heure réelle

## Fonction

Marie demande une heure ou une présence concrète.

- `promise_id: marie_j05_shared_hour` ;
- Player accepte, amende précisément ou refuse ;
- un `plus tard` sans heure ne crée rien ;
- Marie agit seule si Player ne s’engage pas ;
- l’heure payée ne devient pas un score de confiance.

---

# 6. J06 — Continuité extérieure optionnelle

## Fonction

Une seule continuité extérieure peut devenir visible si elle a été réellement préparée.

## Contrat

- `promise_id: j06_external_continuity_window` seulement après acceptation réelle ;
- aucune candidate pool visible ou autoritaire ;
- aucun `external_ticket_limit` ;
- aucun `wave_id` propriétaire ;
- aucun `unique R2 owner` ;
- aucune constante `MATHILDE_R2_MAX` ;
- aucune route ou accès chargé automatique ;
- la continuité peut être refusée ou expirer ;
- le retour Marie est obligatoire et conserve l’état du couple.

## Sortie maximale

Une continuité directe peut produire une attention reconnue ou une possibilité future, jamais une propriété de route, une permission adulte ou une femme gagnée.

---

# 7. Handoff J07

À l’entrée de J07 :

- Marie possède un état issu d’actes réels ;
- Mathilde reste une invitée du foyer ;
- Sandra reste une continuité légère ;
- Raphaëlle reste une relation professionnelle ;
- Pauline et Bastien possèdent une surface publique réelle ;
- Nico reste un ami social ;
- aucun accès adulte n’est ouvert ;
- aucune route n’appartient à un personnage.

> **L’ouverture ne choisit pas une route. Elle construit les personnes, les lieux et les promesses dont la saison pourra ensuite demander le prix.**
'''
write("docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md", opening_source)

for day in range(7, 22):
    status_validated(f"docs/canon/dialogues/J{day:02d}_SCRIPT_NARRATIF_COMPLET.md")

# J07 — promesse Nico réellement optionnelle.
replace_exact(
    "docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md",
    "- Player et Nico ont prévu une continuation mardi à 18 h 45 ;",
    "- Player peut avoir accepté, amendé ou refusé une continuation Nico ;",
)
replace_regex(
    "docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 9\. Fermeture commune Nico\n.*?(?=^# 10\.)",
    r'''# 9. Fermeture commune Nico

Après les trois branches :

**Réponse Player guidée**

> au moins c’est dit

**22:58 — Nico**

> Oui.

**22:58 — Nico**

> Dire ce qu’on veut, c’est la partie facile.

**22:59 — Nico**

> Le reste, c’est ce qu’on en fait et qui est au courant.

**23:00 — Nico**

> Je finis les plannings demain avant le service.

**23:00 — Nico**

> Passe à 18 h 45 si tu veux qu’on termine ça sans le faire tenir dans des bulles.

Player reçoit un vrai choix.

## N1 — Accepter mardi

**Player**

> je passe. 18 h 45

**23:01 — Nico**

> Ça marche.

**23:01 — Nico**

> Si tu annules, annule.

**23:02 — Nico**

> Ne me fais pas garder une chaise pour une philosophie.

```text
promise_id: nico_j07_tuesday_1845
status: ACTIVE
```

## N2 — Proposer jeudi conditionnel

**Player**

> mardi non. jeudi avant ton service si on confirme avant midi

**23:01 — Nico**

> Conditionnel, alors.

**23:02 — Nico**

> Sans confirmation, je ne garde rien.

```text
promise_id: nico_j07_thursday_conditional
status: CONDITIONAL
```

## N3 — Fermer la continuation

**Player**

> pas besoin de remettre. merci d’avoir parlé

**23:01 — Nico**

> D’accord.

**23:02 — Nico**

> On garde le reste normal.

```text
promise_id: nico_j07_tuesday_1845
status: REFUSED
```

Cette continuation n’est jamais une route Nico–Player, un alibi, une permission concernant Marie ou Mathilde, ni une promesse d’image.
''',
)
append_section(
    "docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
promise_id: raphaelle_j07_mobile_review
promise_id: nico_j07_tuesday_1845
promise_id: nico_j07_thursday_conditional
promise_id: marie_j07_household_request
trace_id: j07_nico_confidence_01
fact_id: fact_nico_received_player_confidence
```

Seuls les choix réellement acceptés deviennent des promesses actives.""",
)

# J08 — lire uniquement les attentes créées, plus fallback.
replace_exact(
    "docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md",
    "J07 a créé trois attentes possibles :",
    "J07 peut avoir créé jusqu’à trois attentes, chacune lue uniquement si son `promise_id` est actif :",
)
insert_before(
    "docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md",
    "# 9. Fenêtre C — 18:21 — Nico rappelle la chaise",
    """# 8 bis. Garde d’éligibilité Nico

La fenêtre Nico existe uniquement si :

```text
promise_id: nico_j07_tuesday_1845
status: ACTIVE
```

Si la promesse a été refusée, amendée vers jeudi ou expirée, Nico ne garde aucune chaise et n’envoie aucun rappel mardi.
""",
)
insert_before(
    "docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md",
    "# 11. Choix principal de superposition",
    """# 10 bis. Fallback sans superposition

Si moins de deux obligations sont actives après lecture des registres :

- Player paie l’unique obligation due ;
- ou la ferme clairement ;
- la journée ne fabrique aucun conflit ;
- Marie ouvre J09 par une respiration ordinaire ;
- aucun personnage absent n’est puni.

La superposition n’existe que lorsque plusieurs personnes ont réellement organisé leur temps autour de réponses acceptées.
""",
)
append_section(
    "docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
promise_id: raphaelle_j07_mobile_review
promise_id: nico_j07_tuesday_1845
promise_id: marie_j07_household_request
```

Une fenêtre lit le statut de sa promesse ; elle ne suppose jamais que l’attente existe.""",
)

# J09 — aucun chat direct en co-présence et dîner réellement choisi.
replace_regex(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    r"^## 8\.1 Co-présence et messagerie limitée\n.*?(?=^# 9\.)",
    r'''## 8.1 Co-présence hors téléphone

Player et Marie sont dans le même lieu.

Le chat direct s’arrête.

```text
17:57–ouverture
montage hors téléphone
aucun dialogue oral transcrit
Player prend les tâches déjà annoncées
Marie et Élodie poursuivent leur travail
```

Les anciennes lignes logistiques `Tu es où ?`, `derrière les chaises` et `rallonge noire côté scène` deviennent un état de scène non dialogué.

Le prochain échange direct a lieu après une séparation réelle.
''',
)
replace_regex(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 20\. Retour après branche B3 — Présence bornée\n.*?(?=^# 21\.)",
    r'''# 20. Retour après branche B3 — Présence bornée

**23:07 — Marie**

> Tu es parti à 21 h 30.

**23:07 — Marie**

> Exactement comme annoncé.

**Réponse Player guidée**

> tu vérifies mes sorties maintenant

**23:08 — Marie**

> Non.

**23:08 — Marie**

> J’apprécie simplement les heures qui ne fondent pas.

**23:09 — Marie**

> Demain 20 h 30, tu peux ?

Player reçoit un vrai choix.

### M1 — Accepter

**Player**

> oui. 20 h 30

**Marie**

> Alors je bloque.

```text
promise_id: marie_j09_dinner_j10_2030
status: ACTIVE
```

### M2 — Proposer vendredi

**Player**

> demain non. vendredi 20 h 30 si tu peux

**Marie**

> Vendredi, oui.

```text
promise_id: marie_j09_dinner_friday_2030
status: ACTIVE
```

### M3 — Refuser

**Player**

> non. ne bloque pas pour moi

**Marie**

> D’accord.

```text
promise_id: marie_j09_dinner_j10_2030
status: REFUSED
```

### État de sortie

```text
présence limitée mais fiable
retour couple conditionnel au choix réel
```
''',
)
replace_regex(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 21\. Retour après branche C — Absence honnête\n.*?(?=^# 22\.)",
    r'''# 21. Retour après branche C — Absence honnête

**23:07 — Marie**

> Je ferme.

**23:07 — Marie**

> La soirée était bien.

**23:08 — Marie**

> Vraiment.

**Réponse Player guidée**

> je suis content

**23:08 — Marie**

> Moi aussi.

**23:09 — Marie**

> Et merci d’avoir dit non avant.

**23:09 — Marie**

> Je n’ai attendu personne.

**23:10 — Marie**

> Demain 20 h 30, tu es là ?

Player accepte, propose vendredi ou refuse exactement comme dans la branche B3.

Aucune réponse guidée ne crée automatiquement le dîner.

### État de sortie

```text
absence honnête correctement absorbée
Marie autonome
retour couple conditionnel au choix réel
```

Le jeu ne traduit pas cette branche par une soirée ratée, une autre personne qui remplace Player ou une punition de route.
''',
)
replace_exact(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    "M1 présence active + dîner J10 20 h 30\nM2 présence tardive fiable + dîner J10 20 h 30\nM3 présence bornée + dîner J10 20 h 30\nM4 absence honnête + dîner J10 20 h 30",
    "M1 présence active + dîner J10 possible selon choix\nM2 présence tardive fiable + dîner J10 possible selon choix\nM3 présence bornée + dîner J10 accepté, amendé ou refusé\nM4 absence honnête + dîner J10 accepté, amendé ou refusé",
)
replace_exact(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    "- messages logistiques en co-présence ;",
    "- montage hors téléphone pendant la co-présence ;",
)
append_section(
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
trace_id: j09_marie_black_dress_private_01
trace_id: j09_marie_laverriere_public_01
trace_id: j09_marie_laverriere_after_01
promise_id: marie_j09_dinner_j10_2030
promise_id: marie_j09_dinner_friday_2030
fact_id: fact_player_received_marie_black_dress_image
fact_id: fact_marie_public_professional_version_visible
```

Créateurs : Marie pour la trace privée ; Élodie pour les traces La Verrière.""",
)

# ---------------------------------------------------------------------------
# C2/C3/C4 — scripts J10–J21 et identifiants
# ---------------------------------------------------------------------------
# J10 : promesse Sandra documentée.
replace_exact(
    "docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md",
    "rencontre J10 non tenue\nune seule alternative conditionnelle\naucune escalade J11",
    "promise_id: sandra_cafe_saturday_1100\nstatus: CONDITIONAL\nconfirmation_deadline: J11 vendredi 18 h\npossible_due_at: J12 samedi 11 h\naucune escalade J11",
)
append_section(
    "docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Handoff lot C",
    """La branche Sandra alternative est payée, refusée ou expirée dans le préambule J12.

```text
promise_id: sandra_cafe_saturday_1100
trace_id: j10_mathilde_outfit_choice_01
```

Une alternative conditionnelle ne devient jamais une progression J11.""",
)

# J11 : indépendance matérielle Mathilde + IDs.
replace_exact(
    "docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md",
    "- aucun usage du logement comme accès.",
    "- aucun usage du logement comme accès ;\n- Mathilde possède une solution indépendante pour dormir ;\n- son hébergement ne dépend pas de son oui ;\n- elle peut quitter le lieu avec ses affaires et sa sécurité intactes ;\n- l’absence de Marie n’a pas été organisée pour créer la fenêtre.\n\n```text\nmathilde_has_independent_sleep_option = true\nmathilde_can_leave_safely = true\nmarie_absence_not_engineered = true\n```\n\nÀ défaut, le plafond est `PROXIMITY_CONSENTED` et aucun passage physique explicite n’est éligible.",
)
append_section(
    "docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
trace_id: j11_sandra_chosen_image_01
trace_id: j11_raphaelle_chosen_result_01
trace_id: j11_mathilde_physical_aftercare_01
fact_id: fact_sandra_chose_private_image_for_player
fact_id: fact_raphaelle_chose_player_for_result_image
fact_id: fact_mathilde_physical_event_occurred
aftercare: aftercare_mathilde_j11
```

Sandra crée sa propre image. Maud crée le résultat Raphaëlle. Une branche physique Mathilde reste impossible sans indépendance matérielle réelle.""",
)

# J12 : préambule Sandra et co-présence.
insert_before(
    "docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md",
    "# 6. Fenêtre A — 14:42 — Marie donne les heures",
    r'''# 5 bis. Préambule conditionnel Sandra — 11 h

Cette fenêtre existe uniquement si :

```text
promise_id: sandra_cafe_saturday_1100
status: ACTIVE
```

**09:18 — Sandra**

> 11 h tient toujours.

**09:19 — Sandra**

> Je pars à 10 h 34.

**09:19 — Sandra**

> Information très utile pour éviter les réponses à 10 h 57.

Player confirme ou ferme avant le déplacement.

Si le café est maintenu :

```text
11:00–11:30
rencontre hors téléphone
aucun dialogue oral transcrit
aucune nouvelle image
aucune progression adulte
```

Après séparation :

**11:44 — Sandra**

> Train attrapé.

**11:45 — Sandra**

> Cette fois sans performance athlétique contestable.

La promesse devient `PAID`. Si Player ne confirme pas avant 9 h 30, elle devient `EXPIRED` et Sandra ne se déplace pas.
''',
)
replace_regex(
    "docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 9\. Fenêtre B — Montage La Verrière\n.*?(?=^# 10\.)",
    r'''# 9. Fenêtre B — Montage La Verrière hors téléphone

Cette fenêtre existe pour L-A.

```text
17:45–19:00
Player rejoint Marie à La Verrière.
Le chat direct s’arrête.
Player prend les tables du fond et la rallonge noire.
Marie et Élodie poursuivent le montage.
Aucun dialogue oral n’est transcrit.
Aucun choix Player n’est demandé pendant la co-présence.
```

Les anciennes lignes logistiques deviennent un état de scène ou une notification passive d’équipe. Le prochain échange direct Marie / Player intervient après une séparation réelle.
''',
)
append_section(
    "docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
promise_id: sandra_cafe_saturday_1100
promise_id: marie_j12_laverriere_presence
promise_id: j12_annexe_continuation
trace_id: j12_laverriere_public_group_set_01
trace_id: j12_annexe_public_group_set_01
trace_id: j12_sandra_public_context_view_01
fact_id: fact_j12_laverriere_participants
fact_id: fact_j12_annexe_participants
```

Élodie crée le set public La Verrière. Sophie crée le set public L’Annexe lorsque cette branche existe.""",
)

# J14 : traces enregistrées et séparation réelle.
replace_exact(
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md",
    "version privée Pauline\nimage masquée Raphaëlle\nmessage d’heure ou d’alibi Nico\nimage destinée Sandra\nnotification ou image Mathilde\nphoto publique Marie juxtaposée à une notification privée",
    "j13_pauline_private_version_01\nj13_raphaelle_masked_version_01\nj13_nico_alibi_or_hour_message_01\nj11_sandra_chosen_image_01\nj10_mathilde_outfit_choice_01 ou j11_mathilde_physical_aftercare_01\nj09_marie_black_dress_private_01 juxtaposée à j09_marie_laverriere_public_01",
)
replace_exact(
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md",
    "→ échange textuel après séparation ou depuis des pièces distinctes",
    "→ séparation physique réelle\n→ échange textuel après que l’un des personnages a quitté le lieu",
)
replace_exact(
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md",
    "Le jeu mémorise donc séparément :\n\n```text\ntrace_vue\nréaction_player\nexplication_player\ncontexte_réel\ninterprétation_témoin\n```",
    "Le jeu mémorise donc séparément :\n\n```text\ntrace_id\nwitness_id\nvisible_fields\nplayer_reaction\nplayer_explanation\nknowledge_id: fact_witness_saw_limited_trace\n```",
)
append_section(
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
trace_id: j14_discovery_event_01
fact_id: fact_witness_saw_limited_trace
fact_id: fact_trace_controller_informed_of_audience_breach
fact_id: fact_player_explanation_to_witness
promise_id: j14_witness_clarification
promise_id: j14_inform_trace_controller
```

Aucune variante J14 n’existe sans `discovered_trace_id` déjà créé et encore affichable.""",
)

# J17 : séparation réelle et calendrier post-J21.
replace_exact(
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md",
    "- dans une autre pièce avec une demande d’espace ;",
    "- dans un lieu distinct après une séparation physique réelle ;",
)
replace_regex(
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md",
    r"^## C17-A2 — Proposer une présence concrète\n.*?(?=^## C17-A3)",
    r'''## C17-A2 — Proposer une présence concrète

**Player**

> jeudi prochain 20 h 30 pour notre point. et si on décide encore d’essayer, je bloque le dimanche d’après avec toi

**Marie**

> Jeudi 20 h 30.

**Marie**

> Une heure réelle.

**Marie**

> Le dimanche d’après n’existe pas encore comme récompense.

**Marie**

> On le confirme jeudi si on est toujours capables de tenir la même règle.

```text
promise_id: couple_review_due_at
status: ACTIVE
possible_future_promise: couple_shared_day_due_at
status: CONDITIONAL
```
''',
)
# Remove all stale future-Sunday wording in J17.
text = read("docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md")
text = text.replace("Jusqu’à dimanche", "Jusqu’à jeudi prochain, 20 h 30")
text = text.replace("jusqu’à dimanche", "jusqu’à jeudi prochain, 20 h 30")
text = text.replace("chacun se place dans une pièce différente", "les personnages se séparent réellement avant toute reprise textuelle")
write("docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md", text)
insert_before(
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md",
    "# 18. Ouverture Marie — La conversation qui ne peut plus être repoussée",
    """# 17 bis. Garde text-only consolidée

La conversation ne peut commencer par messages que lorsque Marie et Player se trouvent dans des lieux distincts.

Changer de pièce ne suffit pas. Si aucune séparation réelle n’existe, la conversation hors téléphone est payée à l’heure choisie et le prochain message n’intervient qu’après un départ, un trajet séparé ou un retour dans deux logements distincts.
""",
)
append_section(
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
promise_id: marie_j16_couple_conversation_j17
promise_id: couple_review_due_at
promise_id: couple_shared_day_due_at
trace_id: j17_couple_definition_record_01
fact_id: fact_couple_state_defined
fact_id: fact_mathilde_left_household
```

Le checkpoint du couple se situe après J21. J20 ne paie aucune journée Marie promise en J17.""",
)

# J19 : connaissance Pauline réduite tant qu’aucune source antérieure n’existe.
text = read("docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md")
old = "Moi je sais ce qu’elle m’a déjà confié sur votre couple."
if old not in text:
    raise RuntimeError("J19: expected Pauline knowledge sentence not found")
text = text.replace(old, "Je suis son amie. Je sais que ce qu’on fait la concerne maintenant.", 1)
write("docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md", text)
append_section(
    "docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — Identifiants consolidés",
    """```text
trace_id: j19_pauline_reciprocal_message_01
trace_id: j19_raphaelle_creative_access_01
fact_id: fact_pauline_private_state_defined
fact_id: fact_raphaelle_access_state_defined
fact_id: fact_pauline_knows_marie_couple_fragility = NOT_CREATED tant qu’aucune source n’est écrite
promise_id: raphaelle_future_atelier_saturday_1500
```

Pauline connaît que ses actes concernent Marie parce que Marie et Player forment un couple public. Elle ne connaît aucune confidence précise de Marie sans source antérieure.""",
)

# J21 : calendrier, co-présence et posture C conditionnelle.
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 10\. Matin — Accord provisoire\n.*?(?=^# 11\.)",
    r'''# 10. Matin — Accord provisoire

**07:42 — Marie**

> J’ai pris le café dans la grande tasse.

**07:43 — Marie**

> La petite était dans la chambre où tu dors.

**07:43 — Marie**

> Phrase toujours étrange.

**07:44 — Marie**

> Jeudi 20 h 30 tient toujours.

**07:44 — Marie**

> Jusqu’à jeudi, notre règle tient aussi.

```text
promise_id: couple_review_due_at
status: ACTIVE
```
''',
)
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 11\. Matin — Reconfiguration en négociation\n.*?(?=^# 12\.)",
    r'''# 11. Matin — Reconfiguration en négociation

**07:42 — Marie**

> Je pars tôt.

**07:42 — Marie**

> Élodie a déplacé la réunion sans déplacer la salle.

**07:43 — Marie**

> On adore.

**07:44 — Marie**

> Pour nous : aucune nouvelle étape avant jeudi 20 h 30.

**07:45 — Marie**

> Je préfère le réécrire un matin normal.

**07:45 — Marie**

> Pas uniquement quand quelqu’un nous oblige à en parler.
''',
)
insert_before(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    "# 26. Posture finale A — Agir selon la nouvelle règle",
    r'''# 25 bis. Garde d’éligibilité du choix final

```text
final_trace_id doit référencer J01_J21_TRACE_REGISTRY.md
```

Les postures A et B sont toujours disponibles.

La posture C apparaît uniquement si :

```text
existing_contradiction_id != null
```

et si cette contradiction était déjà active avant J21. Le jeu n’affiche aucune option C désactivée.
''',
)
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 28\. Posture finale C — Maintenir la contradiction\n.*?(?=^# 29\.)",
    r'''# 28. Posture finale C — Maintenir une contradiction déjà active

Cette posture existe uniquement si `existing_contradiction_id` a été créé avant J21 et reste actif à la fin de J20.

Contradictions éligibles :

```text
COUPLE_FALSE_HOUR
COUPLE_FALSE_PLACE
COUPLE_DOUBLE_LIFE
SANDRA_COPY_RETAINED_SECRETLY
PAULINE_COMPARTMENT
PAULINE_RECIPROCAL_TRACE
RAPHAELLE_CLEAR_SECRET
NICO_SHARED_ALIBI
NICO_ACCOMPLICE_DEBT
```

J21 ne peut jamais créer :

- la première copie non autorisée ;
- le premier mensonge d’heure ;
- le premier alibi ;
- la première audience compromise ;
- une nouvelle route sombre.

La réponse finale maintient seulement la contradiction existante. Si J20 a fermé un alibi ou si une trace a été supprimée sans copie active, C est inéligible.

```text
final_posture: EXISTING_CONTRADICTION_MAINTAINED
```
''',
)
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 31\. Soir — Reconquête active\n.*?(?=^# 32\.)",
    r'''# 31. Soir — Reconquête active

Le dernier échange direct a lieu avant la co-présence.

**18:52 — Marie**

> Je pars de La Verrière dans dix minutes.

**18:52 — Marie**

> Tu as pris du pain ?

**Player**

> oui

**18:53 — Marie**

> Bien.

**18:53 — Marie**

> Et demain, ne me demande pas si ce soir a tout réparé.

**18:54 — Marie**

> Recommence juste à être là.

**Player**

> d’accord

**18:54 — Marie**

> J’arrive.

La messagerie s’arrête. La soirée existe hors téléphone sans dialogue affiché.
''',
)
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 32\. Soir — Accord provisoire\n.*?(?=^# 33\.)",
    r'''# 32. Soir — Accord provisoire

Avant de rentrer, Marie écrit :

**18:52 — Marie**

> Je rentre vers 20 h 30.

**18:53 — Marie**

> Je prends la chambre ce soir.

**18:53 — Marie**

> Jeudi tient.

**Player**

> d’accord

**Marie**

> À tout à l’heure.

La messagerie s’arrête lorsque Marie rentre. Aucun `Bonne nuit` interactif n’est nécessaire depuis deux chambres du même logement.
''',
)
replace_regex(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    r"^# 33\. Soir — Reconfiguration en négociation\n.*?(?=^# 34\.)",
    r'''# 33. Soir — Reconfiguration en négociation

**18:52 — Marie**

> La règle a tenu aujourd’hui.

**18:52 — Marie**

> Une journée.

**18:53 — Marie**

> Je préfère compter les actes plutôt que déclarer une nouvelle vie après vingt-quatre heures.

**Player**

> oui

**18:54 — Marie**

> Jeudi 20 h 30.

La messagerie s’arrête à la co-présence.
''',
)
append_section(
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
    "# Annexe canonique — État final consolidé",
    """```text
final_trace_id
final_trace_state
final_trace_controller
final_trace_audience
existing_contradiction_id
final_posture_options
final_posture
```

`final_trace_id` doit exister dans le registre des traces. Une image retirée peut revenir uniquement comme `ABSENCE_MARKER`, jamais comme fichier restauré.""",
)

# Trace creator resolutions.
trace_rel = "docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md"
text = read(trace_rel)
text = text.replace("trace_type: PHOTO ou FACT_RECORD selon production finale", "trace_type: FACT_RECORD")
text = text.replace("creator: à résoudre au lot C avant production", "creator: none")
text = text.replace("owner: Mathilde ou Marie selon créateur final", "owner: état narratif du foyer")
text = text.replace("current_state: ACTIVE ou NOT_CREATED", "current_state: ACTIVE", 1)
text = text.replace("eligible_for_j21: true seulement si PHOTO réellement produite", "eligible_for_j21: false")
text = text.replace("creator: Élodie si photo ; sinon aucun créateur", "creator: Élodie si PHOTO ; none si FACT_RECORD")
text = text.replace("creator: Pauline ou tiers exact à résoudre au lot C", "creator: Pauline via retardateur")
text = text.replace("owner: Pauline ou créateur final", "owner: Pauline")
text = text.replace("creator: Élodie ou tiers exact nommé", "creator: Élodie")
text = text.replace("creator: personne exacte présente et autorisée", "creator: Sophie")
text = text.replace("owner: créateur final ou groupe social", "owner: Sophie")
text = text.replace("creator: créateur exact du set J12", "creator: Élodie, source j12_laverriere_public_group_set_01")
text = text.replace("Le mapping de :\n\n```text\nlaverriere_public_group_photo_set_01\n```\n\nreste bloqué jusqu’à clarification de son jour, de son créateur et de son audience.", "Le legacy `laverriere_public_group_photo_set_01` se mappe vers `j12_laverriere_public_group_set_01`, créé par Élodie pour l’audience La Verrière nommée.")
write(trace_rel, text)

# Historical banners.
for rel, note in [
    ("docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md", "Les corrections J01–J06 sont consolidées dans `J01_J06_SOURCE_CANON_CONSOLIDE.md`; J07–J09 sont consolidés dans leurs scripts sources."),
    ("docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md", "Archive canonique d’architecture. Son ancien statut de production est supersédé par les scripts consolidés, les registres et le contrat d’état."),
    ("docs/16_ROUTE_REACHABILITY_MATRIX.md", "Archive de conception antérieure. Pour J01–J21, `J01_J21_REACHABILITY_MATRIX.md` et `SEASON_1_NARRATIVE_STATE_CONTRACT.md` sont autoritaires."),
]:
    text = read(rel)
    banner = f"> **STATUT HISTORIQUE / SUPERSÉDÉ** — {note}\n\n"
    if banner not in text:
        lines = text.splitlines(True)
        lines.insert(1, "\n" + banner)
        write(rel, "".join(lines))

# Indexes and current status.
read_order = "docs/canon/DOCUMENTATION_READING_ORDER.md"
text = read(read_order)
text = text.replace("> **Phase : consolidation des sources et statuts — lot C**", "> **Phase : polish des voix et naturel — lot D**")
text = text.replace("L’audit global, le lot A et le lot B sont validés.", "L’audit global et les lots A, B et C sont validés.")
text = text.replace("La prochaine étape est d’intégrer physiquement les corrections et identifiants dans les scripts sources afin de supprimer les overlays documentaires.", "La prochaine étape est la passe de naturel et de distinction des voix sur le corpus consolidé.")
text = text.replace("docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md", "docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md\ndocs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md", 1)
text = text.replace("→ lot C : consolidation des sources et statuts\n→ lot D : polish des voix", "→ lot C : consolidation des sources et statuts validée\n→ lot D : polish des voix")
text = text.replace("# 5. Lot C — prochaine tranche", "# 5. Lot C — état validé")
text = text.replace("Le lot C ne modifie toujours pas le runtime.", "Le lot C a consolidé les corrections et identifiants dans les sources documentaires sans modifier le runtime.")
text = text.replace("| Lot C | prochaine étape |", "| Lot C | validé |\n| Lot D | prochaine étape |")
text = text.replace("Le lot C doit faire en sorte que chaque script la dise directement,\nsans dépendre d’un correctif lu à côté.", "Les scripts disent maintenant directement la vérité des contrats.\nLe lot D doit leur rendre une voix plus humaine sans changer cette vérité.")
write(read_order, text)

status_rel = "docs/canon/NARRATIVE_CANON_STATUS.md"
text = read(status_rel)
text = text.replace("> **Current phase: source and status consolidation — lot C**", "> **Current phase: long-form voice polish — lot D**")
text = text.replace("The complete-season dialogue audit, lot A and lot B are validated.", "The complete-season dialogue audit and lots A, B and C are validated.")
text = text.replace("The next phase is to consolidate corrections and canonical identifiers physically into the source scripts.", "The next phase is the long-form naturalness and voice-distinction polish on the consolidated corpus.")
text = text.replace("Source consolidation lot C: next", "Source consolidation lot C: validated\nVoice polish lot D: next")
text = text.replace("## 7. Lot C — immediate next work", "## 7. Lot C — completed")
text = text.replace("Lot C remains documentation only.\n\nIt must not change route outcomes or introduce runtime schemas beyond the validated narrative contracts.", "Lot C remained documentation only. It integrated the validated corrections and canonical IDs without changing route outcomes or runtime schemas.")
text = text.replace("1. consolidate corrective overlays and IDs into source scripts\n2. resolve remaining image creators and knowledge sources\n3. complete the voice polish\n4. validate the consolidated narrative corpus\n5. decide separately whether to resume technical integration", "1. complete the long-form voice and naturalness polish\n2. validate the consolidated narrative corpus\n3. decide separately whether to resume technical integration")
text = text.replace("The contracts now define narrative truth.\nLot C must make every source script express that truth directly,\nwithout requiring a parallel corrective document.", "The source scripts now express the narrative contracts directly.\nLot D may change rhythm and wording, but not promises, knowledge, audiences or state transitions.")
write(status_rel, text)

readme_rel = "docs/canon/dialogues/README.md"
text = read(readme_rel)
text = text.replace("Ce dossier contient les scripts narratifs complets de la saison 1, leurs audits, leurs autorités correctives et leurs contrats pré-runtime.", "Ce dossier contient les sources narratives consolidées de la saison 1, leurs archives d’audit et leurs contrats pré-runtime.")
text = text.replace("J01_J09_AUDIT_CONFORMITE_NARRATIVE.md", "J01_J06_SOURCE_CANON_CONSOLIDE.md\nJ01_J09_AUDIT_CONFORMITE_NARRATIVE.md", 1)
text = text.replace("Lot B — validé\nProchaine étape — lot C : consolidation physique des sources", "Lot B — validé\nLot C — validé\nProchaine étape — lot D : polish des voix")
text = text.replace("1. consolidation physique des corrections et identifiants dans les scripts sources ;\n2. résolution des créateurs d’image encore ouverts ;\n3. consolidation J01–J09 ;\n4. passe de naturel des voix ;\n5. décision séparée de reprise technique.", "1. passe de naturel des voix ;\n2. validation du corpus consolidé ;\n3. décision séparée de reprise technique.")
write(readme_rel, text)

# Validation assertions.
for rel in [
    "docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md",
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md",
]:
    if "Canon validé narrativement — source pré-runtime consolidée" not in read(rel):
        raise RuntimeError(f"{rel}: validated status missing")

for rel, forbidden in [
    ("docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md", "SAME_VENUE_LOGISTICS"),
    ("docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md", "SAME_VENUE_LOGISTICS"),
    ("docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md", "depuis des pièces distinctes"),
    ("docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md", "dans une autre pièce avec une demande d’espace"),
    ("docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md", "Dimanche tient toujours"),
    ("docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md", "Jusqu’à dimanche"),
    ("docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md", "Moi je sais ce qu’elle m’a déjà confié sur votre couple."),
]:
    if forbidden in read(rel):
        raise RuntimeError(f"{rel}: forbidden legacy phrase remains: {forbidden}")

required_markers = {
    "docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md": ["nico_j07_tuesday_1845", "nico_j07_thursday_conditional"],
    "docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md": ["sandra_cafe_saturday_1100", "j12_laverriere_public_group_set_01"],
    "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md": ["fact_witness_saw_limited_trace", "j14_inform_trace_controller"],
    "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md": ["couple_review_due_at", "couple_shared_day_due_at"],
    "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md": ["existing_contradiction_id", "final_trace_id"],
}
for rel, markers in required_markers.items():
    text = read(rel)
    for marker in markers:
        if marker not in text:
            raise RuntimeError(f"{rel}: required marker missing: {marker}")

print("Lot C documentation consolidation completed successfully.")
