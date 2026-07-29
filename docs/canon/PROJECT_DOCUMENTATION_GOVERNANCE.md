# Réseau Intime — Gouvernance documentaire du projet

## Statut

**Catégorie : canon de gouvernance actif**

**Périmètre : toute la documentation du dépôt**

**Autorité : définit où réside chaque vérité du projet et comment un document devient actif, historique ou à réécrire**

Ce document doit permettre de répondre immédiatement à quatre questions :

```text
Que raconte actuellement le jeu ?
Que fait réellement le runtime ?
Quelle interface est canonique et laquelle est implémentée ?
Quel document prévaut en cas de contradiction ?
```

---

# 1. Principe de source unique

Une décision ne possède qu’une seule source autoritative.

Les autres documents peuvent résumer, indexer, préparer une implémentation ou rapporter une validation. Ils ne redéfinissent pas la décision.

Exemple :

```text
couleur UI de Marie
→ docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md

README.md
→ peut rappeler qu’une couleur existe
→ ne peut pas en fixer une autre
```

---

# 2. Quatre statuts documentaires

## `ACTIVE_CANON`

Définit ce que le produit doit être : North Star, personnages, scripts consolidés, contrats narratifs et UI produit.

## `ACTIVE_RUNTIME`

Décrit l’état réellement implémenté ou le contrat d’une baseline technique validée. Il ne modifie pas le canon produit. Le code, les données et les tests sur `main` restent l’autorité d’exécution.

## `HISTORICAL`

Conservé pour comprendre une version, une migration ou une décision passée. Il ne sert pas d’instruction active.

## `TO_REWRITE`

Contient encore des éléments utiles mais incompatibles avec les autorités actuelles. Il ne peut pas bloquer une implémentation conforme.

---

# 3. Autorité par domaine

| Domaine | Source autoritative | Résumés autorisés |
|---|---|---|
| Vision produit | `docs/canon/bible/` | `README.md`, `ROADMAP.md` |
| Personnages et voix | `docs/canon/characters/` + Bible voix | index canoniques |
| Narration J01–J21 | `docs/canon/dialogues/` + sign-off | portails et statuts |
| État narratif | registres + `SEASON_1_NARRATIVE_STATE_CONTRACT.md` | plans runtime |
| Communication text-only | `docs/canon/TEXT_ONLY_MESSAGING_CANON.md` | docs UI/runtime |
| UX/UI produit | `docs/canon/ui/` | portails et plans techniques |
| Runtime actif | code, données et tests sur `main` | `docs/runtime/README.md` |
| Continuité J01–J21 | `docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md` | plans de journée |
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
    sources J01–J21, registres, sign-off et paquets

docs/canon/ui/
    système visuel, écrans, états et handoff produit

docs/canon/runtime/
    contrat d’état narratif pré-runtime

docs/runtime/
    état technique, continuité et plans d’implémentation
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

Leur présence ne leur donne aucune autorité actuelle.

---

# 5. Portails obligatoires

Une reprise de projet commence dans cet ordre :

```text
README.md
→ docs/canon/DOCUMENTATION_READING_ORDER.md
→ docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
→ autorité du domaine concerné
→ docs/runtime/README.md pour un travail technique
→ contrat runtime J01–J04 pour une intégration J05+
→ ROADMAP.md pour la priorité courante
```

Les portails restent synthétiques. Ils pointent vers les sources sans les recopier intégralement.

---

# 6. En-tête recommandé

Tout document important précise autant que nécessaire :

```text
Catégorie
Statut
Périmètre
Autorité
Supersède
Supersédé par
Base validée ou branche concernée
```

Le statut et le périmètre sont obligatoires.

---

# 7. Règles anti-dispersion

1. Une décision produit modifie d’abord sa source autoritative.
2. Les portails concernés sont synchronisés dans le même lot.
3. Un rapport de branche ou de PR ne devient jamais une source produit.
4. Un numéro de version historique ne reste pas présenté comme courant.
5. Un document runtime ne réécrit pas la narration.
6. Un document UI ne crée pas de route, trace ou permission narrative.
7. Une maquette ne devient pas automatiquement une spécification.
8. Les choix abandonnés restent dans Git ; ils n’exigent pas un second document actif.
9. Toute duplication nécessaire contient un lien vers l’autorité.
10. Une contradiction est supprimée ou explicitement classée historique.
11. Un document racine ancien ne concurrence jamais `docs/canon/`.
12. Un statut distingue cible canonique, fondation UI, runtime intégré et différé.
13. Une journée future ne crée pas une seconde chaîne de saison.
14. Une correction commune validée devient une règle des intégrations suivantes.
15. Les non-lus passent par `RuntimeUnread` ; aucun provider ne recrée sa logique locale.
16. Les notifications narratives restent neutres et n’exposent pas le contenu avant lecture.
17. Un badge numérique de non-lus ne doit pas être réintroduit sans décision produit explicite.

---

# 8. Statut des maquettes visuelles

Les concepts d’écrans générés pendant les échanges servent à valider une direction.

Ils ne sont pas :

- des assets finaux ;
- des designs personnages canoniques ;
- des contrats de texte ;
- des dimensions exactes de composants ;
- des captures du runtime final.

Les décisions validées sont transférées dans `docs/canon/ui/`.

---

# 9. État technique actuel

## 9.1 Matériaux historiques

Le dépôt conserve des couches V0.xx, anciens index et anciennes journées. Ils servent à la traçabilité et à la localisation, pas à définir automatiquement J05–J21.

## 9.2 Chaîne Saison 1 J01–J04

La baseline active contient :

- `Season1RuntimeProvider` ;
- `Season1State` partagé ;
- providers J01, J02, J03 et J04 ;
- runtime maps bornées ;
- handoffs automatiques ;
- transcripts, fils et contenus cumulatifs ;
- temps narratif autoritaire ;
- snapshots versionnés ;
- `RuntimeUnread` ;
- tests statiques et smokes jouables.

Statut :

```text
J01→J04 intégrés et validés
J05→J21 canoniques, non intégrés dans la chaîne active
```

Baseline technique :

```text
5a6a832c148c68ee69d8991474ec778f33bc456d
runtime-s1-04-j04-playable
```

## 9.3 Cœur UI portrait

- coque portrait ;
- Messages ;
- Galerie ;
- ImageMessage ;
- PhotoViewer ;
- états locaux Galerie ;
- livraison progressive ;
- bandeau jour/heure ;
- notifications interactives neutres ;
- transitions unifiées ;
- DayDivider par `source_day` ;
- non-lus sans badge ;
- responsive, safe areas, reduced motion et clavier.

Les vrais assets, la persistance Galerie, les écrans système et la migration J05–J21 restent incomplets.

---

# 10. Réouverture technique

Un nouveau lot technique cite explicitement :

```text
source narrative
source UI
contrat d’état
contrat runtime J01–J04
objectif produit ou besoin bloquant
périmètre de données
fichiers runtime visés
fichiers historiques non autoritaires
tests d’acceptation
```

Une intégration de journée ne contourne jamais :

- l’orchestrateur ;
- le handoff cumulatif ;
- le temps narratif ;
- la livraison Messages ;
- `RuntimeUnread` ;
- les notifications ;
- les transitions ;
- les snapshots ;
- la non-régression J01–J04.

L’UI ne se rouvre que pour un besoin narratif bloquant, les vrais assets, la persistance, les écrans système décidés ou une régression avérée.

---

# 11. Checklist de reprise

Avant toute modification :

- [ ] lire le portail canonique ;
- [ ] identifier la source autoritative ;
- [ ] vérifier le statut actif ou historique ;
- [ ] vérifier `main` ;
- [ ] séparer produit et technique ;
- [ ] lire le contrat J01–J04 pour J05+ ;
- [ ] définir un lot court ;
- [ ] préserver les corrections communes ;
- [ ] synchroniser les portails ;
- [ ] ne pas créer une seconde vérité.

---

# 12. Verdict actuel

```text
NARRATION : Bible active + corpus J01–J21 signé
UI/UX : fondation portrait canonique et runtime stabilisé
RUNTIME : J01–J04 intégrés dans la nouvelle chaîne
J05–J21 : prêts narrativement, à intégrer
BASELINE : 5a6a832c148c68ee69d8991474ec778f33bc456d
EXTENSION UI : gelée par défaut
PRIORITÉ : intégration J05 depuis la baseline J01–J04
ANCIENS DOCUMENTS : historiques sauf référence explicite
```

> Une reprise fiable dépend de savoir immédiatement quelle source a autorité et quelle partie du produit est réellement jouable.