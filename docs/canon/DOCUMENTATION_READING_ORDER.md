# Documentation Reading Order — Bible Narrative Current

> **Phase : validation narrative complète J07–J21 avec audit de conformité J01–J09**

La Bible couvre l’architecture détaillée de J01 à J21.

Le contrat opérationnel des voix est documenté.

J01–J09 possèdent désormais un audit transversal qui distingue conformité narrative, conformité visual-first et conformité runtime.

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

## Scripts narratifs et audit

```text
docs/canon/dialogues/README.md
docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
```

Ordre interne :

```text
script de journée
→ audit J01–J09
→ correction canonique ciblée
```

En cas de contradiction précise sur J07–J09, l’audit prévaut jusqu’à consolidation des scripts.

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
→ audit de conformité
→ validation de Ludovic
→ audit continuité / conséquences
→ validation narrative J01–J21
→ seulement ensuite adaptation technique
→ images fournies par Ludovic via ComfyUI
```

---

# 3. Gel technique

Aucune nouvelle modification technique J07–J21 avant validation narrative complète de la saison.

La PR technique J05–J06 ouverte avant cette décision reste séparée et ne devient pas une autorité narrative.

J06 reste techniquement non conforme tant que sa logique de candidate pool et de propriétaire R2 n’est pas remplacée lors de la future migration.

---

# 4. Tests obligatoires

Une journée doit passer :

- test North Star ;
- test de route invisible ;
- test de fonction unique ;
- test d’agence ;
- test de conséquence attribuable ;
- test sans nom ;
- test de substitution ;
- test de silhouette ;
- test banal ;
- test public / privé ;
- test text-only ;
- test d’audience visuelle ;
- test de fallback ;
- test des trois contenus principalement féminins.

---

# 5. Statut J01–J21

| Journées | Plans | Scripts / audit | Runtime |
|---|---|---|---|
| J01–J05 | complets | noyaux conformes, corrections et slots dans l’audit | actif partiel |
| J06 | complet | intention conforme dans l’audit | actif non conforme |
| J07 | complet | validé avec corrections de l’audit | legacy non canonique |
| J08 | complet | validé avec corrections de l’audit | legacy non canonique |
| J09 | complet | candidat + corrections de l’audit | legacy non canonique |
| J10–J12 | complets | prochaine tranche | non canonique / historique partiel |
| J13–J16 | complets | à produire | non |
| J17–J21 | complets | à produire | non |

---

# 6. Principes consolidés J01–J09

```text
une promesse importante doit être un vrai choix
un refus clair ferme réellement l’attente
une alternative précise peut réduire une collision
un fallback existe si les conditions disparaissent
regarder Marie et rejoindre sa vie ne sont pas le même acte
les trois contenus minimum restent principalement centrés sur les femmes
un visuel précise type, origine, auteur, audience et permanence
```

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

Corrections futures identifiées :

- J01 : narration indirecte dans les beats hors téléphone ;
- J02 : `Marie écrit`, pas `Marie appelle`, dans la transition.

---

# 8. Visuels

Le contrat narratif de trois slots est désormais défini pour J01–J09.

Les images finales ne sont pas produites.

Ludovic les fournira plus tard via ComfyUI.

La conformité produit visual-first ne sera acquise qu’après production, métadonnées et intégration.

---

# 9. Prochaine tranche

```text
validation de l’audit et de J09 corrigé
→ écriture J10
→ J11–J12
→ J13–J16
→ J17–J21
→ audit global des dialogues
```

---

# 10. Règle finale

```text
La saison est planifiée avant d’être dialoguée.
Les scripts sont audités avant validation.
Les promesses importantes ne sont pas forcées.
Les images ont une fonction et une audience.
La technique ne décide pas de la narration.
```