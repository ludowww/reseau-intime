# Documentation Reading Order — Bible Narrative Current

> **Phase : Bible Narrative complète / préparation de production dialoguée**

La Bible couvre l’architecture détaillée de J01 à J21.

Le contrat opérationnel des voix est désormais documenté.

Le runtime actif couvre J01 à J06.

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
→ carte de voix de la scène
→ dialogue textuel
→ tests de distinction
→ états minimaux
→ intégration runtime par tranche
→ images fournies par Ludovic via ComfyUI
→ métadonnées et galerie
→ tests
```

Les images ne doivent pas être conçues dans les documents de dialogues.

---

# 3. Contrat de voix avant écriture

Avant chaque scène dialoguée, définir :

```text
principal_speaker
voice_state
public_or_private
message_burst_shape
humor_mode
defense_mode
punctuation_mode
emoji_budget
forbidden_leakage
voice_change_at_choice
voice_change_at_exit
```

Ces champs servent à l’écriture.

Ils ne doivent pas devenir automatiquement des données runtime.

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

Règle :

```text
le lecteur doit reconnaître la personne
avant le nom
sans dépendre d’une catchphrase
```

---

# 5. Statut J01–J21

| Journées | Plans | Dialogues finaux | Runtime |
|---|---|---|---|
| J01–J06 | complets / audit | existants à réconcilier | actif |
| J07–J08 | complets | à produire | non |
| J09–J12 | complets | à produire | non |
| J13–J16 | complets | à produire | non |
| J17–J21 | complets | à produire | non |

---

# 6. Règle text-only

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

# 7. Visuels

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

# 8. Prochaine tranche

```text
J01–J04 réconciliation narrative et runtime
```

Ordre recommandé :

1. Sandra J01 avec le document `13` ;
2. déplacement du vernissage J03 ;
3. nouvelle origine Pauline/Nico J04 ;
4. tests de voix et de runtime ;
5. J05–J08.

---

# 9. Règle finale

```text
La saison est planifiée avant d’être dialoguée.
La voix est cadrée avant que la scène soit écrite.
Le dialogue est testé avant d’être intégré.
Les images sont fournies avant d’être finalisées.
Le runtime évolue par petites tranches validées.
```