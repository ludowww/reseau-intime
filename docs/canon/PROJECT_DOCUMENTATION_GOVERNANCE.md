# Réseau Intime — Gouvernance documentaire du projet

## Statut

**Catégorie : Canon de gouvernance actif**

**Périmètre : toute la documentation du dépôt**

**Autorité : définit où réside chaque vérité du projet et comment un document devient actif, historique ou obsolète**

Ce document existe pour garantir qu’une personne reprenant le projet puisse répondre sans ambiguïté à quatre questions :

```text
Que raconte actuellement le jeu ?
Que fait réellement le runtime ?
Quelle interface doit être produite ?
Quel document a autorité en cas de contradiction ?
```

---

# 1. Principe de source unique

Une décision ne doit posséder qu’une seule source autoritative.

Les autres documents peuvent :

- résumer ;
- indexer ;
- expliquer l’historique ;
- préparer une implémentation ;
- rapporter une validation.

Ils ne doivent pas redéfinir la décision.

Exemple :

```text
couleur UI de Marie
→ docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md

README.md
→ peut dire que les personnages ont une couleur
→ ne doit pas fixer une autre couleur
```

---

# 2. Quatre statuts documentaires

## `ACTIVE_CANON`

Document qui définit ce que le produit doit être.

Exemples :

- North Star ;
- canons personnages ;
- scripts narratifs consolidés ;
- contrats de traces, promesses et connaissances ;
- système UI vertical ;
- architecture des écrans.

## `ACTIVE_RUNTIME`

Document qui décrit l’état réellement implémenté ou le contrat d’une branche technique validée.

Il ne peut pas modifier le canon produit.

## `HISTORICAL`

Document conservé pour comprendre une décision, une version ou une migration passée.

Il ne doit pas être utilisé comme instruction active.

## `TO_REWRITE`

Document contenant encore des informations utiles mais incompatible avec les autorités actuelles.

Un document `TO_REWRITE` ne peut pas bloquer une implémentation conforme au canon actif.

---

# 3. Autorité par domaine

| Domaine | Source autoritative | Résumés autorisés |
|---|---|---|
| Vision produit | `docs/canon/bible/` | `README.md`, `ROADMAP.md` |
| Personnages et voix | `docs/canon/characters/` + Bible voix | index canoniques |
| Narration J01–J21 | `docs/canon/dialogues/` + sign-off final | README et statut |
| État narratif | registres J01–J21 + `SEASON_1_NARRATIVE_STATE_CONTRACT.md` | plans runtime |
| Communication text-only | `docs/canon/TEXT_ONLY_MESSAGING_CANON.md` | documents UI/runtime |
| UX/UI produit | `docs/canon/ui/` | README, ROADMAP, plans techniques |
| Runtime réellement actif | code, données et tests sur `main` | `docs/runtime/README.md` |
| Plan d’une branche technique | document ciblé sous `docs/runtime/` | PR correspondante |
| Statut projet synthétique | `README.md` et `ROADMAP.md` | aucun détail canonique nouveau |

---

# 4. Arborescence active

```text
docs/canon/bible/
    vision, expérience, routes, scènes, visuels et conséquences

docs/canon/characters/
    identité et voix des personnages

docs/canon/dialogues/
    sources narratives J01–J21, registres et sign-off

docs/canon/ui/
    système visuel, écrans, états et handoff UI

docs/canon/runtime/
    contrat d’état narratif pré-runtime

docs/runtime/
    état technique, audits et plans d’implémentation

docs/story_state/
    historique et support runtime ; non autoritaire sauf lien explicite depuis un index actif

docs/narrative/
    principalement historique ; non autoritaire sauf lien explicite depuis un index actif
```

---

# 5. Portails obligatoires

Une reprise de projet commence dans cet ordre :

```text
README.md
→ docs/canon/DOCUMENTATION_READING_ORDER.md
→ docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
→ autorité du domaine concerné
→ docs/runtime/README.md si travail technique
→ ROADMAP.md pour l’ordre des lots
```

Les portails doivent rester courts.

Ils pointent vers les sources ; ils ne les recopient pas intégralement.

---

# 6. En-tête recommandé pour les nouveaux documents

Tout nouveau document important doit préciser :

```text
Catégorie
Statut
Périmètre
Autorité
Supersède
Supersédé par
Base validée ou branche concernée
```

Les champs inutiles peuvent être omis, mais le statut et le périmètre sont obligatoires.

---

# 7. Règles anti-dispersion

1. Une nouvelle décision produit d’abord une modification de sa source autoritative.
2. Les index et résumés sont mis à jour dans la même PR.
3. Un rapport de PR ne devient jamais une source produit.
4. Un numéro de version historique ne doit pas rester présenté comme l’état courant.
5. Un document runtime ne réécrit pas la narration.
6. Un document UI ne définit pas une nouvelle route, trace ou permission.
7. Une maquette ne devient pas automatiquement une spécification.
8. Les choix abandonnés restent dans Git ; ils ne nécessitent pas un second document actif.
9. Toute duplication nécessaire doit contenir un lien vers l’autorité.
10. Une information contradictoire doit être supprimée ou explicitement marquée historique, jamais laissée à l’interprétation.

---

# 8. Statut des maquettes visuelles

Les concepts d’écrans générés pendant les échanges servent à valider une direction.

Ils ne sont pas :

- des assets finaux ;
- des designs personnages canoniques ;
- des contrats de texte ;
- des dimensions exactes de composants ;
- des captures du runtime.

Les décisions validées issues des maquettes sont transférées dans `docs/canon/ui/`.

Seuls ces documents ont autorité.

---

# 9. Statut du runtime historique

Le runtime sur `main` reste un prototype horizontal construit par couches V0.xx.

Il contient des fondations utiles :

- fils persistants ;
- chronologie ;
- notifications ;
- non-lus ;
- choix ;
- archives ;
- quelques journées et répétitions jouables.

Il ne définit plus :

- l’architecture narrative finale ;
- la résolution cible ;
- la structure UI cible ;
- les routes et états finaux.

Les anciens plans V0.xx restent des preuves historiques d’implémentation.

---

# 10. Reprise technique future

Toute reprise technique doit commencer par un document de branche qui cite explicitement :

```text
source narrative
source UI
contrat d’état
périmètre de données
fichiers runtime visés
fichiers historiques non autoritaires
tests d’acceptation
```

Une branche technique ne doit jamais commencer depuis un ancien rapport V0.xx seul.

---

# 11. Checklist de reprise

Avant toute modification :

- [ ] lire le portail canonique ;
- [ ] identifier la source autoritative du domaine ;
- [ ] vérifier si le document consulté est actif ou historique ;
- [ ] vérifier l’état réel du code sur `main` ;
- [ ] séparer décision produit et contrainte technique ;
- [ ] définir un lot court ;
- [ ] mettre à jour les index dans la même PR ;
- [ ] ne pas créer une seconde vérité pour contourner une contradiction.

---

# 12. Verdict

```text
NARRATION : source canonique signée
UI/UX : source canonique sous docs/canon/ui
RUNTIME : prototype historique à réconcilier
README / ROADMAP : portails synthétiques
ANCIENS DOCUMENTS V0.xx : historiques sauf référence explicite
```

> **Une reprise fiable ne dépend pas de connaître l’histoire du dépôt. Elle dépend de savoir immédiatement quel document a autorité aujourd’hui.**
