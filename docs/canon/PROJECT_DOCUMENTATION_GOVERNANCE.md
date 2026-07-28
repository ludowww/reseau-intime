# Réseau Intime — Gouvernance documentaire du projet

## Statut

**Catégorie : canon de gouvernance actif**

**Périmètre : toute la documentation du dépôt**

**Autorité : définit où réside chaque vérité du projet et comment un document devient actif, historique ou à réécrire**

Ce document doit permettre de répondre immédiatement à quatre questions :

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

Il ne peut pas modifier le canon produit. Le code, les données et les tests sur `main` restent l’autorité d’exécution.

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
| Contrat de continuité J01–J21 | `docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md` | plans de journée |
| Plan d’une branche technique | document ciblé sous `docs/runtime/` | branche correspondante |
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
    système visuel, écrans, états, fondation implémentée et différé

docs/canon/runtime/
    contrat d’état narratif pré-runtime

docs/runtime/
    état technique, contrat de continuité et plans d’implémentation
```

Sont historiques par défaut, sauf lien explicite depuis un index actif :

```text
docs/V0_*.md
docs/NN_*.md à la racine de docs/
docs/narrative/
docs/story_state/
anciens rapports de branche
observations runtime antérieures à Season1RuntimeProvider
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
→ contrat runtime J01–J03 si intégration J04+
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
12. Un statut d’implémentation distingue toujours cible canonique, fondation UI, runtime intégré et fonctions différées.
13. Une journée future ne crée pas une seconde chaîne de saison pour contourner le contrat J01–J03.
14. Une correction commune validée devient une règle des intégrations suivantes.

---

# 8. Statut des maquettes visuelles

Les concepts d’écrans générés pendant les échanges servent à valider une direction.

Ils ne sont pas :

- des assets finaux ;
- des designs personnages canoniques ;
- des contrats de texte ;
- des dimensions exactes de composants ;
- des captures du runtime final.

Les décisions validées sont transférées dans `docs/canon/ui/`. Seuls ces documents ont autorité produit.

---

# 9. État technique actuel

`main` contient trois réalités à distinguer.

## 9.1 Matériaux runtime historiques

- chronologie et anciens jours ;
- fils persistants ;
- messages et choix ;
- notifications et non-lus ;
- archives ;
- activités hors téléphone internes ;
- couches V0.xx et anciens index.

Ces matériaux sont des références historiques. Ils ne définissent plus automatiquement J04–J21.

## 9.2 Nouvelle chaîne Saison 1 J01–J03

- `Season1RuntimeProvider` ;
- `Season1State` partagé ;
- providers J01, J02 et J03 ;
- runtime maps bornées ;
- handoffs automatiques ;
- transcripts, fils et contenus cumulatifs ;
- temps narratif autoritaire ;
- snapshots versionnés ;
- restauration de la chaîne ;
- tests statiques et smokes jouables.

Statut :

```text
J01→J03 intégrés et validés
J04→J21 canoniques, non intégrés dans cette chaîne
```

## 9.3 Cœur UI portrait validé

- coque portrait ;
- Messages ;
- Galerie ;
- ImageMessage ;
- PhotoViewer ;
- états locaux `NEW / VIEWED / LOCKED` ;
- livraison progressive ;
- bandeau jour/heure ;
- notifications interactives ;
- transitions unifiées ;
- DayDivider par `source_day` ;
- matrices responsive, safe areas, reduced motion et clavier.

La baseline technique courante est :

```text
c27bd9331c01bed6c9a40c0c642d246cf26bb6cf
```

Le projet conserve un contrôle historique `1280 × 720`. La migration J04–J21, la persistance Galerie, les vrais assets et les écrans système restent incomplètes.

---

# 10. Réouverture technique

Un nouveau lot technique doit citer explicitement :

```text
source narrative
source UI
contrat d’état
contrat runtime J01–J03
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

Une intégration de journée ne doit pas contourner :

- l’orchestrateur de saison ;
- le handoff cumulatif ;
- le temps narratif commun ;
- la livraison Messages ;
- les notifications ;
- les transitions ;
- les snapshots ;
- la non-régression J01–J03.

---

# 11. Checklist de reprise

Avant toute modification :

- [ ] lire le portail canonique ;
- [ ] identifier la source autoritative du domaine ;
- [ ] vérifier si le document consulté est actif ou historique ;
- [ ] vérifier l’état réel du code sur `main` ;
- [ ] séparer décision produit et contrainte technique ;
- [ ] lire le contrat J01–J03 pour toute intégration J04+ ;
- [ ] définir un lot court ;
- [ ] préserver les corrections communes ;
- [ ] synchroniser les portails concernés ;
- [ ] ne pas créer une seconde vérité pour contourner une contradiction.

---

# 12. Verdict actuel

```text
NARRATION : Bible active + corpus J01–J21 signé
UI/UX : fondation portrait canonique et runtime stabilisé
RUNTIME : J01–J03 intégrés dans la nouvelle chaîne
J04–J21 : prêts narrativement, à intégrer
EXTENSION UI : gelée par défaut
PRIORITÉ : intégration J04 depuis la baseline J01–J03
ANCIENS DOCUMENTS : historiques sauf référence explicite
```

> **Une reprise fiable ne dépend pas de connaître l’histoire du dépôt. Elle dépend de savoir immédiatement quel document a autorité et quelle partie du produit est réellement jouable aujourd’hui.**
