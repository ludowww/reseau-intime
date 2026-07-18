# Documentation Reading Order — Bible Narrative Current

> **Phase : polish des voix et naturel — lot D**

La Bible couvre l’architecture détaillée de J01 à J21.

J07–J21 sont validés narrativement sous autorités correctives.

L’audit global et les lots A, B et C sont validés.

La prochaine étape est la validation finale du corpus narratif avant toute reprise technique.

---

# 1. Ordre de lecture officiel

## Vision

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
```

## Personnages, voix et adulte

```text
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/bible/13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

## Architecture

```text
docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md
docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md
docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md
docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md
docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md
```

## Scènes, images et conséquences

```text
docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md
docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md
docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md
```

## Plans détaillés

```text
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
```

`12E` reste une archive canonique d’architecture. Son ancien statut de production est supersédé par les audits et contrats actuels.

## Scripts, audits et corrections

```text
docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md
docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J15_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J16_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J20_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md
docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md
```

## Contrats pré-runtime

```text
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
```

Ordre d’autorité actuel :

```text
script source
→ lot A lorsque concerné
→ registres et contrat d’état
→ reachability matrix
→ audit global
```

Le lot C doit supprimer progressivement la nécessité de l’overlay lot A en intégrant les corrections dans les scripts.

## Communication

```text
docs/canon/TEXT_ONLY_MESSAGING_CANON.md
```

---

# 2. Chaîne de production

```text
plan détaillé
→ script complet
→ audit global validé
→ lot A : continuité bloquante validée
→ lot B : registres et contrats d’état validés
→ lot C : consolidation des sources et statuts validée
→ lot D : polish des voix validé
→ validation Ludovic
→ décision de reprise technique
→ adaptation JSON/runtime
→ images ComfyUI
```

---

# 3. Gel technique

Aucune nouvelle modification technique J07–J21 avant :

- consolidation des scripts sources ;
- résolution des créateurs et traces encore ouverts ;
- consolidation J01–J09 ;
- passe de naturel ;
- décision explicite de reprise technique.

J06 reste techniquement non conforme jusqu’à la future migration.

---

# 4. Lot B — état validé

```text
28 traces de branche avec audience et retrait
24 promesses avec dates et statuts
44 faits de connaissance avec sources et certitudes
contrat d’état borné sans scores
reachability de chaque sortie J17 vers J21
```

Décisions structurantes :

- aucune image de scène ne devient preuve ;
- aucune promesse ne repose sur un booléen vague ;
- aucune connaissance forte n’existe sans source ;
- aucun score de route ou propriétaire de vague ;
- la finale lit `final_trace_id` et les contradictions déjà actives.

---

# 5. Lot C — état validé

Travaux documentaires :

```text
C1 intégrer les corrections J01–J09 dans les sources autoritatives
C2 intégrer le lot A dans J10, J12, J14, J17 et J21
C3 remplacer les formulations génériques par trace_id / promise_id / fact_id
C4 fixer les créateurs d’image encore non résolus
C5 sourcer ou réduire la connaissance Pauline / Marie en J19
C6 renforcer dans J11 l’indépendance matérielle Mathilde
C7 marquer clairement les documents historiques supersédés
```

Le lot C a consolidé les corrections et identifiants dans les sources documentaires sans modifier le runtime.

---

# 6. Tests obligatoires après lot C

- aucun passage contradictoire avec le lot A ne reste dans les scripts ;
- chaque trace citée possède un `trace_id` ;
- chaque promesse importante possède un `promise_id` ;
- chaque affirmation de connaissance forte possède un `fact_id` ;
- les créateurs d’images diégétiques sont exacts ;
- la branche physique Mathilde exige une indépendance matérielle réelle ;
- les anciens audits servent d’historique, pas de patch mental ;
- aucun runtime ou asset modifié.

---

# 7. Statut J01–J21

| Périmètre | Statut |
|---|---|
| Architecture J01–J21 | validée |
| Scripts J07–J21 | validés sous autorités correctives |
| Audit global des dialogues | validé |
| Lot A | validé |
| Lot B | validé |
| Lot C | validé |
| Lot D | validé |
| Runtime J07–J21 | gelé |
| Runtime J06 | non conforme |
| Images finales | à produire |

---

# 8. Règle finale

```text
Les contrats définissent maintenant la vérité narrative.
Les scripts disent maintenant directement la vérité des contrats.
Le lot D doit leur rendre une voix plus humaine sans changer cette vérité.
```
