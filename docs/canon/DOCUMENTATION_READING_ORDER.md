# Documentation Reading Order — Bible Narrative Current

> **Phase : validation narrative complète J07–J21**

La Bible couvre l’architecture détaillée de J01 à J21.

Le contrat opérationnel des voix est documenté.

La priorité actuelle est d’écrire et valider tous les scripts narratifs jusqu’à J21 avant toute nouvelle intégration technique.

---

# 1. Ordre de lecture officiel

## Vision

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
```

## Personnages et voix

```text
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/bible/13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
cartes de réconciliation concernées
```

Ordre d’autorité :

```text
identité du personnage
→ propriété lexicale et distinction
→ exécution opérationnelle en messagerie
→ dialogue précis
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

## Calendrier et plans détaillés

```text
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
```

## Scripts narratifs candidats

```text
docs/canon/dialogues/README.md
docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md
```

Ces scripts sont validés narrativement avant toute production JSON ou runtime.

## Communication

```text
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEXT_ONLY_MESSAGING_CANON.md
```

Le canon text-only prévaut sur toute ancienne hypothèse d’appel, de vocal ou de scène audio.

## Runtime

Lire les index, conversations JSON, ledgers et tests uniquement pour :

- auditer l’existant ;
- préparer une future migration ;
- vérifier la compatibilité après validation narrative.

Le runtime ne dirige plus l’écriture J07–J21.

---

# 2. Chaîne de production actuelle

```text
plan détaillé validé
→ carte de voix
→ script narratif complet
→ validation de Ludovic
→ audit continuité / voix / conséquences
→ validation narrative J01–J21
→ seulement ensuite adaptation technique
→ images fournies par Ludovic via ComfyUI
```

---

# 3. Gel technique

Aucune nouvelle modification technique J07–J21 avant validation narrative complète de la saison.

La PR technique J05–J06 ouverte avant cette décision reste séparée et ne devient pas une autorité narrative.

---

# 4. Tests de voix obligatoires

Une scène doit passer :

- test sans nom ;
- test de substitution ;
- test de silhouette ;
- test banal ;
- test sous stress ;
- test public / privé ;
- test anti-punchline ;
- test de contamination professionnelle ;
- test Player ;
- test text-only.

---

# 5. Statut J01–J21

| Journées | Plans | Scripts narratifs | Runtime |
|---|---|---|---|
| J01–J06 | complets | dialogues existants / audit en cours | actif |
| J07 | complet | validé par Ludovic | legacy non canonique |
| J08 | complet | candidat à validation | legacy non canonique |
| J09–J12 | complets | prochaine tranche | non canonique / partiel historique |
| J13–J16 | complets | à produire | non |
| J17–J21 | complets | à produire | non |

---

# 6. Continuité validée J07→J08

```text
J07 crée :
- Raphaëlle avant mardi 19 h
- Nico mardi 18 h 45
- foyer mardi 19 h 15, alternative ou refus

J08 paie :
- anticipation
- priorité
- amendement
- conséquence
```

Le refus honnête ferme réellement une obligation.

L’alternative précise peut réellement réduire la collision.

---

# 7. Règle text-only

Tout dialogue jouable est :

- message texte ;
- réponse textuelle ;
- notification ;
- commentaire d’image ;
- message de groupe.

Sont exclus :

- appels joués ;
- messages vocaux ;
- notes vocales ;
- scènes audio ;
- choix de dialogue oral ;
- transcriptions d’appels utilisées comme gameplay.

---

# 8. Visuels

Les scripts indiquent uniquement :

- nombre de slots ;
- fonction narrative ;
- audience ;
- permanence.

Ludovic fournit les images plus tard via ComfyUI.

---

# 9. Prochaine tranche

```text
validation J08
→ écriture J09
→ J10–J12
→ J13–J16
→ J17–J21
→ audit global des dialogues
```

---

# 10. Règle finale

```text
La saison est planifiée avant d’être dialoguée.
Les dialogues J07–J21 sont validés avant toute intégration.
La voix est testée avant le runtime.
La technique ne décide pas de la narration.
```