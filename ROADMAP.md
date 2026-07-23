# Réseau Intime — Roadmap active

## Statut

**Catégorie : Portail projet actif**

Cette roadmap résume la priorité courante. Elle ne remplace pas les sources canoniques.

---

# 1. État acquis

## Narration canonique

```text
North Star : validée
Personnages et voix : validés
Architecture Saison 1 : validée
Scripts J01–J21 : consolidés et signés
Contrats de traces / promesses / connaissances : validés
Reachability : validée
```

Le corpus signé reste autoritaire pour J01–J21. La Bible Narrative reste autoritaire pour toute nouvelle production, révision structurelle ou extension.

## UX/UI

```text
T‑UI‑01   Coque portrait                         TERMINÉ
T‑UI‑02   Famille Messages                       TERMINÉ
T‑UI‑03A  Gallery Core                           TERMINÉ
T‑UI‑03B  ImageMessage                           TERMINÉ
T‑UI‑03C  PhotoViewer                            TERMINÉ
T‑UI‑03D  Gallery States                         TERMINÉ
```

Acquis :

- coque portrait additive ;
- safe areas ;
- navigation Messages / Galerie ;
- conversations privées et de groupe ;
- choix, non-lus, notifications et typing ;
- transitions hors téléphone et de journée ;
- ImageMessage ;
- Galerie responsive par personnage ;
- PhotoViewer partagé ;
- états locaux `NEW / VIEWED / LOCKED` ;
- matrices `720 × 1280`, `1080 × 1920`, `1080 × 2340` ;
- reduced motion et navigation clavier.

Le cœur UI prototype est verrouillé. Son extension est gelée par défaut.

## Runtime

`main` contient :

- le runtime narratif historique V0.xx ;
- des réconciliations ciblées ;
- le cœur UI portrait additif validé ;
- les tests statiques et outils de validation.

La migration narrative complète, la persistance Galerie, la sauvegarde cible, les vrais assets et les écrans système ne sont pas encore intégrés comme flux final.

---

# 2. Positionnement de production verrouillé

## Saison 1

```text
J01–J21 restent la Saison 1 de référence.
```

Le corpus signé n’est pas rouvert comme chantier structurel général.

Les corrections restent autorisées uniquement lorsqu’elles sont ciblées et justifiées par :

- une contradiction avec la North Star ;
- une contradiction avec un canon personnage ;
- une rupture de continuité ou d’atteignabilité ;
- un problème de consentement, d’audience ou de conséquence ;
- une incohérence entre actes, séquences, dialogues, photos ou registres ;
- un blocage de production clairement démontré.

Une redistribution globale des actes, une nouvelle hiérarchie de routes ou une réécriture générale de J01–J21 exige une nouvelle décision produit explicite.

## Hiérarchie relationnelle

```text
Marie      centre dramatique obligatoire et transformation complète
Sandra     bascule complète possible
Mathilde   bascule complète possible
Pauline    promesse forte d’extension avec ligne autonome en Saison 1
Raphaëlle  graine structurante avec conséquence et futur concret
Nico       graine structurante avec décision engageante et conséquence
```

Cette hiérarchie ne signifie pas que Raphaëlle ou Nico sont décoratifs. Toutes les relations doivent changer, mais elles ne doivent pas toutes atteindre la même profondeur pendant la première saison.

## Carte de production autoritative

La carte `actes → séquences → scènes → images → conséquences → journées` existe déjà dans :

```text
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
```

Elle doit être lue avec :

```text
docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md
docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md
docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md
docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md
docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
```

Aucun second calendrier concurrent ne doit être créé.

---

# 3. Lot actif — NAR‑PROD‑01

## Audit de préparation à la production de la Saison 1

Objectif : transformer le corpus signé et la carte du document `11` en un état de production immédiatement exploitable, sans rouvrir l’architecture générale.

Pour chaque acte et chaque journée, l’audit doit vérifier :

- fonction dramatique ;
- séquences fixes et variables ;
- personnages directs et absences justifiées ;
- scènes obligatoires, variantes et mutations de refus ;
- conséquences, dettes, promesses et connaissances ;
- photos attendues, audience, permanence et fonction relationnelle ;
- cohérence avec les scripts J01–J21 signés ;
- statut de préparation.

Statuts autorisés :

```text
READY                 exploitable sans correction narrative
TARGETED_CORRECTION   correction locale nécessaire dans une source autoritative
MISSING_SPEC          précision manquante avant production ou intégration
```

Le livrable principal doit compléter ou corriger les sources autoritatives existantes. Il ne crée pas une deuxième carte de saison.

Hors périmètre de NAR‑PROD‑01 :

- réécriture générale des dialogues ;
- nouveau runtime ;
- nouveau lot UI ;
- production de vrais assets ;
- intégration JSON ;
- sauvegarde ou persistance Galerie ;
- nouvelle saison ou extension.

---

# 4. Gel technique pendant NAR‑PROD‑01

Par défaut :

```text
UI       GELÉE
RUNTIME  GELÉ
ASSETS   NON PRODUITS
```

Une réouverture technique n’est autorisée que si l’audit identifie :

1. un besoin narratif bloquant et concret ;
2. une donnée indispensable absente du contrat ;
3. une limite UI empêchant réellement une scène validée ;
4. une régression ;
5. un lot explicitement décidé après l’audit.

Une préférence esthétique ou une possibilité technique intéressante ne suffit pas.

---

# 5. Étapes suivantes après l’audit

L’ordre sera décidé à partir des résultats réels de NAR‑PROD‑01 :

```text
corrections narratives ciblées si nécessaires
→ spécification des photos réellement manquantes
→ choix d’un premier bloc d’adaptation runtime
→ intégration courte et testée
```

T‑UI‑04, la sauvegarde cible, les vrais assets et la migration globale restent différés jusqu’à justification concrète.

---

# 6. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ corrections dans la source autoritative
+ tests ou critères ciblés
+ aucun second document concurrent
```
