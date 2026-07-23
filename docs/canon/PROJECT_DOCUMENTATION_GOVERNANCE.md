# Réseau Intime — Gouvernance documentaire du projet

## Statut

**Catégorie : Canon de gouvernance actif**

**Périmètre : toute la documentation du dépôt**

**Autorité : définit où réside chaque vérité du projet et comment un document devient actif, historique ou obsolète**

Ce document garantit qu’une personne reprenant le projet puisse répondre sans ambiguïté à quatre questions :

```text
Que raconte actuellement le jeu ?
Que fait réellement le runtime ?
Quelle interface est canonique et laquelle est déjà implémentée ?
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
| Plan d’une branche technique | document ciblé sous `docs/runtime/` | branche ou PR correspondante |
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
    système visuel, écrans, états, implémentation et différé

docs/canon/runtime/
    contrat d’état narratif pré-runtime

docs/runtime/
    état technique, audits et plans d’implémentation
```

Sont historiques par défaut, sauf lien explicite depuis un index actif :

```text
docs/V0_*.md
docs/NN_*.md à la racine de docs/
docs/narrative/
docs/story_state/
anciens rapports de branche
```

Leur présence dans le dépôt ne leur donne aucune autorité actuelle.

---

# 5. Portails obligatoires

Une reprise de projet commence dans cet ordre :

```text
README.md
→ docs/canon/DOCUMENTATION_READING_ORDER.md
→ docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
→ autorité du domaine concerné
→ docs/runtime/README.md si travail technique
→ ROADMAP.md pour la priorité courante
```

Les portails doivent rester synthétiques. Ils pointent vers les sources ; ils ne les recopient pas intégralement.

---

# 6. En-tête recommandé

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

1. Une nouvelle décision produit modifie d’abord sa source autoritative.
2. Les index et portails concernés sont mis à jour dans le même lot.
3. Un rapport de branche ou de PR ne devient jamais une source produit.
4. Un numéro de version historique ne doit pas rester présenté comme l’état courant.
5. Un document runtime ne réécrit pas la narration.
6. Un document UI ne définit pas une nouvelle route, trace ou permission narrative.
7. Une maquette ne devient pas automatiquement une spécification.
8. Les choix abandonnés restent disponibles dans Git ; ils n’ont pas besoin d’un second document actif.
9. Toute duplication nécessaire contient un lien vers l’autorité.
10. Une contradiction est supprimée ou explicitement classée historique, jamais laissée à l’interprétation.
11. Un document racine ancien ne concurrence jamais `docs/canon/`.
12. Un statut d’implémentation distingue toujours cible canonique, prototype local et runtime final.

---

# 8. Statut des maquettes visuelles

Les concepts d’écrans générés pendant les échanges servent à valider une direction.

Ils ne sont pas :

- des assets finaux ;
- des designs personnages canoniques ;
- des contrats de texte ;
- des dimensions exactes de composants ;
- des captures du runtime final.

Les décisions validées sont transférées dans `docs/canon/ui/`. Seuls ces documents ont autorité.

---

# 9. État technique actuel

`main` contient désormais deux couches à distinguer :

## Runtime narratif historique

- chronologie et jours ;
- fils persistants ;
- messages et choix ;
- notifications et non-lus ;
- archives ;
- matériaux narratifs issus de couches V0.xx.

## Cœur UI portrait additif validé

- coque portrait ;
- Messages ;
- Galerie ;
- ImageMessage ;
- PhotoViewer ;
- états locaux `NEW / VIEWED / LOCKED` ;
- matrices responsive, safe areas, reduced motion et clavier.

Le projet conserve un contrôle historique `1280 × 720`. Le cœur portrait n’est pas encore une migration complète du runtime narratif, de la persistance, des vrais assets ou des écrans système.

Les anciens plans V0.xx restent des preuves historiques d’implémentation. Ils ne définissent plus l’architecture narrative ou UI.

---

# 10. Réouverture technique

L’extension UI est gelée par défaut après le checkpoint T‑UI‑03D.

Un nouveau lot technique doit citer explicitement :

```text
source narrative
source UI
contrat d’état
besoin bloquant ou objectif produit
périmètre de données
fichiers runtime visés
fichiers historiques non autoritaires
tests d’acceptation
```

Un lot UI ne se rouvre que pour :

- un besoin narratif bloquant ;
- les vrais assets ;
- la persistance ou la sauvegarde ;
- les écrans système explicitement décidés ;
- une régression avérée.

Une branche technique ne commence jamais depuis un ancien rapport V0.xx seul.

---

# 11. Checklist de reprise

Avant toute modification :

- [ ] lire le portail canonique ;
- [ ] identifier la source autoritative du domaine ;
- [ ] vérifier si le document consulté est actif ou historique ;
- [ ] vérifier l’état réel du code sur `main` ;
- [ ] séparer décision produit et contrainte technique ;
- [ ] définir un lot court ;
- [ ] synchroniser les portails concernés ;
- [ ] ne pas créer une seconde vérité pour contourner une contradiction.

---

# 12. Verdict actuel

```text
NARRATION : Bible active + corpus J01–J21 signé
UI/UX : cœur portrait implémenté et canon sous docs/canon/ui
RUNTIME : historique narratif + prototype portrait additif sur main
EXTENSION UI : gelée par défaut
PRIORITÉ : prochain lot narratif à cadrer depuis la Bible
ANCIENS DOCUMENTS : historiques sauf référence explicite
```

> **Une reprise fiable ne dépend pas de connaître l’histoire du dépôt. Elle dépend de savoir immédiatement quel document a autorité aujourd’hui.**
