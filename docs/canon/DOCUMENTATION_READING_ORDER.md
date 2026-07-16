# Documentation Reading Order — Bible Narrative Current

> **Phase : Bible Narrative complète / préparation de production**

La Bible couvre désormais l’architecture détaillée de J01 à J21.

Le runtime actif couvre J01 à J06.

---

# 1. Ordre de lecture officiel

## Vision

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
```

## Personnages

```text
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
cartes de réconciliation concernées
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

## Calendrier

```text
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
```

## Plans détaillés complets

```text
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
```

## Communication

```text
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEXT_ONLY_MESSAGING_CANON.md
```

Le canon text-only prévaut sur toute ancienne hypothèse d’appel, de vocal ou de scène audio.

## Runtime

Lire ensuite seulement :

- index actifs ;
- conversations JSON ;
- visual content ;
- ledgers ;
- tests ;
- rapports de version.

---

# 2. Chaîne de production

```text
plans détaillés validés
→ dialogues textuels
→ états minimaux
→ intégration runtime par tranche
→ images fournies par Ludovic via ComfyUI
→ métadonnées et galerie
→ tests
```

Les images ne doivent pas être conçues dans les documents de dialogues.

---

# 3. Statut J01–J21

| Journées | Plans | Dialogues finaux | Runtime |
|---|---|---|---|
| J01–J06 | complets / audit | existants à réconcilier | actif |
| J07–J08 | complets | à produire | non |
| J09–J12 | complets | à produire | non |
| J13–J16 | complets | à produire | non |
| J17–J21 | complets | à produire | non |

---

# 4. Règle text-only

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

Les événements hors téléphone restent possibles mais ne sont pas joués comme dialogues.

---

# 5. Visuels

Les documents de plans indiquent :

- nombre de slots ;
- fonction narrative ;
- audience ;
- permanence.

Ludovic fournit les images plus tard via ComfyUI.

Aucun plan détaillé ne fixe :

- pose ;
- cadrage ;
- tenue ;
- décor ;
- prompt ;
- workflow.

---

# 6. Prochaine tranche

```text
J01–J04 réconciliation narrative et runtime
```

Ordre recommandé :

1. Sandra J01 ;
2. déplacement du vernissage J03 ;
3. nouvelle origine Pauline/Nico J04 ;
4. tests ;
5. J05–J08.

---

# 7. Règle finale

```text
La saison est planifiée avant d’être dialoguée.
Les dialogues sont textuels avant d’être intégrés.
Les images sont fournies avant d’être finalisées.
Le runtime évolue par petites tranches validées.
```