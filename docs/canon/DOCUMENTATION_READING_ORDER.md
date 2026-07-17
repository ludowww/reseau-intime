# Documentation Reading Order — Bible Narrative Current

> **Phase : registres narratifs et contrats d’état — lot B**

La Bible couvre l’architecture détaillée de J01 à J21.

J07–J21 sont validés narrativement sous autorités correctives.

L’audit global J01–J21 et le lot A de corrections bloquantes sont validés.

La prochaine étape est la formalisation des traces, promesses, connaissances, états et chemins accessibles.

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

`12E` reste une archive canonique d’architecture. Son ancien statut de production est supersédé par l’audit global des dialogues.

## Scripts, audits et corrections

```text
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

Ordre d’autorité actuel :

```text
script source
→ lot A lorsque concerné
→ audit global
```

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
→ lot B : registres et contrats d’état
→ lot C : consolidation des sources et statuts
→ lot D : polish des voix
→ validation Ludovic
→ décision de reprise technique
→ adaptation JSON/runtime
→ images ComfyUI
```

---

# 3. Gel technique

Aucune nouvelle modification technique J07–J21 avant :

- registres de traces, promesses et connaissances ;
- contrat d’état et matrice de reachability ;
- consolidation des sources ;
- passe de naturel ;
- décision explicite de reprise technique.

J06 reste techniquement non conforme jusqu’à la future migration.

---

# 4. Lot A — état validé

```text
A1 calendrier J17 / J21 corrigé
A2 promesse Sandra payée ou fermée en J12
A3 co-présence rendue conforme text-only
A4 posture finale C strictement conditionnelle
```

Les corrections vivent temporairement dans une autorité corrective dédiée jusqu’au lot C.

---

# 5. Lot B — prochaine tranche

Documents à produire :

```text
J01_J21_TRACE_REGISTRY.md
J01_J21_PROMISE_REGISTRY.md
J01_J21_KNOWLEDGE_REGISTRY.md
SEASON_1_NARRATIVE_STATE_CONTRACT.md
J01_J21_REACHABILITY_MATRIX.md
```

Objectifs :

- donner un identifiant à chaque trace réutilisable ;
- garantir que chaque promesse possède un statut ;
- attribuer chaque connaissance à une source ;
- borner les états relationnels ;
- prouver que chaque sortie majeure atteint une finale cohérente.

---

# 6. Tests obligatoires après lot B

- aucune trace J14/J21 sans identifiant ;
- aucune promesse sans date et statut ;
- aucune connaissance forte sans source ;
- aucun état synonyme non normalisé ;
- aucune branche fermée rouverte sans événement ;
- chaque aftercare possède un paiement ;
- chaque état J17 possède une variante J21 atteignable ;
- aucune explosion de centaines de flags.

---

# 7. Statut J01–J21

| Périmètre | Statut |
|---|---|
| Architecture J01–J21 | validée |
| Scripts J07–J21 | validés sous autorités correctives |
| Audit global des dialogues | validé |
| Lot A | validé |
| Lot B | prochaine étape |
| Runtime J07–J21 | gelé |
| Runtime J06 | non conforme |
| Images finales | à produire |

---

# 8. Règle finale

```text
Une histoire complexe devient implémentable
lorsque ses traces, ses promesses et ses connaissances
possèdent des identifiants aussi précis que ses dialogues.
```
